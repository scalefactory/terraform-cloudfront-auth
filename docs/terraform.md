## Inputs

### Provider specific Inputs

Provider specific inputs marked required are only required for the specific auth
vendor. E.g `hd` is not required if you are using the `github` auth vendor.

**Google**

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| hd | The hosted domain (e.g example.com) | string | `` | yes |
| authz | The authorization method: (1) Hosted Domain - verify email's domain matches that of the given hosted domain\n   (2) HTTP Email Lookup - verify email exists in JSON array located at given HTTP endpoint\n   (3) Google Groups Lookup - verify email exists in one of given Google Groups | string | `1` | yes |

**Microsoft**

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| authz | The authorization method: (1) Azure AD Login (default)\n   (2) JSON Username Lookup | string | `1` | yes |

**GitHub**

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| github_organization | The github organization that owns the auth application | string | `` | yes |


### Standard

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| auth_vendor | The vendor to use for authorisation (google, microsoft, github, okta, auth0, centrify) | string | `` | yes |
| cloudfront_distribution | The FQDN of your cloudfront distribution you want to use to serve your private content (e.g www.example.com) | string | `` | yes |
| client_id | The client id of the auth application| string | `` | yes |
| client_secret | The client secret of the auth application| string | `` | yes |
| session_duration | Session duration in hours | string | `1` | no |
| bucket_name | The name of your S3 bucket | string | `` | yes |
| region | Region to launch your bucket in | string | `` | yes |
| tags | Tags to label resources with (e.g map('dev', 'prod')) | map | `<map>` | no |
| cloudfront_aliases | List of FQDNs to be used as alternative domain names (CNAMES) for Cloudfront | list | `<list>` | no |
| cloudfront_price_class | Cloudfront price classes: `PriceClass_All`, `PriceClass_200`, `PriceClass_100` | string | `PriceClass_All` | no |
| cloudfront_default_root_object | The default root object of the Cloudfront distribution | string | `index.html` | no |
| cloudfront_acm_certificate_arn | The ARN of the ACM managed Certificate for the Cloudfront distribution (e.g arn:aws:acm:us-east-1:111111111111:certificate/40eae56f-3acf-4009-89a5-3f3e0fdba331). **NOTE**: The certificate must be created in the `us-east-1` region to work with Cloudfront | string | `` | yes |

## Outputs

| Name | Description |
|------|-------------|
| s3_bucket | The name of the S3 Bucket |
| cloudfront_arn | ARN of the Cloudfront Distribution |
| cloudfront_id | ID of the Cloudfront Distribution |
