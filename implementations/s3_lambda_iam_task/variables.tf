variable "aws_region" {
  type        = string
  default     = "us-east-1"
  description = "AWS Region for Deployment"
}

### S3 Variables

variable "source_bucket" {
  type        = string
  default     = "source-mn-bucket"
  description = "Name of the Source S3 Bucket"
}

variable "destination_bucket" {
  type        = string
  default     = "destination-mn-bucket"
  description = "Name of the Destination S3 Bucket"
}

variable "access_level" {
  type        = string
  default     = "private"
  description = "Access Level for the S3 Bucket"
}

### IAM Policy & Role Variables

variable "policy_name" {
    default = "s3-lambda-policy"
    description = "Name of the IAM Policy for the S3 Buckets"
}

variable "role_name" {
    default = "s3-lambda-role"
    description = "Name for the IAM Role"
}

variable "main_user_id" {
    default = "<Your User Role ID>"
    description = "Role ID for your AWS User"
}

### Lambda Function Variables
variable "function_name" {
    default = "s3_lambda_function"
    description = "Name of the Lambda Function"
}

variable "runtime_env" {
    default = "nodejs12.x"
    description = "Runtime Environment for the Lambda Function"
}

variable "statement_id" {
    default = "AllowExecutionFromS3Bucket"
    description = "Stating Purpose of the Lambda Permission Resource"
}

variable "action" {
    default = "lambda:InvokeFunction"
    description = "Type of Action to Perform on the Lambda Function"
}

variable "principal" {
    default = "s3.amazonaws.com"
    description = "The Resource to Which Access is Being Allowed"
}