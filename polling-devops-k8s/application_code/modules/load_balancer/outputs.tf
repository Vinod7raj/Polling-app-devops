output "alb_dns_name" {
  value = aws_lb.polling_alb.dns_name
}

output "frontend_tg" {
  value = aws_lb_target_group.frontend_tg.arn
}

output "backend_tg" {
  value = aws_lb_target_group.backend_tg.arn
}
