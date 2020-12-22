locals {
  lambda_filename = "lambda.zip"
  s3_origin_id    = "S3-${var.bucket_name}"

  // Only set --GITHUB_ORGANIZATION when applicable
  build_lambda_command = var.github_organization != null ? "${chomp(local.build_lambda_command_plus_hd)} --GITHUB_ORGANIZATION=${format("%q", var.github_organization)}" : local.build_lambda_command_plus_hd

  // Only set --HD when applicable
  build_lambda_command_plus_hd = var.auth_vendor == "google" ? "${chomp(local.build_lambda_command_common)} --HD=${format("%q", var.hd)}" : local.build_lambda_command_common

  build_lambda_command_common = <<-EOT
    cd build/cloudfront-auth-master && node build/build.js --AUTH_VENDOR='${var.auth_vendor}' --CLOUDFRONT_DISTRIBUTION='${var.cloudfront_distribution}' --CLIENT_ID='${var.client_id}' --CLIENT_SECRET='${var.client_secret}' --REDIRECT_URI='${var.redirect_uri}' --SESSION_DURATION='${var.session_duration}' --AUTHZ=${format("%q", var.authz)}
    EOT
}

