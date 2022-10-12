output "new_subnet_id" {
  value = aws_subnet.new_subnet.id
}

output "security_group_id" {
  value = aws_security_group.allowed_in_out.id
}

output "vpc_id" {
  value = aws_vpc.new_vpc.id
}