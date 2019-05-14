resource "aws_s3_bucket" "default" {
  bucket        = "${var.hostname}"
  acl           = "${var.bucket_acl}"
  tags          = "${merge(var.tags,map("Name",var.hostname))}"
  region        = "${var.region}"
  force_destroy = "${var.force_destroy}"

  logging {
    target_bucket = "${aws_s3_bucket.log.bucket}"
    target_prefix = "${local.logs_prefix}"
  }

  website = "${local.website_config[var.redirect_all_requests_to == "" ? "default" : "redirect_all"]}"

  cors_rule {
    allowed_headers = "${var.cors_allowed_headers}"
    allowed_methods = "${var.cors_allowed_methods}"
    allowed_origins = ["${var.cors_allowed_origins}"]
    expose_headers  = "${var.cors_expose_headers}"
    max_age_seconds = "${var.cors_max_age_seconds}"
  }

  versioning {
    enabled = "${var.versioning_enabled}"
  }

  lifecycle_rule {
    id      = "${var.hostname}"
    enabled = "${var.lifecycle_rule_enabled}"
    prefix  = "${var.prefix}"
    tags    = "${merge(var.tags,map("Name",var.hostname))}"

    noncurrent_version_transition {
      days          = "${var.noncurrent_version_transition_days}"
      storage_class = "GLACIER"
    }

    noncurrent_version_expiration {
      days = "${var.noncurrent_version_expiration_days}"
    }
  }

}

resource "aws_s3_bucket" "log" {
  bucket        = "logs.${var.hostname}"
  acl           = "log-delivery-write"
  region        = "${var.region}"
  force_destroy = "${var.force_destroy}"
  policy        = "${var.policy}"
  versioning {
    enabled = "false"
  }
  server_side_encryption_configuration {
    "rule" {
      "apply_server_side_encryption_by_default" {
        sse_algorithm = "AES256"
      }
    }
  }

  lifecycle_rule {
    id      = "logs.${var.hostname}"
    enabled = "${var.lifecycle_rule_enabled}"

    prefix = "${var.lifecycle_prefix}"
    tags   = "${var.lifecycle_tags}"

    noncurrent_version_expiration {
      days = "${var.noncurrent_version_expiration_days}"
    }

    noncurrent_version_transition {
      days          = "${var.noncurrent_version_transition_days}"
      storage_class = "GLACIER"
    }

    transition {
      days          = "${var.standard_transition_days}"
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = "${var.glacier_transition_days}"
      storage_class = "GLACIER"
    }

    expiration {
      days = "${var.expiration_days}"
    }
  }
}

resource "aws_s3_bucket_policy" "default" {
  bucket = "${aws_s3_bucket.default.id}"
  policy = "${data.aws_iam_policy_document.default.json}"
}

resource "aws_s3_bucket_object" "temp_htmls" {
  count        = "${var.upload_sample_htmls ? length(var.temp_html) : 0}"
  bucket       = "${aws_s3_bucket.default.bucket}"
  key          = "${element(local.sample_htmls,count.index )}"
  source       = "${path.module}/${element(local.sample_htmls,count.index )}"
  tags         = "${merge(var.tags,map("Name","temp html"))}"
  content_type = "text/html"
  acl          = "${var.bucket_acl}"
}

