data "aws_route53_zone" "primary" {
  name = var.primary_route53_zone_name
}

# Elastic IPs attached to each node. These prevent us having incorrect DNS values
# each time we shut down a machine and boot it back up again. Now instead we will
# keep the same IP address for as long as the machine exists.
resource "aws_eip" "node_ips" {
  for_each = var.nodes

  instance = aws_instance.training_node[each.key].id
  vpc = true

  tags = {
      Name = "${title(each.key)} IP"
  }
}

resource "aws_route53_record" "node_record" {
  for_each = {for node_name in local.nodes : node_name => aws_eip.node_ips[node_name].public_ip}

  zone_id = data.aws_route53_zone.primary.zone_id
  name    = "${each.key}.${var.primary_route53_zone_name}"
  type    = "A"
  ttl     = "60"
  records = [each.value]
}

output "node_addresses" {
  value = {for node_name in local.nodes : node_name => aws_route53_record.node_record[node_name].name}
  description = "The public DNS name for each node."
}

output "training_node_ips" {
  value = {for node_name in local.nodes : node_name => aws_eip.node_ips[node_name].public_ip}
  description = "The public IP addresses of each server with its name."
}
