locals {
  website_config = {
    redirect_all = [
      {
        redirect_all_requests_to = "${var.redirect_all_requests_to}"
      },
    ]

    default = [
      {
        index_document = "${var.index_document}"
        error_document = "${var.error_document}"
        routing_rules  = "${var.routing_rules}"
      },
    ]
  }

  sample_htmls = [
    "index.html",
    "404.html",
  ]

  logs_prefix     = "${var.logs_prefix == "" ? var.hostname : var.logs_prefix}"
//  dns_record_name = "${replace(var.hostname, ".${var.zone_name}" ,"" )}"
}

//variable "name" {
//  description = "The Name of the application or solution  (e.g. `bastion` or `portal`)"
//}

variable "logs_prefix" {
  default = ""
}

variable "error_document" {
  default     = "404.html"
  description = "An absolute path to the document to return in case of a 4XX error"
}

variable "index_document" {
  default     = "index.html"
  description = "Amazon S3 returns this index document when requests are made to the root domain or any of the subfolders"
}

variable "redirect_all_requests_to" {
  default     = ""
  description = "A hostname to redirect all website requests for this bucket to. If this is set `index_document` will be ignored."
}

variable "routing_rules" {
  default     = ""
  description = "A json array containing routing rules describing redirect behavior and when redirects are applied"
}

variable "cors_allowed_headers" {
  type = "list"

  default = [
    "*",
  ]

  description = "List of allowed headers"
}

variable "cors_allowed_methods" {
  type = "list"

  default = [
    "GET",
  ]

  description = "List of allowed methods (e.g. ` GET, PUT, POST, DELETE, HEAD`) "
}

variable "cors_allowed_origins" {
  type = "list"

  default = [
    "*",
  ]

  description = "List of allowed origins (e.g. ` example.com, test.com`)"
}
variable "lifecycle_prefix" {
  description = "Prefix filter. Used to manage object lifecycle events."
  default     = ""
}
variable "cors_expose_headers" {
  type = "list"

  default = [
    "ETag",
  ]

  description = "List of expose header in the response"
}
variable "policy" {
  description = "A valid bucket policy JSON document. Note that if the policy document is not specific enough (but still valid), Terraform may view the policy as constantly changing in a terraform plan. In this case, please make sure you use the verbose/specific version of the policy."
  default     = ""
}
variable "lifecycle_tags" {
  description = "Tags filter. Used to manage object lifecycle events."
  default     = {}
  type = "map"
}
variable "standard_transition_days" {
  description = "Number of days to persist in the standard storage tier before moving to the infrequent access tier"
  default     = "30"
}

variable "glacier_transition_days" {
  description = "Number of days after which to move the data to the glacier storage tier"
  default     = "60"
}

variable "expiration_days" {
  description = "Number of days after which to expunge the objects"
  default     = "90"
}
variable "cors_max_age_seconds" {
  default     = "3600"
  description = "Time in seconds that browser can cache the response"
}

variable "hostname" {
  description = "Name of website bucket in `fqdn` format (e.g. `test.example.com`). IMPORTANT! Do not add trailing dot (`.`)"
}

variable "region" {
  default     = ""
  description = "AWS region this bucket should reside in"
}

variable "versioning_enabled" {
  default     = "false"
  description = "State of versioning (e.g. `true` or `false`)"
}

variable "force_destroy" {
  default     = ""
  description = "Delete all objects from the bucket so that the bucket can be destroyed without error (e.g. `true` or `false`)"
}

variable "logs_expiration_days" {
  description = "Number of days after which to expunge the objects"
  default     = "90"
}

variable "lifecycle_rule_enabled" {
  default     = ""
  description = "Lifecycle rule status (e.g. `true` or `false`)"
}

variable "prefix" {
  default     = ""
  description = "Prefix identifying one or more objects to which the rule applies"
}

variable "noncurrent_version_transition_days" {
  default     = "30"
  description = "Number of days to persist in the standard storage tier before moving to the glacier tier infrequent access tier"
}

variable "noncurrent_version_expiration_days" {
  default     = "90"
  description = "Specifies when noncurrent object versions expire"
}

variable bucket_acl {
  type        = "string"
  default     = "private"
  description = "Bucket ACL - Default: public-read"
}

variable "allowed_ips_cidr" {
  type = "list"

  default = [
    "0.0.0.0/0",
  ]

  description = "List of allowed IP's. If not provided HTTP access **will be public 0.0.0.0/0**"
}

variable "temp_html" {
  type = "list"

  default = [
    "index.html",
    "404.html",
  ]

  description = "Temporary index.html and 404.html"
}

variable "tags" {
  type    = "map"
  default = {}
}
variable "dns_ttl" {
  default     = "240"
  description = "Route 53 DNS TTL"
}

//variable "zone_name" {
//  description = "Route 53 zone name. I.e.: correia.io"
//}

variable "replication_source_principal_arns" {
  type        = "list"
  default     = []
  description = "(Optional) List of principal ARNs to grant replication access from different AWS accounts"
}

variable "deployment_arns" {
  type        = "map"
  default     = {}
  description = "(Optional) Map of deployment ARNs to lists of S3 path prefixes to grant `deployment_actions` permissions"
}

variable "deployment_actions" {
  type = "list"

  default = [
    "s3:PutObject",
    "s3:PutObjectAcl",
    "s3:GetObject",
    "s3:DeleteObject",
    "s3:ListBucket",
    "s3:ListBucketMultipartUploads",
    "s3:GetBucketLocation",
    "s3:AbortMultipartUpload",
  ]

  description = "List of actions to permit deployment ARNs to perform"
}

variable "upload_sample_htmls" {
  default     = false
  description = "Uploads index.html and 404.html samples"
}
