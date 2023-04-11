output "vpc_id" {
  value = aws_vpc.vpc_main.id
  description = "Vpc Id"
}

output "public_subnets" {
  value = aws_subnet.public_subnet.*.id
  description = "Public subnets"
}

output "private_subnets" {
  value = aws_subnet.private_subnet.*.id
  description = "Private subnets"
}

output "all_subnets" {
  value = concat(aws_subnet.public_subnet.*.id, aws_subnet.private_subnet.*.id)
  description = "All subnets"
}

output "eip" {
  value = try(aws_eip.nat_eip[0].public_ip, "")
  description = "Elastic IP"
}
