# Project dependency requirements

terraform {
  # Min Terraform version
  required_version = ">= 1.10.3"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
      # OR we can set exact version
      # version = "5.96.0"
    }
  }
}
