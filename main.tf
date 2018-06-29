resource "aws_kms_key" "audit" {
  description             = "This key is used to encrypt the audit logs in S3"
  deletion_window_in_days = 14
}

resource "aws_s3_bucket" "audit" {
  bucket = "${var.s3_audit_bucket_name}"
  acl    = "${var.s3_audit_bucket_acl}"

  versioning = {
    enabled = "${var.s3_audit_bucket_versioning}"
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = "${aws_kms_key.audit.arn}"
        sse_algorithm     = "aws:kms"
      }
    }
  }

  tags {
    terraform = "true"
  }

  lifecycle_rule {
    id      = "${var.s3_audit_bucket_lifecycle_id}"
    enabled = "${var.s3_audit_bucket_lifecycle_enabled}"

    prefix = "${var.s3_audit_log_prefix}"

    transition {
      days          = "${var.s3_audit_bucket_transition_standard_ia}"
      storage_class = "STANDARD_IA"
    }

    noncurrent_version_transition {
      days          = "${var.s3_audit_bucket_transition_non_current_standard_ia}"
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = "${var.s3_audit_bucket_transition_glacier}"
      storage_class = "GLACIER"
    }

    noncurrent_version_transition {
      days          = "${var.s3_audit_bucket_transition_non_current_glacier}"
      storage_class = "GLACIER"
    }

    expiration {
      days = "${var.s3_audit_bucket_expiration}"
    }

    noncurrent_version_expiration {
      days = "${var.s3_audit_bucket_expiration_non_current}"
    }
  }
}

data "aws_iam_policy_document" "s3_audit_policy" {
  statement {
    sid = "AWSCloudTrailAclCheck"

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    actions = [
      "s3:GetBucketAcl",
    ]

    resources = [
      "${aws_s3_bucket.audit.arn}",
    ]
  }

  statement {
    sid = "AWSCloudTrailWrite"

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    actions = [
      "s3:PutObject",
    ]

    resources = ["${formatlist("%s/AWSLogs/%s/*", aws_s3_bucket.audit.arn, var.ct_account_id_list)}"]

    condition = {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
  }
}

resource "aws_s3_bucket_policy" "ct_audit_bucket_policy" {
  bucket = "${aws_s3_bucket.audit.id}"
  policy = "${data.aws_iam_policy_document.s3_audit_policy.json}"
}
