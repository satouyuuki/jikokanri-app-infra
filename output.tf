output "public_ip" {
  value = aws_eip.jikankanriEip.public_ip
}

output "cloudfront_destribution_domain_name" {
  value = aws_cloudfront_distribution.myCloudfront.domain_name
}

output "db_endpoint" {
  value = aws_db_instance.jikankanriRds.endpoint
}

# ZoneのName Serverを出力
output "zone_name_servers" {
  value = aws_route53_zone.root.name_servers
}

output "public_dns" {
  value = aws_instance.jikankanriEc2.*.public_dns[0]
}
# output "alb_dns_name" {
#   value = aws_lb.myAlb.dns_name
# }
# output "public_dns_not_exist" {
#   value = aws_instance.jikankanriEc2.public_dns[0]
# }
