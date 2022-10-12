module "ec2_instance" {
  source        = "./ec2_instance"
  my_ip         = chomp(data.http.myip.body)
  instance_name = "ezeqielle-ec2"
  subnet_id   = module.network.new_subnet_id
  security_group_id     = module.network.security_group_id
}

module "s3_bucket" {
  source                        = "./s3_bucket"
  bucket_name                   = "ezeqielle-bucket"
  very_secret_access_key_id     = module.iam.access_key_id
  very_secret_access_key_secret = module.iam.access_key_secret
  very_secret_username          = module.iam.username
}

module "iam" {
  source      = "./iam"
  username    = "kungfu"
  policy_name = "kungfu"
  key_arn     = module.kms.new_key_arn
}

module "kms" {
  source   = "./kms"
  key_description = "KMS Key"
}

module "network" {
  source   = "./network"
}

data "http" "myip" {
  url = "https://ifconfig.me"
}