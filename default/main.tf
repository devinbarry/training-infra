provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = var.aws_region
  profile    = var.aws_profile
  version    = "~> 2.54"
}

terraform {
  backend "s3" {}
}

locals {
}


# Default VPC CIDR block 172.31.0.0/16
resource "aws_default_vpc" "default" {
  tags = {
    Name = "DefaultVPC"
  }
}

resource "aws_internet_gateway" "default" {
  vpc_id = aws_default_vpc.default.id

  tags = {
    Name = "DefaultGW"
  }
}

resource "aws_default_subnet" "default" {
  availability_zone = var.availability_zone

  tags = {
    Name = "DefaultSubnet-${var.availability_zone}"
  }
}
