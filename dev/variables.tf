variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "aws_account_id" {}
variable "aws_profile" {}
variable "aws_region" {
  description = "AWS region e.g. us-east-1 (Please specify a region supported by the Fargate launch type)"
}

variable "training_vpc_cidr" {
  description = "CIDR for the Training VPC"
}

variable "training_subnet_cidr" {
  description = "Private subnet for all training node instances"
}

# You are able to block access from non-specified IP address by setting specific cidr.
variable "ssh_cidr" {}

# Key Pair name
variable "aws_key_name" {}

# Your availablity zone in your region.
variable "availability_zone" {
  default = "us-east-1c"
}

# Node / Machine Type mapping
variable "nodes" {
    type = map(string)
    default = {
        "node0"  = "g4dn.xlarge"
    }
}

# Size and IOPS of underlying EBS volume for each node
variable "ebs" {
  type = map(string)
  default = {
    "volume_size" = 100
    "iops" = 300
  }
}

# Hosted zone to configure DNS
variable "primary_route53_zone_name" {}
