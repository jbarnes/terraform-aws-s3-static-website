module "static_website" {
  source = "../../"

  bucket_name         = var.bucket_name
  acm_certificate_arn = var.acm_certificate_arn
  domain_name         = var.domain_name
  hosted_zone_id      = var.hosted_zone_id

  cloudfront_price_class = "PriceClass_100"

  custom_error_responses = [
    {
      error_code         = 404
      response_code      = 404
      response_page_path = "/404.html"
    }
  ]

  enable_access_logging             = true
  access_log_bucket_id              = var.access_log_bucket_id
  enable_cloudfront_logging         = true
  cloudfront_log_bucket_domain_name = var.cloudfront_log_bucket_domain_name

  tags = var.tags
}
