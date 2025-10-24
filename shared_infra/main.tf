module "alb" {
  source = "../modules/alb"
  vpc_id = var.vpc_id
  public_subnets = var.public_subnets
  certificate_arn = var.certificate_arn
}