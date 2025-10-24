terraform {
  backend "s3" {
    bucket = "ecs-terraform-state-unique"
    key = "shared_infra/alb.tfstate"
    region = "us-east-1" # no vars can be used here
    # dynamodb_table = "terraform-locks" 
    encrypt = true
  }
}