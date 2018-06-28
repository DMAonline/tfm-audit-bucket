variable "s3_audit_bucket_name" {
  description = "Name of the S3 audit bucket"
}

variable "s3_audit_bucket_acl" {
  default     = "private"
  description = "ACL of the S3 audit bucket"
}

variable "s3_audit_bucket_versioning" {
  default     = "true"
  description = "Should the audit bucket be versioned"
}

variable "s3_audit_log_prefix" {
  default     = "AWSLogs/"
  description = "Prefix of where AWS cloud logs are stored"
}

variable "s3_audit_bucket_lifecycle_id" {
  default     = "aws-logs"
  description = "ID for the lifecycle rule on the bucket"
}

variable "s3_audit_bucket_lifecycle_enabled" {
  default     = "true"
  description = "Should the lifecycle policy be enabled on the audit bucket"
}

variable "s3_audit_bucket_transition_standard_ia" {
  default     = 30
  description = "Days after current version created until transition to standard infrequent access"
}

variable "s3_audit_bucket_transition_non_current_standard_ia" {
  default     = 30
  description = "Days after non current version created until transition to standard infrequent access"
}

variable "s3_audit_bucket_transition_glacier" {
  default     = 90
  description = "Days after current version created until transition to glacier"
}

variable "s3_audit_bucket_transition_non_current_glacier" {
  default     = 60
  description = "Days after non current version created until transition to glacier"
}

variable "s3_audit_bucket_expiration" {
  default     = 455
  description = "Days until current object is expired and deleted"
}

variable "s3_audit_bucket_expiration_non_current" {
  default     = 455
  description = "Days until non current version object is expired and deleted"
}

variable "ct_account_id_list" {
  type        = "list"
  description = "List of account ids to allow writing of cloudtrail logs to the audit bucket"
}
