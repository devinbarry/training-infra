variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "aws_account_id" {}
variable "aws_profile" {}
variable "aws_region" {
  description = "AWS region e.g. us-east-1 (Please specify a region supported by the Fargate launch type)"
}

# Your availablity zone in your region.
variable "availability_zone" {
  default = "us-east-1c"
}
