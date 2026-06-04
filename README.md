# terraform-aws-s3-static-website

[![CI (scheduled)](https://github.com/jbarnes/terraform-aws-s3-static-website/actions/workflows/ci.yml/badge.svg?event=schedule)](https://github.com/jbarnes/terraform-aws-s3-static-website/actions/workflows/ci.yml?query=event%3Aschedule)

The badge above reflects the weekly scheduled CI run, which re-resolves the latest Terraform and AWS provider versions against this module to catch breaking upstream releases.

Terraform module that provisions a CIS-compliant AWS static website stack: a private S3 bucket as origin, a CloudFront distribution with HTTPS enforcement and Origin Access Control (OAC), and an optional Route 53 alias record.

**Out of scope:** Route 53 hosted zone and ACM certificate provisioning. These are accepted as input variables.

## Usage

```hcl
module "static_website" {
  source = "github.com/jbarnes/terraform-aws-s3-static-website?ref=v1.0.0"

  bucket_name         = "my-website-bucket"
  acm_certificate_arn = "arn:aws:acm:us-east-1:123456789012:certificate/aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee"
  domain_name         = "www.example.com"
  hosted_zone_id      = "Z1234567890ABCDEF"

  tags = {
    Environment = "production"
    Project     = "my-website"
  }
}

output "cloudfront_distribution_id" {
  value = module.static_website.cloudfront_distribution_id
}
```

See [`examples/complete/`](./examples/complete/) for a full example with logging and custom error responses.

## Compliance

This module is compliant with the following CIS AWS Foundations Benchmark v5.0.0 controls:

| Control ID | CIS Requirement | Description |
|------------|-----------------|-------------|
| S3.1 | 2.1.4 | S3 general purpose buckets should have block public access settings enabled |
| S3.5 | 2.1.1 | S3 general purpose buckets should require requests to use SSL |
| S3.8 | 2.1.4 | S3 general purpose buckets should block public access |

### Controls assessed as not applicable

| Control ID | Rationale |
|------------|-----------|
| S3.20 (MFA delete) | This bucket is a CI/CD deployment target. MFA delete requires root account credentials at apply time and would prevent automated pipelines from writing or deleting objects. Versioning is enabled. MFA delete is not appropriate for this use case. |

### Consumer responsibilities

| Control ID | Description |
|------------|-------------|
| S3.22 | Object-level write logging — requires CloudTrail data events configured by the consumer |
| S3.23 | Object-level read logging — requires CloudTrail data events configured by the consumer |

## Tested Terraform Version

Developed and tested with Terraform `1.9.x`. Minimum required version: `>= 1.9`.

## Development

This module was designed and authored with the assistance of [Claude](https://www.anthropic.com/claude). The interface, CIS compliance posture, and test strategy were stress-tested through an interactive design review before implementation, and the module was smoke-tested against real AWS infrastructure prior to release.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.9 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 6.0 |

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.47.0 |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_access_log_bucket_id"></a> [access\_log\_bucket\_id](#input\_access\_log\_bucket\_id) | The name (ID) of the S3 bucket to receive server access logs. Required when enable\_access\_logging is true. | `string` | `null` | no |
| <a name="input_access_log_prefix"></a> [access\_log\_prefix](#input\_access\_log\_prefix) | The S3 key prefix for server access log objects written to access\_log\_bucket\_id. | `string` | `"s3-access-logs/"` | no |
| <a name="input_acm_certificate_arn"></a> [acm\_certificate\_arn](#input\_acm\_certificate\_arn) | ARN of an ACM certificate in us-east-1 to attach to the CloudFront distribution. CloudFront requires certificates to be in us-east-1 regardless of the distribution's origin region. When null, the default CloudFront certificate is used and the distribution is only accessible via the *.cloudfront.net domain. | `string` | `null` | no |
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | The name of the S3 bucket. Must be globally unique and comply with S3 naming constraints. | `string` | n/a | yes |
| <a name="input_cloudfront_log_bucket_domain_name"></a> [cloudfront\_log\_bucket\_domain\_name](#input\_cloudfront\_log\_bucket\_domain\_name) | The domain name of the S3 bucket to receive CloudFront access logs (e.g. my-log-bucket.s3.amazonaws.com). Must be the bucket domain name, not the bucket ID. Required when enable\_cloudfront\_logging is true. | `string` | `null` | no |
| <a name="input_cloudfront_log_prefix"></a> [cloudfront\_log\_prefix](#input\_cloudfront\_log\_prefix) | The S3 key prefix for CloudFront access log objects. | `string` | `"cloudfront-logs/"` | no |
| <a name="input_cloudfront_price_class"></a> [cloudfront\_price\_class](#input\_cloudfront\_price\_class) | The CloudFront price class that controls which edge locations serve the distribution. PriceClass\_All uses all edge locations globally. PriceClass\_200 excludes the most expensive regions. PriceClass\_100 uses only North America and Europe. | `string` | `"PriceClass_All"` | no |
| <a name="input_create_dns_record"></a> [create\_dns\_record](#input\_create\_dns\_record) | When true, creates a Route 53 alias record pointing to the CloudFront distribution. Requires hosted\_zone\_id and domain\_name. | `bool` | `false` | no |
| <a name="input_custom_error_responses"></a> [custom\_error\_responses](#input\_custom\_error\_responses) | A list of custom error response configurations for the CloudFront distribution. Each entry maps a CloudFront or origin error code to a custom response page and HTTP status code. Useful for custom 404 pages or SPA client-side routing fallbacks. | <pre>list(object({<br/>    error_code            = number<br/>    response_code         = number<br/>    response_page_path    = string<br/>    error_caching_min_ttl = optional(number, 300)<br/>  }))</pre> | `[]` | no |
| <a name="input_default_root_object"></a> [default\_root\_object](#input\_default\_root\_object) | The object that CloudFront returns when a viewer requests the root URL. Typically index.html. | `string` | `"index.html"` | no |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | The fully-qualified domain name for the website (e.g. www.example.com). Used as the CloudFront alternate domain name and Route 53 record name. Required when create\_dns\_record is true. | `string` | `null` | no |
| <a name="input_enable_access_logging"></a> [enable\_access\_logging](#input\_enable\_access\_logging) | When true, enables S3 server access logging on the website bucket. Requires access\_log\_bucket\_id. | `bool` | `false` | no |
| <a name="input_enable_cloudfront_logging"></a> [enable\_cloudfront\_logging](#input\_enable\_cloudfront\_logging) | When true, enables CloudFront access logging. Requires cloudfront\_log\_bucket\_domain\_name. | `bool` | `false` | no |
| <a name="input_force_destroy"></a> [force\_destroy](#input\_force\_destroy) | When true, allows Terraform to destroy the S3 bucket even when it contains objects. Set to true only for ephemeral or development environments. | `bool` | `false` | no |
| <a name="input_hosted_zone_id"></a> [hosted\_zone\_id](#input\_hosted\_zone\_id) | The ID of the Route 53 hosted zone in which to create the alias record. Required when create\_dns\_record is true. | `string` | `null` | no |
| <a name="input_kms_key_arn"></a> [kms\_key\_arn](#input\_kms\_key\_arn) | ARN of a customer-managed KMS key to use for S3 server-side encryption. When provided, the bucket uses SSE-KMS instead of SSE-S3 (AES256). The CloudFront OAC must have kms:Decrypt permission on this key. | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to apply to all taggable resources created by this module. | `map(string)` | `{}` | no |
| <a name="input_web_acl_arn"></a> [web\_acl\_arn](#input\_web\_acl\_arn) | ARN of a WAFv2 Web ACL to associate with the CloudFront distribution. The Web ACL must be in us-east-1 (CloudFront requirement). When null, no WAF is associated. | `string` | `null` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_bucket_arn"></a> [bucket\_arn](#output\_bucket\_arn) | The ARN of the S3 bucket. |
| <a name="output_bucket_domain_name"></a> [bucket\_domain\_name](#output\_bucket\_domain\_name) | The regional domain name of the S3 bucket. |
| <a name="output_bucket_id"></a> [bucket\_id](#output\_bucket\_id) | The name (ID) of the S3 bucket. |
| <a name="output_cloudfront_distribution_arn"></a> [cloudfront\_distribution\_arn](#output\_cloudfront\_distribution\_arn) | The ARN of the CloudFront distribution. |
| <a name="output_cloudfront_distribution_id"></a> [cloudfront\_distribution\_id](#output\_cloudfront\_distribution\_id) | The ID of the CloudFront distribution. Required for cache invalidation (aws cloudfront create-invalidation) in CI/CD pipelines. |
| <a name="output_cloudfront_domain_name"></a> [cloudfront\_domain\_name](#output\_cloudfront\_domain\_name) | The CloudFront-assigned domain name of the distribution (e.g. d1234abcd.cloudfront.net). Use this to create alias records outside the module when create\_dns\_record is false. |
| <a name="output_cloudfront_hosted_zone_id"></a> [cloudfront\_hosted\_zone\_id](#output\_cloudfront\_hosted\_zone\_id) | The Route 53 hosted zone ID for the CloudFront distribution. Required when creating alias records outside this module. |
| <a name="output_route53_record_fqdn"></a> [route53\_record\_fqdn](#output\_route53\_record\_fqdn) | The fully-qualified domain name of the Route 53 alias record created by this module. Empty string when create\_dns\_record is false. |
<!-- END_TF_DOCS -->
