locals {
  lambda_filename = "lambda.zip"
  s3_origin_id    = "S3-${var.bucket_name}"
}
