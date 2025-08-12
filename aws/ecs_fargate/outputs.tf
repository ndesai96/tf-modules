output "alb_dns_name" {
  description = "The DNS name of the ALB."
  value       = module.alb.dns_name
}

output "alb_zone_id" {
  description = "The canonical hosted zone ID of the ALB."
  value       = module.alb.zone_id
}

output "security_group_id" {
  description = "The security group ID of the ECS service/tasks."
  value       = aws_security_group.ecs.id
}
