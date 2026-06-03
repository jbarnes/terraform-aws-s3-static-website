provider "aws" {
  region                      = "us-east-1"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true
  access_key                  = "mock"
  secret_key                  = "mock"
}

variables {
  bucket_name         = "mock-website-bucket"
  acm_certificate_arn = "arn:aws:acm:us-east-1:123456789012:certificate/aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee"
  hosted_zone_id      = "MOCKZONEID"
  domain_name         = "www.example.com"

  enable_access_logging             = true
  access_log_bucket_id              = "mock-access-log-bucket"
  enable_cloudfront_logging         = true
  cloudfront_log_bucket_domain_name = "mock-cf-log-bucket.s3.amazonaws.com"
}

run "with_logging_plan_succeeds" {
  command = plan

  module {
    source = "../"
  }
}
