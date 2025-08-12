output "api_token_secret_arn" {
  description = "The ARN of the API token secret"
  value       = aws_secretsmanager_secret.api_token.arn
}

output "endpoint" {
  description = "The endpoint of the Timestream InfluxDB instance."
  value       = aws_timestreaminfluxdb_db_instance.db.endpoint
}

output "security_group_id" {
  description = "The security group ID of the Timestream InfluxDB instance."
  value       = aws_security_group.db.id
}