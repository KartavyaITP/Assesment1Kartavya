resource "aws_cloudfront_distribution" "my_distribution" {
  comment         = "My CloudFront Distribution"
  enabled         = true
  is_ipv6_enabled = true

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "my-alb-origin"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
  }

  
  origin {
    domain_name = aws_lb.my_alb.dns_name
    origin_id   = "my-alb-origin"
    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1", "TLSv1.1", "TLSv1.2"]
    }
  }

 
}


output "cloudfront_domain_name" {
  value = aws_cloudfront_distribution.my_distribution.domain_name
}
