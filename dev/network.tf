resource "aws_vpc" "training_vpc" {
  cidr_block = var.training_vpc_cidr
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "TrainingVPC"
  }
}

resource "aws_subnet" "training_subnet" {
  availability_zone = var.availability_zone
  vpc_id = aws_vpc.training_vpc.id
  cidr_block = var.training_subnet_cidr
  # We use Elastic IPs instead
  map_public_ip_on_launch = false

  tags = {
    Name = "TrainingNodeSubnet"
  }
}

resource "aws_security_group" "training_node_ssh" {
  name = "training_node_ssh-sg"
  description = "SSH into dev training nodes."
  vpc_id = aws_vpc.training_vpc.id

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
      Name = "TrainingNodeSSH"
  }
}

resource "aws_network_interface" "training_node_interfaces" {
  for_each = var.nodes

  subnet_id = aws_subnet.training_subnet.id
  security_groups = [aws_security_group.training_node_ssh.id]

  tags = {
      Name = "Training${title(each.key)} ENI"
  }
}


output "subnet_cidr" {
  value = aws_subnet.training_subnet.cidr_block
}
