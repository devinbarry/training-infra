resource "aws_route53_zone" "primary" {
  name = var.primary_route53_zone_name
}

resource "aws_route53_record" "node_record" {
  for_each = {for node_name in local.nodes : node_name => aws_instance.training_node[node_name].public_ip}

  zone_id = aws_route53_zone.primary.zone_id
  name    = "${each.key}.${var.primary_route53_zone_name}"
  type    = "A"
  ttl     = "60"
  records = [each.value]
}
