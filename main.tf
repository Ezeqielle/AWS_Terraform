module "ec2_instance" {
  source            = "./ec2_instance"
  my_ip             = chomp(data.http.myip.body)
  instance_name     = "ezeqielle-ec2"
  subnet_id         = module.network.new_subnet_id
  security_group_id = module.network.security_group_id
}

module "s3_bucket" {
  source                        = "./s3_bucket"
  bucket_name                   = "ezeqielle"
  very_secret_access_key_id     = module.iam.access_key_id
  very_secret_access_key_secret = module.iam.access_key_secret
  very_secret_username          = module.iam.username
}

module "flowlog" {
  source      = "./flowlog"
  bucket_name = module.s3_bucket.s3_bucket_arn
  vpc         = module.network.vpc_id
}

module "iam" {
  source      = "./iam"
  username    = "kungfu"
  policy_name = "kungfu"
  key_arn     = module.kms.new_key_arn
}

module "kms" {
  source          = "./kms"
  key_description = "KMS Key"
}

module "network" {
  source = "./network"
  vpc_security_group_ingress = [
    {
      description = "SSH to VPC"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["${chomp(data.http.myip.body)}/32"]
    },
    {
      description = "HTTP to VPC"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["${chomp(data.http.myip.body)}/32"]
    },
    {
      description = "TLS to VPC"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["${chomp(data.http.myip.body)}/32"]
    }
  ]
  vpc_security_group_egress = [
    {
      description = "TLS from VPC"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      description = "HTTP from VPC"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

data "http" "myip" {
  url = "https://ifconfig.me"
}
