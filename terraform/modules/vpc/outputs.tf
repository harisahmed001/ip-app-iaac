output "vpc_id" {
  value = aws_vpc.vpc_main.id
}

output "public_subnets" {
  value = aws_subnet.public_subnet.*.id
}

output "private_subnets" {
  value = aws_subnet.private_subnet.*.id
}

output "all_subnets" {
  value = concat(aws_subnet.public_subnet.*.id, aws_subnet.private_subnet.*.id)
}

output "eip" {
  value = try(aws_eip.nat_eip[0].public_ip, "")
}
