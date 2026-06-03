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

  custom_error_responses = [
    {
      error_code         = 403
      response_code      = 200
      response_page_path = "/index.html"
    },
    {
      error_code         = 404
      response_code      = 200
      response_page_path = "/index.html"
    }
  ]
}

run "with_custom_errors_plan_succeeds" {
  command = plan

  module {
    source = "../"
  }
}
