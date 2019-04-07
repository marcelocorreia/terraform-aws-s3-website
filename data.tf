data "aws_iam_policy_document" "replication" {
  count = "${signum(length(var.replication_source_principal_arns))}"

  statement {
    principals {
      type = "AWS"

      identifiers = [
        "${var.replication_source_principal_arns}",
      ]
    }

    actions = [
      "s3:GetBucketVersioning",
      "s3:PutBucketVersioning",
      "s3:ReplicateObject",
      "s3:ReplicateDelete",
    ]

    resources = [
      "${aws_s3_bucket.default.arn}",
      "${aws_s3_bucket.default.arn}/*",
    ]
  }
}

data "aws_iam_policy_document" "deployment" {
  count = "${length(keys(var.deployment_arns))}"

  statement {
    actions = [
      "${var.deployment_actions}",
    ]

    resources = [
      "${formatlist("${aws_s3_bucket.default.arn}%s", var.deployment_arns[element(keys(var.deployment_arns), count.index)])}",
      "${formatlist("${aws_s3_bucket.default.arn}%s/*", var.deployment_arns[element(keys(var.deployment_arns), count.index)])}",
    ]

    principals {
      type = "AWS"

      identifiers = [
        "${element(keys(var.deployment_arns), count.index)}",
      ]
    }
  }
}

data "aws_iam_policy_document" "http_access" {
  count = "${signum(length(var.allowed_ips_cidr))}"
  statement {
    sid    = "httpAccess"
    effect = "Allow"

    principals {
      identifiers = [
        "*",
      ]

      type = "AWS"
    }

    actions = [
      "s3:*",
    ]

    resources = [
      "${aws_s3_bucket.default.arn}/*",
      "${aws_s3_bucket.default.arn}",
    ]

    condition {
      test = "IpAddress"

      values = [
        "${var.allowed_ips_cidr}",
      ]

      variable = "aws:SourceIp"
    }

  }
}

data "aws_iam_policy_document" "default" {
  # Support replication ARNs
  statement = [
    "${flatten(data.aws_iam_policy_document.replication.*.statement)}",
  ]

  # Support deployment ARNs
  statement = [
    "${flatten(data.aws_iam_policy_document.deployment.*.statement)}",
  ]

  # HTTP access Whitelist
  statement = [
    "${flatten(data.aws_iam_policy_document.http_access.*.statement)}",
  ]
}

data "aws_route53_zone" "dns_zone_name" {
  name = "${var.zone_name}"
}