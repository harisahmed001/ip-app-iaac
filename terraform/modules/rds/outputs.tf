output "db_instance_endpoint" {
  description = "The connection endpoint"
  value       = aws_db_instance.rds_instance.endpoint
}