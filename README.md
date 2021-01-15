# terraform-cloudfront-auth [![Latest Release](https://img.shields.io/github/release/scalefactory/terraform-cloudfront-auth.svg)](https://github.com/scalefactory/terraform-cloudfront-auth/releases/latest) [![License](https://img.shields.io/badge/License-ISC-blue.svg)](https://opensource.org/licenses/ISC)

This is an open source project published by The Scale Factory.

We currently consider this project to be hibernating.

These are projects that we’re no longer prioritising, but which we keep ticking over for the benefit of the few customers we support who still use them.

:information_source: We’re not regularly patching these projects, or actively watching for issues or PRs. We’ll periodically make updates or respond to contributions if one of the team has some spare time to invest.

A Terraform module to provision a Cloudfront distribution to serve private
content in an S3 bucket with Lamba@Edge Google/Microsoft/Github/Okta/Auth0/Centrify
authentication. Based on [Widen - Cloudfront Auth](https://github.com/Widen/cloudfront-auth/)


---


## Screenshots


![Example](/docs/code.png)
*Example using GitHub authentication*


## Introduction

You should use this module if you have a private S3 bucket that you want to
guard with Google/Microsoft/Github/Okta/Auth0/Centrify authentication.

The Terraform packages up
[cloudfront-auth](https://github.com/Widen/cloudfront-auth/) into a Lambda
function to be used by Cloudfront's
[Lambda@Edge](https://aws.amazon.com/lambda/edge/). A private S3 bucket and
Cloudfront Distribution will also be created.

## Usage

**NOTE**: You will need to create a certificate with AWS Certificate Manager in
the `us-east-1` region. The example below assumes a certificate for the domain
`example.com` already exists.

```hcl
module "cloudfront_auth" {
  source                         = "git::https://github.com/scalefactory/terraform-cloudfront-auth.git?ref=master"

  auth_vendor                    = "github"
  cloudfront_distribution        = "private.example.com"
  client_id                      = "CHANGE_ME"
  client_secret                  = "CHANGE_ME"
  redirect_uri                   = "https://private.example.com/callback"
  github_organization            = "exampleorg"

  bucket_name                    = "private.example.com"
  region                         = "eu-west-1"
  cloudfront_acm_certificate_arn = "${data.aws_acm_certificate.example.arn}"
}

data "aws_acm_certificate" "example" {
  domain   = "example.com"
  statuses = ["ISSUED"]
}
```


## Examples

A Full working example can be found in [example](./example) folder. Please
update the `cloudfront_auth` module parameters. **NOTE**: The certificate will
need validating with email first.


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




## References

For additional context, refer to some of these links.

- [Widen - Cloudfront Auth](https://github.com/Widen/cloudfront-auth/) - This project wraps Terraform around Widen's cloudfront-auth around
- [Terraform](https://terraform.io) - Infrastructure as code


## Help

**Got a question?**

File a GitHub [issue](https://github.com/scalefactory/terraform-cloudfront-auth/issues).

## Contributing

### Bug Reports & Feature Requests

Please use the [issue tracker](https://github.com/scalefactory/terraform-cloudfront-auth/issues) to report any bugs or file feature requests.

### Developing

We welcome all pull requests to our open source projects. We follow
"fork-and-pull" Git workflow.

 1. **Fork** the repository on GitHub
 2. **Clone** your fork to your local development environment
 3. **Commit** changes to your own branch in your project
 4. **Push** your changes back to GitHub
 5. Submit a **Pull Request** so that we can review your changes

**NOTE:** Be sure to merge the latest changes from "upstream" before making a
pull request!



## Copyrights

Copyright © 2019-2020 [The Scale Factory Ltd.](https://scalefactory.com/)

Copyright © 2017-2019 [Widen Enterprises](https://www.widen.com/)








## License

[![License: ISC](https://img.shields.io/badge/License-ISC-blue.svg)](https://opensource.org/licenses/ISC)

ISC License (ISC)

Copyright (c) 2019, The Scale Factory Ltd.

Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted, provided that the above copyright notice and this permission notice appear in all copies.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

Source: <https://opensource.org/licenses/ISC>




## About

This project is maintained by [The Scale Factory][website]. Like it? Please
give it a ★.

<a href="https://scalefactory.com">
  <img src="https://academy.scalefactory.com/images/logo.svg"
    alt="Scale Factory"
    data-canonical-src="https://academy.scalefactory.com/images/logo.svg"
    width="300px">
</a>

We're a [DevOps and Cloud Infrastructure Consultancy][services] company based in London,
UK. We love empowering teams to deliver more with [AWS][aws].

Check out [our other projects][github], [follow us on twitter][twitter], or [hire us][services] to help with your cloud strategy and implementation.


### Contributors

|  [![Steve Porter][steveporter92_avatar]][steveporter92_homepage]<br/>[Steve Porter][steveporter92_homepage] |
|  [![Tim Bannister][sftim_avatar]][sftim_homepage]<br/>[Tim Bannister][sftim_homepage] |
|---|

  [steveporter92_homepage]: https://github.com/steveporter92
  [steveporter92_avatar]: https://github.com/steveporter92.png?size=150
  [sftim_homepage]: https://github.com/sftim
  [sftim_avatar]: https://github.com/sftim.png?size=150




  [logo]: https://academy.scalefactory.com/images/logo.svg
  [website]: https://scalefactory.com
  [github]: https://github.com/scalefactory
  [services]: https://www.scalefactory.com/services
  [aws]: https://aws.amazon.com/
  [linkedin]: https://www.linkedin.com/company/the-scale-factory
  [twitter]: https://twitter.com/scalefactory
  [email]: https://www.scalefactory.com/contact-us
  [share_twitter]: https://twitter.com/intent/tweet/?text=terraform-cloudfront-auth&url=https://github.com/scalefactory/terraform-cloudfront-auth
  [share_linkedin]: https://www.linkedin.com/shareArticle?mini=true&title=terraform-cloudfront-auth&url=https://github.com/scalefactory/terraform-cloudfront-auth
  [share_reddit]: https://reddit.com/submit/?url=https://github.com/scalefactory/terraform-cloudfront-auth
  [share_facebook]: https://facebook.com/sharer/sharer.php?u=https://github.com/scalefactory/terraform-cloudfront-auth
  [share_email]: mailto:?subject=terraform-cloudfront-auth&body=https://github.com/scalefactory/terraform-cloudfront-auth
