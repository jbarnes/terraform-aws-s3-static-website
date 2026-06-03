locals {
  s3_encryption_algorithm = var.kms_key_arn != null ? "aws:kms" : "AES256"
}
