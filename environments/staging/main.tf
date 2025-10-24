data "terraform_remote_state" "shared_alb" {
  backend = "s3"
  config = {
    bucket = "ecs-terraform-state-unique"
    key = "shared_infra/alb.tfstate" 
    region = "us-east-1"
  }
}

module "ecs_cluster" {
  source = "../../modules/ecs"

  # Pass ALB outputs using the data source
  alb_region = data.terraform_remote_state.shared_alb.outputs.region
  alb_vpc_id = data.terraform_remote_state.shared_alb.outputs.vpc_id
  alb_public_subnets = data.terraform_remote_state.shared_alb.outputs.public_subnets
  alb_sg_id = data.terraform_remote_state.shared_alb.outputs.alb_sg_id
  alb_https_listener_arn = data.terraform_remote_state.shared_alb.outputs.alb_https_listener_arn

  env = var.env
  ecs_alb_hostname = var.ecs_alb_hostname
  ecs_alb_https_listener_rule_priority = var.ecs_alb_https_listener_rule_priority
  ecs_desired_count = var.ecs_desired_count
}
