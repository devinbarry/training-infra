variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "aws_account_id" {}
variable "aws_profile" {}
variable "aws_region" {
  description = "AWS region e.g. us-east-1 (Please specify a region supported by the Fargate launch type)"
}
variable "aws_resource_prefix" {
  description = "Prefix to be used in the naming of some of the created AWS resources e.g. demo-webapp"
}

# You are able to block access from non-specified IP address by setting specific cidr.
variable "ssh_cidr" {}

# Key Pair name
variable "aws_key_name" {}

# Your availablity zone in your region.
variable "availability_zone" {
    default = "us-east-1c"
}
