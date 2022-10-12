# Debian 11 Bullseye
data "aws_ami" "debian_11" {
  most_recent = true
  owners      = ["136693071363"]
  filter {
    name   = "name"
    values = ["debian-11-amd64-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_key_pair" "new_key" {
  key_name   = "tf-${var.instance_name}-key"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKKlxo3TsVzVf56R1YxI6oqc9MOY6kAdERwtV7Hwo6Q7 peter@xps-15"
}

resource "aws_iam_instance_profile" "new_profile" {
  name = "tf-${var.instance_name}-instance-profile"
  role = aws_iam_role.new_role.name
}

resource "aws_instance" "new_ec2" {
  ami                         = data.aws_ami.debian_11.id
  instance_type               = "t2.micro"
  vpc_security_group_ids      = [var.security_group_id]
  key_name                    = aws_key_pair.new_key.id
  iam_instance_profile        = aws_iam_instance_profile.new_profile.name
  user_data                   = file("${path.module}/scripts/install_lab.sh")
  subnet_id                   = var.subnet_id
  associate_public_ip_address = true


  root_block_device {
    delete_on_termination = true
  }

  metadata_options {
    http_endpoint = "enabled"
    http_tokens = "required"
  }

  tags = {
    Name = "tf-${var.instance_name}-ec2"
  }
}

