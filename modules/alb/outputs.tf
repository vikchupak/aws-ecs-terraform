output alb_dns_name {
  value = aws_lb.ecs-alb.dns_name
}

output alb_https_listener_arn {
  value = aws_lb_listener.https.arn
}

output alb_sg_id {
  value = aws_security_group.alb_sg.id
}
