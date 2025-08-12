output "db_credentials" {
  description = "The ARN of the AWS Secrets Manager secret containing the database credentials."
  value       = aws_timestreaminfluxdb_db_instance.db.influx_auth_parameters_secret_arn
}

output "security_group_id" {
  description = "The security group ID of the Timestream InfluxDB instance."
  value       = aws_security_group.db.id
}