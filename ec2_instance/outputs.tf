output "instance_ip_addr" {
  value = aws_instance.new_ec2.public_ip
}