

output "lb_dns" {
  description = "DNS for Application LoadBalancer"
  value       = aws_lb.app_lb.dns_name
}

output "lb_arn" {
  description = "Arn for Application LoadBalancer"
  value       = aws_lb.app_lb.arn

}