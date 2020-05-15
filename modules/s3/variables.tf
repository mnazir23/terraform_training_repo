variable "bucket_name" {
  description = "Name of the S3 Bucket"
}

variable "acl" { 
  description = "Permissions for S3"
}

variable "policy_json" {
  default = "None"
  description = "Policy code in JSON"
}