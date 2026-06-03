variable "bucket_name" {
  description = "The name of the S3 bucket."
  type        = string
}

variable "acm_certificate_arn" {
  description = "ARN of an ACM certificate in us-east-1."
  type        = string
}

variable "domain_name" {
  description = "The FQDN for the website."
  type        = string
}

variable "hosted_zone_id" {
  description = "The Route 53 hosted zone ID."
  type        = string
}

variable "access_log_bucket_id" {
  description = "The name of the S3 bucket to receive server access logs."
  type        = string
}

variable "cloudfront_log_bucket_domain_name" {
  description = "The domain name of the S3 bucket to receive CloudFront access logs."
  type        = string
}

variable "tags" {
  description = "Tags to apply to all resources."
  type        = map(string)
  default     = {}
}
