output "bucket_id" {
  value = "${aws_s3_bucket.audit.id}"
}

output "bucket_arn" {
  value = "${aws_s3_bucket.audit.arn}"
}
