# ----------
# acm.tf
# ----------
resource "aws_acm_certificate" "acmCert" {
  provider = aws.acm
  domain_name       = var.root_domain
  subject_alternative_names = [
    "*.${var.root_domain}"
  ]
  validation_method = "DNS"
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "acmSite" {
  for_each = {
    for acm in aws_acm_certificate.acmCert.domain_validation_options: acm.domain_name => {
      name = acm.resource_record_name
      type = acm.resource_record_type
      record = acm.resource_record_value
    }
  }
  allow_overwrite = true
  zone_id = aws_route53_zone.root.zone_id
  ttl = 60
  name = each.value.name
  type = each.value.type
  records = [each.value.record]
}

resource "aws_acm_certificate_validation" "acmCertValid" {
  provider = aws.acm
  certificate_arn = aws_acm_certificate.acmCert.arn
  validation_record_fqdns = [for record in aws_route53_record.acmSite: record.fqdn]
}