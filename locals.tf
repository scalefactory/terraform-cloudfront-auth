locals {
  bucket_name  = var.name
  s3_origin_id = "S3-${local.bucket_name}"
}

