resource "aws_kms_key" "new_key" {
  description             = var.key_description
  deletion_window_in_days = 10
}

