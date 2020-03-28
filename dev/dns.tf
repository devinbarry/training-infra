resource "aws_route53_zone" "primary" {
  name = var.primary_route53_zone_name

  # We explicitly prevent destruction using terraform.
  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_route53_record" "node_record" {
  for_each = {for node_name in local.nodes : node_name => aws_instance.training_node[node_name].public_ip}

  zone_id = aws_route53_zone.primary.zone_id
  name    = "${each.key}.${var.primary_route53_zone_name}"
  type    = "A"
  ttl     = "60"
  records = [each.value]

  # Public IP addresses in the form of Elastic IPs must have been
  # created first before we can add them to the DNS records.
  depends_on = [
    aws_eip.node_ips,
  ]
}

output "node_addresses" {
  value = {for node_name in local.nodes : node_name => aws_route53_record.node_record[node_name].name}
  description = "The public DNS name for each node."
}
