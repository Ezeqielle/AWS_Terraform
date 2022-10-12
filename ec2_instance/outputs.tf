output "instance_ip_addr" {
  value = aws_instance.kungfu_ec2.public_ip
}