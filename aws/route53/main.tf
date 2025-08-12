resource "aws_route53_record" "this" {
  zone_id = var.hosted_zone_id
  name    = "${var.subdomain}.${var.hosted_zone_name}"
  type    = "A"

  alias {
    name                   = var.alias_name
    zone_id                = var.alias_zone_id
    evaluate_target_health = true
  }
}