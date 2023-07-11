# SET UP DEFAULT CACHE POLICIES FOR CLOUDFRONT DISTRUBUTION
resource "aws_cloudfront_cache_policy" "default_cache_policy" {
  name        = "Wordpress-Main-Distribution"
  comment     = "Caching policy for the public website"
  default_ttl = 300
  max_ttl     = 300
  min_ttl     = 300
  parameters_in_cache_key_and_forwarded_to_origin {
    cookies_config {
      cookie_behavior = "whitelist"
      cookies {
        items = [
          "comment_author_*",
          "comment_author_email_*",
          "comment_author_url_*",
          "wordpress_*",
          "wp-postpass_*",
          "wordpress_logged_in_*",
          "wordpress_cookie_login",
          "wp_settings-*"
        ]
      }
    }
    headers_config {
      header_behavior = "whitelist"
      headers {
        items = [
          "Origin",
          "Options",
          "Host"
        ]
      }
    }
    query_strings_config {
      query_string_behavior = "whitelist"
      query_strings {
        items = [
          "s"
        ]
      }
    }
  }
}

resource "aws_cloudfront_cache_policy" "admin_cache_policy" {
  name        = "WordPress-Admin-Policy"
  comment     = "Caching policy for the admin section of the website"
  default_ttl = 86400
  max_ttl     = 31536000
  min_ttl     = 1
  parameters_in_cache_key_and_forwarded_to_origin {
    cookies_config {
      cookie_behavior = "whitelist"
      cookies {
        items = [
          "comment_author_*",
          "comment_author_email_*",
          "comment_author_url_*",
          "wordpress_*",
          "wordpress_logged_in_*",
          "wordpress_cookie_login",
          "wp_settings-*"
        ]
      }
    }
    headers_config {
      header_behavior = "whitelist"
      headers {
        items = [
          "Origin",
          "Options",
          "Host",
          "Referer",
          "User-Agent"
        ]
      }
    }
    query_strings_config {
      query_string_behavior = "all"
    }
  }
}

# SET UP THE ORIGIN REQUEST POLICY FOR CLOUDFRONT DISTRIBUTION
resource "aws_cloudfront_origin_request_policy" "default_origin_request_policy" {
  name    = "HeaderWhitelistAllCookiesAndQueryStrings"
  comment = ""
  cookies_config {
    cookie_behavior = "all"
  }
  headers_config {
    header_behavior = "whitelist"
    headers {
      items = [
        "Origin",
        "Options",
        "Host",
        "Referer"
      ]
    }
  }
  query_strings_config {
    query_string_behavior = "all"
  }
}

# SET UP A PRODUCTION SITE CLOUDFRONT DISTRIBUTION
resource "aws_cloudfront_distribution" "production_distribution" {
  origin {
    domain_name = var.domain_name
    origin_id   = var.origin_id

    custom_origin_config {
      http_port              = "80"
      https_port             = "443"
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  enabled         = true
  is_ipv6_enabled = true
  comment         = "Production standard distribution for caching web pages"

  aliases = []

  default_cache_behavior {
    allowed_methods          = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods           = ["GET", "HEAD", "OPTIONS"]
    target_origin_id         = var.origin_id
    origin_request_policy_id = aws_cloudfront_origin_request_policy.default_origin_request_policy.id
    cache_policy_id          = aws_cloudfront_cache_policy.default_cache_policy.id

    min_ttl                = 0
    default_ttl            = 86400
    max_ttl                = 31536000
    compress               = false
    viewer_protocol_policy = "redirect-to-https"
  }

  ordered_cache_behavior {
    path_pattern             = "/wp-admin/*"
    allowed_methods          = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods           = ["GET", "HEAD"]
    target_origin_id         = var.origin_id
    origin_request_policy_id = aws_cloudfront_origin_request_policy.default_origin_request_policy.id
    cache_policy_id          = aws_cloudfront_cache_policy.admin_cache_policy.id

    min_ttl                = 0
    default_ttl            = 86400
    max_ttl                = 31536000
    compress               = false
    viewer_protocol_policy = "redirect-to-https"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}
