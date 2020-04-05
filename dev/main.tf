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
  # List of names of all the nodes
  nodes = keys(var.nodes)
}

data "aws_ami" "ubuntu_1804_LTS" {
  most_recent = true

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


resource "aws_placement_group" "training_node_cluster" {
  name     = "training_node-pg"
  strategy = "cluster"
}


# Training Node(s)
resource "aws_instance" "training_node" {
  for_each = var.nodes

  ami = data.aws_ami.ubuntu_1804_LTS.id
  instance_type = each.value
  placement_group = aws_placement_group.training_node_cluster.id
  key_name = var.aws_key_name

  network_interface {
    device_index = 0
    network_interface_id = aws_network_interface.training_node_interfaces[each.key].id
  }

  root_block_device {
    volume_type = "gp2"
    volume_size = var.ebs.volume_size
    iops = var.ebs.iops
    delete_on_termination = true
  }

  tags = {
      Name = "Training${title(each.key)}"
  }
}
