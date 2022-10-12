resource "aws_vpc" "new_vpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name = "vpc_${var.network_name}"
  }
}

resource "aws_internet_gateway" "new_gateway" {
  vpc_id = aws_vpc.new_vpc.id
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.new_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.new_gateway.id
  }
  tags = {
    Name = "rt_${var.network_name}"
  }
}

resource "aws_subnet" "new_subnet" {
  vpc_id            = aws_vpc.new_vpc.id
  cidr_block        = var.subnet_cidr
  availability_zone = "eu-west-3a"

  tags = {
    Name = "subnet_${var.network_name}"
  }
}

resource "aws_route_table_association" "rt_association" {
  subnet_id      = aws_subnet.new_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}



resource "aws_security_group" "allowed_in_out" {
  name        = "sg_${var.network_name}"
  description = "Allowed inbound/outbound traffic"
  vpc_id      = aws_vpc.new_vpc.id

  dynamic "ingress" {
    for_each = var.vpc_security_group_ingress
    content {
      description = ingress.value["description"]
      from_port   = ingress.value["from_port"]
      to_port     = ingress.value["to_port"]
      protocol    = ingress.value["protocol"]
      cidr_blocks = ingress.value["cidr_blocks"]
    }
  }

  dynamic "egress" {
    for_each = var.vpc_security_group_egress
    content {
      description = egress.value["description"]
      from_port   = egress.value["from_port"]
      to_port     = egress.value["to_port"]
      protocol    = egress.value["protocol"]
      cidr_blocks = egress.value["cidr_blocks"]
    }
  }

  tags = {
    Name = "sg_${var.network_name}"
  }
}
