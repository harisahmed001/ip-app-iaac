
output "vpc_id" {
  description = "VPC id"
  value       = module.vpc.vpc_id
}

output "public_subnets" {
  description = "Public subnet ids"
  value       = module.vpc.public_subnets
}

output "private_subnets" {
  description = "Private subnet ids"
  value       = module.vpc.private_subnets
}

output "all_subnets" {
  description = "All subnet ids"
  value       = module.vpc.all_subnets
}

output "db_instance_endpoint" {
  description = "RDS connection endpoint"
  value       = module.rds.db_instance_endpoint
}
