# cloudfront
locals {
  s3_origin_id = "s3-origin-${var.site_domain}"
  ec2_origin_id = aws_instance.jikankanriEc2.*.public_dns[0]
}
resource "aws_cloudfront_origin_access_identity" "myCloudfrontOAI" {
  comment =var.site_domain
}
resource "aws_cloudfront_distribution" "myCloudfront" {
  origin {
    domain_name = aws_s3_bucket.site.bucket_regional_domain_name
    origin_id = local.s3_origin_id
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.myCloudfrontOAI.cloudfront_access_identity_path
    }
  }
  origin {
    domain_name = var.api_server_domain
    origin_id = local.ec2_origin_id
    custom_origin_config {
      http_port = 80
      https_port = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols = [ "TLSv1" ]
    }
  }
  enabled             = true
  is_ipv6_enabled     = true
  comment             = var.site_domain
  default_root_object = "index.html"
  # 403エラーはルートへ
  custom_error_response {
    error_code = 403
    response_code = 200
    error_caching_min_ttl = 0
    response_page_path = "/"
  }

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  ordered_cache_behavior {
    path_pattern     = "/api/*"
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "POST", "PUT", "PATCH"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.ec2_origin_id

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  price_class = "PriceClass_200"

  # とりあえずCloudFrontドメインの証明書を利用
  # Route53&ACM設定が終わった後で、自ドメインの証明書に変更します
  aliases = [ var.site_domain ]
  viewer_certificate {
    # cloudfront_default_certificate = true
    acm_certificate_arn = aws_acm_certificate_validation.acmCertValid.certificate_arn
    ssl_support_method = "sni-only"
    minimum_protocol_version = "TLSv1"
  }
  logging_config {
    include_cookies = false
    bucket          = aws_s3_bucket.jikokanriLogs.bucket_domain_name
    prefix          = "cloudfront/"
  }
}
