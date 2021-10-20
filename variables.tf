
variable "cloudfront_distribution" {
  type        = string
  description = "The cloudfront distribtion"
}

variable "session_duration" {
  type        = number
  default     = 1
  description = "Session duration in hours"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags to label resources with (e.g map('dev', 'prod'))"
}

variable "region" {
  type        = string
  description = "The region to deploy the S3 bucket into"
}

variable "cloudfront_aliases" {
  type        = list(string)
  default     = []
  description = "List of FQDNs to be used as alternative domain names (CNAMES) for Cloudfront"
}

variable "cloudfront_price_class" {
  type        = string
  default     = "PriceClass_All"
  description = "Cloudfront price class; for example: 'PriceClass_All', 'PriceClass_200', 'PriceClass_100'"

  validation {
    condition     = can(regex("^PriceClass_", var.cloudfront_price_class))
    error_message = "The cloudfront_price_class value must start with \"PriceClass_\"."
  }
}

variable "cloudfront_default_root_object" {
  type        = string
  default     = "index.html"
  description = "The default root object of the Cloudfront distribution"
}

variable "cloudfront_acm_certificate_arn" {
  description = "ACM Certificate ARN for Cloudfront"
  default     = null
}

variable "name" {
  type = string
}

variable "environment" {
  type = string
}

variable "lambda_filename" {
  type = string
}
