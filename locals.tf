locals {
  bucket_name  = "${var.environment}-${var.name}"
  s3_origin_id = "S3-${local.bucket_name}"
}

