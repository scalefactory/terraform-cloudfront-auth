#
# Lambda Packaging
#

# Builds the Lambda zip artifact
resource "null_resource" "build_lambda" {

  # Trigger a rebuild on any variable change
  triggers = {
    vendor                  = var.auth_vendor
    cloudfront_distribution = var.cloudfront_distribution
    client_id               = var.client_id
    client_secret           = var.client_secret
    redirect_uri            = var.redirect_uri
    hd                      = var.hd
    session_duration        = var.session_duration
    authz                   = var.authz
    github_organization     = try(var.github_organization, "")
    base_url                = var.base_url
    dest_file               = "${path.root}/build/cloudfront-auth-master/distributions/${var.cloudfront_distribution}/${var.cloudfront_distribution}.zip"
  }
  
  provisioner "local-exec" {
    command = <<EOF
if [ ! -d "build" ]; then
  if [ ! -L "build" ]; then
    curl -L https://github.com/Widen/cloudfront-auth/archive/master.zip --output cloudfront-auth-master.zip
    unzip -q cloudfront-auth-master.zip -d build/
    mkdir build/cloudfront-auth-master/distributions

    cp ${data.local_file.build-js.filename} build/cloudfront-auth-master/build/build.js
    cd build/cloudfront-auth-master && npm i minimist && npm install && cd build && npm install
  fi
fi
EOF
  }

  provisioner "local-exec" {
    command = local.build_lambda_command
  }
}

data "local_file" "build-js" {
  filename = "${path.module}/build.js"
}

data "local_file" "distribution_zip" {
  filename = null_resource.build_lambda.triggers.dest_file
}

#
# S3
#
resource "aws_s3_bucket" "default" {
  bucket = var.bucket_name
  acl    = "private"
  tags   = var.tags
}

# Block direct public access
resource "aws_s3_bucket_public_access_block" "default" {
  bucket = aws_s3_bucket.default.id

  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
}

data "aws_iam_policy_document" "s3_bucket_policy" {
  statement {
    actions = [
      "s3:GetObject",
    ]

    resources = [
      "${aws_s3_bucket.default.arn}/*",
    ]

    principals {
      type = "AWS"
      identifiers = [
        aws_cloudfront_origin_access_identity.default.iam_arn,
      ]
    }
  }

  statement {
    actions = [
      "s3:ListBucket",
    ]

    resources = [
      aws_s3_bucket.default.arn,
    ]

    principals {
      type = "AWS"
      identifiers = [
        aws_cloudfront_origin_access_identity.default.iam_arn,
      ]
    }
  }
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.default.id
  policy = data.aws_iam_policy_document.s3_bucket_policy.json
}

#
# Cloudfront
#
resource "aws_cloudfront_origin_access_identity" "default" {
  comment = var.bucket_name
}

resource "aws_cloudfront_distribution" "default" {
  origin {
    domain_name = aws_s3_bucket.default.bucket_regional_domain_name
    origin_id   = local.s3_origin_id

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.default.cloudfront_access_identity_path
    }
  }

  aliases = concat([var.cloudfront_distribution], [var.bucket_name], var.cloudfront_aliases)

  comment             = "Managed by Terraform"
  default_root_object = var.cloudfront_default_root_object
  enabled             = true
  http_version        = "http2"
  is_ipv6_enabled     = true
  price_class         = var.cloudfront_price_class
  tags                = var.tags

  default_cache_behavior {
    target_origin_id = local.s3_origin_id

    // Read only
    allowed_methods = [
      "GET",
      "HEAD",
    ]

    cached_methods = [
      "GET",
      "HEAD",
    ]

    forwarded_values {
      query_string = false
      headers = [
        "Access-Control-Request-Headers",
        "Access-Control-Request-Method",
        "Origin"
      ]

      cookies {
        forward = "none"
      }
    }

    lambda_function_association {
      event_type = "viewer-request"
      lambda_arn = aws_lambda_function.default.qualified_arn
    }

    viewer_protocol_policy = "redirect-to-https"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }

  # Handle the case where no certificate ARN provided
  dynamic "viewer_certificate" {
    for_each = (var.cloudfront_acm_certificate_arn == null ? { use_acm = false } : {})

    content {
      ssl_support_method             = "sni-only"
      cloudfront_default_certificate = true
    }
  }

  # Handle the case where certificate ARN was provided
  dynamic "viewer_certificate" {
    for_each = (var.cloudfront_acm_certificate_arn != null ? { use_acm = true } : {}
    )
    content {
      ssl_support_method             = "sni-only"
      acm_certificate_arn            = var.cloudfront_acm_certificate_arn
      cloudfront_default_certificate = false
    }
  }
}

#
# Lambda
#
data "aws_iam_policy_document" "lambda_log_access" {
  // Allow lambda access to logging
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = [
      "arn:aws:logs:*:*:*",
    ]

    effect = "Allow"
  }
}

# This function is created in us-east-1 as required by CloudFront.
resource "aws_lambda_function" "default" {
  provider = aws.us-east-1

  description      = "Managed by Terraform"
  runtime          = "nodejs12.x"
  role             = aws_iam_role.lambda_role.arn
  filename         = data.local_file.distribution_zip.filename
  function_name    = "${replace(var.cloudfront_distribution,".","_")}_cloudfront_auth"
  handler          = "index.handler"
  publish          = true
  timeout          = 5
  source_code_hash = base64sha256(data.local_file.distribution_zip.content)
  tags             = var.tags

}

data "aws_iam_policy_document" "lambda_assume_role" {
  // Trust relationships taken from blueprint
  // Allow lambda to assume this role.
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type = "Service"
      identifiers = [
        "edgelambda.amazonaws.com",
        "lambda.amazonaws.com",
      ]
    }

    effect = "Allow"
  }
}

resource "aws_iam_role" "lambda_role" {
  name               = "${var.cloudfront_distribution}_lambda_auth_role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

# Attach the logging access document to the above role.
resource "aws_iam_role_policy_attachment" "lambda_log_access" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_log_access.arn
}

# Create an IAM policy that will be attached to the role
resource "aws_iam_policy" "lambda_log_access" {
  name   = "${var.cloudfront_distribution}_cloudfront_auth_lambda_log_access"
  policy = data.aws_iam_policy_document.lambda_log_access.json
}
