output "bucket_arn" {
  description = "The ARN of the S3 bucket."
  value       = aws_s3_bucket.this.arn
}

output "bucket_domain_name" {
  description = "The regional domain name of the S3 bucket."
  value       = aws_s3_bucket.this.bucket_regional_domain_name
}

output "bucket_id" {
  description = "The name (ID) of the S3 bucket."
  value       = aws_s3_bucket.this.id
}

output "cloudfront_distribution_arn" {
  description = "The ARN of the CloudFront distribution."
  value       = aws_cloudfront_distribution.this.arn
}

output "cloudfront_distribution_id" {
  description = "The ID of the CloudFront distribution. Required for cache invalidation (aws cloudfront create-invalidation) in CI/CD pipelines."
  value       = aws_cloudfront_distribution.this.id
}

output "cloudfront_domain_name" {
  description = "The CloudFront-assigned domain name of the distribution (e.g. d1234abcd.cloudfront.net). Use this to create alias records outside the module when create_dns_record is false."
  value       = aws_cloudfront_distribution.this.domain_name
}

output "cloudfront_hosted_zone_id" {
  description = "The Route 53 hosted zone ID for the CloudFront distribution. Required when creating alias records outside this module."
  value       = aws_cloudfront_distribution.this.hosted_zone_id
}

output "route53_record_fqdn" {
  description = "The fully-qualified domain name of the Route 53 alias record created by this module. Empty string when create_dns_record is false."
  value       = var.create_dns_record ? aws_route53_record.this[0].fqdn : ""
}
