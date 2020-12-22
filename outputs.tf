output "s3_bucket" {
    description = "The name of the S3 Bucket"
    value = aws_s3_bucket.default.id
}

output "cloudfront_arn" {
    description = "ARN of the Cloudfront Distribution"
    value = aws_cloudfront_distribution.default.arn
}

output "cloudfront_id" {
    description = "ID of the Cloudfront Distribution"
    value = aws_cloudfront_distribution.default.id
}
