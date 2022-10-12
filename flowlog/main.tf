resource "aws_flow_log" "new_flowlog" {
  log_destination      = var.bucket_name
  log_destination_type = "s3"
  traffic_type         = "ALL"
  vpc_id               = var.vpc
}