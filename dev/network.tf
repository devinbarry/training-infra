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

resource "aws_network_interface" "training_node_interfaces" {
  for_each = var.nodes

  subnet_id = aws_default_subnet.default.id
  security_groups = [aws_security_group.training_node.id]
  depends_on = [aws_instance.training_node]

  attachment {
    instance = aws_instance.training_node[each.key].id
    device_index = 0
  }

  tags = {
      Name = "Training${title(each.key)} ENI"
  }
}


output "subnet_cidr" {
  value = aws_default_subnet.default.cidr_block
}
