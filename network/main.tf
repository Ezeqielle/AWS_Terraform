resource "aws_vpc" "new_vpc" {
  cidr_block       = "10.16.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "main-network"
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
    Name = "Public Route Table"
  }
}

resource "aws_subnet" "new_subnet" {
  vpc_id            = aws_vpc.new_vpc.id
  cidr_block        = "10.16.16.0/24"
  availability_zone = "eu-west-3a"

  tags = {
    Name = "main-network"
  }
}

resource "aws_route_table_association" "rt_association" {
  subnet_id      = aws_subnet.new_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}



resource "aws_security_group" "allowed_in_out" {
  name        = "allowed_in_out"
  description = "Allowed inbound/outbound traffic"
  vpc_id      = aws_vpc.new_vpc.id

  ingress {
    description = "SSH to VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["94.228.190.38/32"]
  }

  ingress {
    description = "HTTP to VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["94.228.190.38/32"]
  }

  ingress {
    description = "TLS to VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["94.228.190.38/32"]
  }

  egress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allowed_in_out"
  }
}
