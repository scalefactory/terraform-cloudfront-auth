variable "cloudfront_auth_brach" {
  type        = string
  default     = "cognito"
  description = "https://github.com/mslipets/cloudfront-auth/{branch_name} (current actual \"cognito\")"
}

variable "auth_vendor" {
  type        = string
  description = "The vendor to use for authorisation (google, cognito, microsoft, github, okta, auth0, centrify)"
}

variable "cloudfront_distribution" {
  type        = string
  description = "The cloudfront distribtion"
}

variable "client_id" {
  type        = string
  description = "The authorisation client id"
}

variable "client_secret" {
  type        = string
  description = "The authorisation client secret"
}

variable "base_uri" {
  type        = string
  description = "The Base URL for Cognito configuration e.g.: https://cognito-idp.{REGION}.amazonaws.com/{USER-POOL-ID}"
}

variable "redirect_uri" {
  type        = string
  description = "The redirect uri "
}

variable "hd" {
  type        = string
  default     = ""
  description = "The hosted domain (google only)"
}

variable "session_duration" {
  type        = string
  default     = "1"
  description = "Session duration in hours"
}

variable "authz" {
  type        = string
  default     = "1"
  description = "The authorisation method (google, microsoft only). Mirosoft: (1) Azure AD Login (default)\n   (2) JSON Username Lookup\n\n Google: (1) Hosted Domain - verify email's domain matches that of the given hosted domain\n   (2) HTTP Email Lookup - verify email exists in JSON array located at given HTTP endpoint\n   (3) Google Groups Lookup - verify email exists in one of given Google Groups"
}

variable "github_organization" {
  type        = string
  default     = ""
  description = "The GitHub organization. Required for GitHub auth vendor only"
}

variable "bucket_name" {
  type        = string
  description = "The name of your s3 bucket"
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
  description = "Cloudfront price classes: `PriceClass_All`, `PriceClass_200`, `PriceClass_100`"
}

variable "cloudfront_default_root_object" {
  type        = string
  default     = "index.html"
  description = "The default root object of the Cloudfront distribution"
}

variable "cloudfront_acm_certificate_arn" {
  description = "ACM Certificate ARN for Cloudfront"
  default     = ""
}

variable "nodejs_version" {
  type        = string
  default     = "10.19.0"
  description = "Node.js runtime version."
}

variable "geo_restriction_whitelisted_locations" {
  type        = string
  default     = "" #"IE"
  description = "List of whitelist locations (Optional) - The ISO 3166-1-alpha-2 codes for which you want CloudFront either to distribute your content (whitelist)."
}