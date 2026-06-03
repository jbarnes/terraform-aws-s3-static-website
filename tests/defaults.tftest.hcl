provider "aws" {
  region                      = "us-east-1"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true
  access_key                  = "mock"
  secret_key                  = "mock"
}

variables {
  bucket_name = "mock-website-bucket"
}

run "defaults_plan_succeeds" {
  command = plan

  module {
    source = "../"
  }
}
