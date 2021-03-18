# cloudfront
locals {
  s3_origin_id = "s3-origin-${var.site_domain}"
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
  enabled             = true
  is_ipv6_enabled     = true
  comment             = var.site_domain
  default_root_object = "index.html"

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

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  price_class = "PriceClass_200"

  # とりあえずCloudFrontドメインの証明書を利用
  # Route53&ACM設定が終わった後で、自ドメインの証明書に変更します
  viewer_certificate {
    cloudfront_default_certificate = true
  }
}
