# Providers and their configurations

provider "aws" {
  region = data.terraform_remote_state.shared_alb.outputs.region
}
