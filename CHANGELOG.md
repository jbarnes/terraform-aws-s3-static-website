# Changelog

All notable changes to this module will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.0.0] - 2026-06-03

### Added

- Initial stable release.
- S3 bucket with CIS v5.0.0 compliant configuration (S3.1, S3.5, S3.8).
- Block public access hardcoded on all four settings.
- SSL-only bucket policy (deny non-SSL + CloudFront OAC grant).
- SSE-S3 encryption by default; optional SSE-KMS via `kms_key_arn`.
- S3 bucket versioning enabled.
- CloudFront distribution with Origin Access Control (OAC).
- HTTPS enforced via `redirect-to-https` viewer protocol policy (non-toggleable).
- Minimum TLS version hardcoded to `TLSv1.2_2021` when using a custom ACM certificate.
- `acm_certificate_arn` optional — defaults to CloudFront certificate for deployments without a custom domain.
- Optional Route 53 alias record via `create_dns_record` toggle (default `false`).
- Cross-variable validation ensuring `hosted_zone_id` and `domain_name` are provided when `create_dns_record` is `true`.
- Optional S3 server access logging via `enable_access_logging` toggle.
- Optional CloudFront access logging via `enable_cloudfront_logging` toggle.
- Optional custom error responses via `custom_error_responses` variable (supports SPA and multi-page patterns).
- Optional WAF Web ACL association via `web_acl_arn` variable.
- Configurable CloudFront price class via `cloudfront_price_class` variable (default `PriceClass_All`).
- Mock-based Terraform tests covering defaults, logging, custom errors, and no-DNS variants — no AWS credentials required.
- GitHub Actions CI pipeline.
- Pre-commit configuration.
- Smoke tested against real AWS (ap-southeast-2) prior to release.
