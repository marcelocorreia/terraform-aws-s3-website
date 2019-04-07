# terraform-aws-s3-website 
---
![shield](https://img.shields.io/github/release/marcelocorreia/terraform-aws-s3-website.svg)
![shield](https://img.shields.io/github/last-commit/marcelocorreia/terraform-aws-s3-website.svg)
![shield](https://img.shields.io/github/repo-size/marcelocorreia/terraform-aws-s3-website.svg)
![shield](	https://img.shields.io/github/issues/marcelocorreia/terraform-aws-s3-website.svg)

---

## TL;DR;
- [Inputs](#inputs) & [Outputs](#outputs)

- blah blah
- blah blah bleh
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| allowed\_ips | List of allowed IP's. If not provided HTTP access **will be public 0.0.0.0/0** | list | `<list>` | no |
| bucket\_acl | Bucket ACL - Default: public-read | string | `"private"` | no |
| cors\_allowed\_headers | List of allowed headers | list | `<list>` | no |
| cors\_allowed\_methods | List of allowed methods (e.g. ` GET, PUT, POST, DELETE, HEAD`) | list | `<list>` | no |
| cors\_allowed\_origins | List of allowed origins (e.g. ` example.com, test.com`) | list | `<list>` | no |
| cors\_expose\_headers | List of expose header in the response | list | `<list>` | no |
| cors\_max\_age\_seconds | Time in seconds that browser can cache the response | string | `"3600"` | no |
| deployment\_actions | List of actions to permit deployment ARNs to perform | list | `<list>` | no |
| deployment\_arns | (Optional) Map of deployment ARNs to lists of S3 path prefixes to grant `deployment_actions` permissions | map | `<map>` | no |
| dns\_ttl | Route 53 DNS TTL | string | `"240"` | no |
| error\_document | An absolute path to the document to return in case of a 4XX error | string | `"404.html"` | no |
| expiration\_days | Number of days after which to expunge the objects | string | `"90"` | no |
| force\_destroy | Delete all objects from the bucket so that the bucket can be destroyed without error (e.g. `true` or `false`) | string | `""` | no |
| glacier\_transition\_days | Number of days after which to move the data to the glacier storage tier | string | `"60"` | no |
| hostname | Name of website bucket in `fqdn` format (e.g. `test.example.com`). IMPORTANT! Do not add trailing dot (`.`) | string | n/a | yes |
| index\_document | Amazon S3 returns this index document when requests are made to the root domain or any of the subfolders | string | `"index.html"` | no |
| lifecycle\_prefix | Prefix filter. Used to manage object lifecycle events. | string | `""` | no |
| lifecycle\_rule\_enabled | Lifecycle rule status (e.g. `true` or `false`) | string | `""` | no |
| lifecycle\_tags | Tags filter. Used to manage object lifecycle events. | map | `<map>` | no |
| logs\_expiration\_days | Number of days after which to expunge the objects | string | `"90"` | no |
| logs\_prefix |  | string | `""` | no |
| noncurrent\_version\_expiration\_days | Specifies when noncurrent object versions expire | string | `"90"` | no |
| noncurrent\_version\_transition\_days | Number of days to persist in the standard storage tier before moving to the glacier tier infrequent access tier | string | `"30"` | no |
| policy | A valid bucket policy JSON document. Note that if the policy document is not specific enough (but still valid), Terraform may view the policy as constantly changing in a terraform plan. In this case, please make sure you use the verbose/specific version of the policy. | string | `""` | no |
| prefix | Prefix identifying one or more objects to which the rule applies | string | `""` | no |
| redirect\_all\_requests\_to | A hostname to redirect all website requests for this bucket to. If this is set `index_document` will be ignored. | string | `""` | no |
| region | AWS region this bucket should reside in | string | `""` | no |
| replication\_source\_principal\_arns | (Optional) List of principal ARNs to grant replication access from different AWS accounts | list | `<list>` | no |
| routing\_rules | A json array containing routing rules describing redirect behavior and when redirects are applied | string | `""` | no |
| standard\_transition\_days | Number of days to persist in the standard storage tier before moving to the infrequent access tier | string | `"30"` | no |
| tags |  | map | `<map>` | no |
| temp\_html | Temporary index.html and 404.html | list | `<list>` | no |
| upload\_sample\_htmls | Uploads index.html and 404.html samples | string | `"false"` | no |
| versioning\_enabled | State of versioning (e.g. `true` or `false`) | string | `"false"` | no |
| zone\_name | Route 53 zone name. I.e.: correia.io | string | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| allowed\_ips | List of allowed IP's |
| dns | FQDN |
| hostname | Bucket hostname |
| s3\_bucket\_arn | Name of of website bucket |
| s3\_bucket\_domain\_name | Name of of website bucket |
| s3\_bucket\_hosted\_zone\_id | The Route 53 Hosted Zone ID for this bucket's region |
| s3\_bucket\_name | DNS record of website bucket |
| s3\_bucket\_website\_domain | The domain of the website endpoint |
| s3\_bucket\_website\_endpoint | The website endpoint URL |

## License 

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0) 

See [LICENSE](LICENSE) for full details.

    Licensed to the Apache Software Foundation (ASF) under one
    or more contributor license agreements.  See the NOTICE file
    distributed with this work for additional information
    regarding copyright ownership.  The ASF licenses this file
    to you under the Apache License, Version 2.0 (the
    "License"); you may not use this file except in compliance
    with the License.  You may obtain a copy of the License at

      https://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing,
    software distributed under the License is distributed on an
    "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
    KIND, either express or implied.  See the License for the
    specific language governing permissions and limitations
    under the License.



