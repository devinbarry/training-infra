provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = var.aws_region
  version = "~> 2.54"
}

terraform {
  backend "s3" {}
}

locals {
  num_training_node = 1
}

output "subnet_cidr" {
  value = aws_default_subnet.default.cidr_block
}

output "training_node_ips" {
  value = aws_instance.training_node.*.public_ip
}

resource "aws_default_subnet" "default" {
  availability_zone = var.availability_zone

  tags = {
    Name = "Training Node Subnet"
  }
}

resource "aws_security_group" "training_node" {
  name = "training_node-sg"
  description = "Security group for Dev Training Node"

  # For ssh
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [var.ssh_cidr]
    description = "SSH from office"
  }

  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
      Name = "training_node-sg"
  }
}

data "aws_ami" "ubuntu_1804_LTS" {
  most_recent = true
  # name_regex = "Ubuntu 18.04 20191113"

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-20200323"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}



# Training Node
resource "aws_instance" "training_node" {
  ami = data.aws_ami.ubuntu_1804_LTS.id
  instance_type = "g4dn.xlarge"
  key_name = var.aws_key_name
  vpc_security_group_ids = ["${aws_security_group.training_node.id}"]
  subnet_id = aws_default_subnet.default.id
  count = local.num_training_node
  depends_on = [aws_default_subnet.default, aws_security_group.training_node]

  tags = {
      Name = "TrainingNode${count.index}"
  }
}
