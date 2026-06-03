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
  create_dns_record   = false
}

run "without_dns_plan_succeeds" {
  command = plan

  module {
    source = "../"
  }
}
