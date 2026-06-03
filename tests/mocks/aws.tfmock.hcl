mock_provider "aws" {
  mock_resource "aws_s3_bucket" {
    defaults = {
      arn                         = "arn:aws:s3:::mock-website-bucket"
      id                          = "mock-website-bucket"
      bucket_regional_domain_name = "mock-website-bucket.s3.ap-southeast-2.amazonaws.com"
      region                      = "ap-southeast-2"
    }
  }

  mock_resource "aws_s3_bucket_public_access_block" {
    defaults = {
      id = "mock-website-bucket"
    }
  }

  mock_resource "aws_s3_bucket_versioning" {
    defaults = {
      id = "mock-website-bucket"
    }
  }

  mock_resource "aws_s3_bucket_server_side_encryption_configuration" {
    defaults = {
      id = "mock-website-bucket"
    }
  }

  mock_resource "aws_s3_bucket_policy" {
    defaults = {
      id = "mock-website-bucket"
    }
  }

  mock_resource "aws_s3_bucket_logging" {
    defaults = {
      id = "mock-website-bucket"
    }
  }

  mock_resource "aws_cloudfront_origin_access_control" {
    defaults = {
      id   = "MOCKOACID123456"
      etag = "ETAGMOCK"
    }
  }

  mock_resource "aws_cloudfront_distribution" {
    defaults = {
      id             = "MOCKDISTRIBUTION1"
      arn            = "arn:aws:cloudfront::123456789012:distribution/MOCKDISTRIBUTION1"
      domain_name    = "d1234abcdef.cloudfront.net"
      hosted_zone_id = "Z2FDTNDATAQYW2"
      status         = "Deployed"
      etag           = "ETAGMOCK"
    }
  }

  mock_resource "aws_route53_record" {
    defaults = {
      id   = "MOCKZONEID_www.example.com_A"
      fqdn = "www.example.com"
      name = "www.example.com"
    }
  }
}
