output "bucket_id" {
  description = "The name of the S3 bucket."
  value       = module.static_website.bucket_id
}

output "cloudfront_distribution_id" {
  description = "The CloudFront distribution ID."
  value       = module.static_website.cloudfront_distribution_id
}

output "cloudfront_domain_name" {
  description = "The CloudFront-assigned domain name."
  value       = module.static_website.cloudfront_domain_name
}

output "route53_record_fqdn" {
  description = "The FQDN of the Route 53 alias record."
  value       = module.static_website.route53_record_fqdn
}
