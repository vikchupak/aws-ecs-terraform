resource "aws_ecs_cluster" "this" {
  name = "${var.env}-cluster"
}

resource "aws_security_group" "ecs_sg" {
  name = "${var.env}-ecs-sg"
  description = "Allow ALB to ECS (${var.env})"
  vpc_id = var.alb_vpc_id

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    security_groups = [var.alb_sg_id]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb_target_group" "this" {
  name = "${var.env}-tg"
  port = 80
  protocol = "HTTP"
  target_type = "ip"
  vpc_id = var.alb_vpc_id

  health_check {
    path = "/"
  }
}

resource "aws_lb_listener_rule" "this" {
  listener_arn = var.alb_https_listener_arn
  priority = var.ecs_alb_https_listener_rule_priority

  condition {
    host_header {
      values = [var.ecs_alb_hostname]
    }
  }

  action {
    type  = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}

resource "aws_iam_role" "task_exec_role" {
  name = "${var.env}-ecsTaskExecutionRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "ecs-tasks.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "task_exec_policy" {
  role = aws_iam_role.task_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_cloudwatch_log_group" "this" {
  name = "/ecs/${var.env}-nginx"
  retention_in_days = 7
}

resource "aws_ecs_task_definition" "this" {
  family = "${var.env}-nginx"
  cpu = "256"
  memory = "512"
  network_mode = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn = aws_iam_role.task_exec_role.arn

  container_definitions = jsonencode([
    {
      name = "nginx"
      image = "nginx:latest"
      essential = true
      portMappings = [{ containerPort = 80 }]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group = "/ecs/${var.env}-nginx"
          awslogs-region = var.alb_region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}

resource "aws_ecs_service" "this" {
  name = "${var.env}-service"
  cluster = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.this.arn
  desired_count = var.ecs_desired_count
  launch_type = "FARGATE"

  network_configuration {
    assign_public_ip = true
    subnets = var.alb_public_subnets
    security_groups = [aws_security_group.ecs_sg.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.this.arn
    container_name = "nginx"
    container_port = 80
  }

  depends_on = [aws_lb_listener_rule.this]
}
