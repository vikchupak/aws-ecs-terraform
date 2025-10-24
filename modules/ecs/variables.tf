variable env {
  type = string
}

variable alb_region {
  type = string
}

variable alb_vpc_id {
  type = string
}

variable alb_public_subnets {
  type = list(string)
}

variable alb_sg_id {
  type = string
}

variable alb_https_listener_arn {
  type = string
}

variable ecs_alb_hostname {
  type = string
  description = "Hostname for the application load balancer to route traffic to ECS"
}

variable ecs_alb_https_listener_rule_priority {
  type = number
  description = "Priority for the ALB listener rule"
}

variable ecs_desired_count {
  type = number
}
