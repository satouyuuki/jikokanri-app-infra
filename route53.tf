# ----------
# route53
# ----------
resource "aws_route53_zone" "root" {
  name = var.root_domain
  tags = {
    Name = var.root_domain
    Environment = "prod"
  }
}

# resource "aws_route53_record" "site" {
#   zone_id = aws_route53_zone.root.zone_id
#   name    = var.site_domain
#   type    = "A"
#   alias {
#     name = aws_cloudfront_distribution.myCloudfront.domain_name
#     zone_id = aws_cloudfront_distribution.myCloudfront.hosted_zone_id
#     evaluate_target_health = false
#   }
# }