output "public_ip" {
  value = aws_eip.jikankanriEip.public_ip
}

output "cloudfront_destribution_domain_name" {
  value = aws_cloudfront_distribution.myCloudfront.domain_name
}

output "db_endpoint" {
  value = aws_db_instance.jikankanriRds.endpoint
}
