output "dns_name" {
  description = "The DNS name of the ALB"
  value       = aws_lb.main.dns_name
}

output "zone_id" {
  description = "The canonical hosted zone ID of the ALB"
  value       = aws_lb.main.zone_id
}

output "target_group_id" {
  description = "Target group ID"
  value       = aws_lb_target_group.main.id
}

output "security_group_id" {
  description = "Security group ID"
  value       = aws_security_group.alb.id
}