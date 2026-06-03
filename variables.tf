# Required

variable "bucket_name" {
  description = "The name of the S3 bucket. Must be globally unique and comply with S3 naming constraints."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9\\-]{1,61}[a-z0-9]$", var.bucket_name))
    error_message = "Bucket name must be between 3 and 63 characters, start and end with a lowercase letter or number, and contain only lowercase letters, numbers, and hyphens."
  }
}

variable "acm_certificate_arn" {
  description = "ARN of an ACM certificate in us-east-1 to attach to the CloudFront distribution. CloudFront requires certificates to be in us-east-1 regardless of the distribution's origin region. When null, the default CloudFront certificate is used and the distribution is only accessible via the *.cloudfront.net domain."
  type        = string
  default     = null

  validation {
    condition     = var.acm_certificate_arn == null || can(regex("^arn:aws:acm:us-east-1:[0-9]{12}:certificate/[a-f0-9\\-]+$", var.acm_certificate_arn))
    error_message = "acm_certificate_arn must be a valid ACM certificate ARN in us-east-1 or null."
  }
}

# Optional — DNS

variable "create_dns_record" {
  description = "When true, creates a Route 53 alias record pointing to the CloudFront distribution. Requires hosted_zone_id and domain_name."
  type        = bool
  default     = false
}

variable "hosted_zone_id" {
  description = "The ID of the Route 53 hosted zone in which to create the alias record. Required when create_dns_record is true."
  type        = string
  default     = null

  validation {
    condition     = !var.create_dns_record || var.hosted_zone_id != null
    error_message = "hosted_zone_id must be provided when create_dns_record is true."
  }
}

variable "domain_name" {
  description = "The fully-qualified domain name for the website (e.g. www.example.com). Used as the CloudFront alternate domain name and Route 53 record name. Required when create_dns_record is true."
  type        = string
  default     = null

  validation {
    condition     = !var.create_dns_record || var.domain_name != null
    error_message = "domain_name must be provided when create_dns_record is true."
  }
}

# Optional — S3

variable "kms_key_arn" {
  description = "ARN of a customer-managed KMS key to use for S3 server-side encryption. When provided, the bucket uses SSE-KMS instead of SSE-S3 (AES256). The CloudFront OAC must have kms:Decrypt permission on this key."
  type        = string
  default     = null

  validation {
    condition     = var.kms_key_arn == null || can(regex("^arn:aws:kms:[a-z0-9\\-]+:[0-9]{12}:key/[a-f0-9\\-]+$", var.kms_key_arn))
    error_message = "kms_key_arn must be a valid KMS key ARN or null."
  }
}

variable "force_destroy" {
  description = "When true, allows Terraform to destroy the S3 bucket even when it contains objects. Set to true only for ephemeral or development environments."
  type        = bool
  default     = false
}

variable "enable_access_logging" {
  description = "When true, enables S3 server access logging on the website bucket. Requires access_log_bucket_id."
  type        = bool
  default     = false
}

variable "access_log_bucket_id" {
  description = "The name (ID) of the S3 bucket to receive server access logs. Required when enable_access_logging is true."
  type        = string
  default     = null
}

variable "access_log_prefix" {
  description = "The S3 key prefix for server access log objects written to access_log_bucket_id."
  type        = string
  default     = "s3-access-logs/"
}

# Optional — CloudFront

variable "cloudfront_price_class" {
  description = "The CloudFront price class that controls which edge locations serve the distribution. PriceClass_All uses all edge locations globally. PriceClass_200 excludes the most expensive regions. PriceClass_100 uses only North America and Europe."
  type        = string
  default     = "PriceClass_All"

  validation {
    condition     = contains(["PriceClass_100", "PriceClass_200", "PriceClass_All"], var.cloudfront_price_class)
    error_message = "cloudfront_price_class must be one of: PriceClass_100, PriceClass_200, PriceClass_All."
  }
}

variable "default_root_object" {
  description = "The object that CloudFront returns when a viewer requests the root URL. Typically index.html."
  type        = string
  default     = "index.html"
}

variable "custom_error_responses" {
  description = "A list of custom error response configurations for the CloudFront distribution. Each entry maps a CloudFront or origin error code to a custom response page and HTTP status code. Useful for custom 404 pages or SPA client-side routing fallbacks."
  type = list(object({
    error_code            = number
    response_code         = number
    response_page_path    = string
    error_caching_min_ttl = optional(number, 300)
  }))
  default = []
}

variable "web_acl_arn" {
  description = "ARN of a WAFv2 Web ACL to associate with the CloudFront distribution. The Web ACL must be in us-east-1 (CloudFront requirement). When null, no WAF is associated."
  type        = string
  default     = null

  validation {
    condition     = var.web_acl_arn == null || can(regex("^arn:aws:wafv2:us-east-1:[0-9]{12}:global/webacl/.+$", var.web_acl_arn))
    error_message = "web_acl_arn must be a valid WAFv2 Web ACL ARN in us-east-1 or null."
  }
}

variable "enable_cloudfront_logging" {
  description = "When true, enables CloudFront access logging. Requires cloudfront_log_bucket_domain_name."
  type        = bool
  default     = false
}

variable "cloudfront_log_bucket_domain_name" {
  description = "The domain name of the S3 bucket to receive CloudFront access logs (e.g. my-log-bucket.s3.amazonaws.com). Must be the bucket domain name, not the bucket ID. Required when enable_cloudfront_logging is true."
  type        = string
  default     = null
}

variable "cloudfront_log_prefix" {
  description = "The S3 key prefix for CloudFront access log objects."
  type        = string
  default     = "cloudfront-logs/"
}

# Optional — Common

variable "tags" {
  description = "A map of tags to apply to all taggable resources created by this module."
  type        = map(string)
  default     = {}
}
