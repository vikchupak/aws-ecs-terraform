output alb_dns_name {
  value = module.alb.alb_dns_name
}

output alb_https_listener_arn {
  value = module.alb.alb_https_listener_arn
}

output alb_sg_id {
  value = module.alb.alb_sg_id
}

output region {
  value = var.region
}

output vpc_id {
  value = var.vpc_id
}

output public_subnets {
  value = var.public_subnets
}
