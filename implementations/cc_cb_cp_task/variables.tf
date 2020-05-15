variable "aws_region" {
  type        = string
  default     = "us-east-1"
  description = "AWS Region for Deployment"
}

### CodeCommit Variables

variable "repo_name" {
  type        = string
  default     = "tf_tr_repo"
  description = "Name of the CodeCommit Repository"
}

### S3 Variables

variable "bucket_name" {
  type        = string
  default     = "dark-germany-bucket"
  description = "S3 Bucket Name"
}

variable "access_level" {
  type        = string
  default     = "public-read"
  description = "Access Level for the S3 Bucket"
}

### IAM Variables

variable "policy_name" {
  type        = string
  default     = "s3_codebuild_policy"
  description = "S3 Accessing Policy for CodeBuild"
}


variable "role_name" {
  type        = string
  default     = "s3_codebuild_role"
  description = "Role for CodeBuild to Access S3"
}

### CodeBuild Variables

variable "project_name" {
  type        = string
  default     = "cbs_project"
  description = "Name of the CodeBuild Project"
}

variable "cb_description" {
  type        = string
  default     = "A CodeBuild Project"
  description = "A CodeBuild Project"
}

variable "build_timeout" {
  type        = string
  default     = "5"
  description = "Number of Retries After Which Build Will Timeout"
}

variable "artifact_type" {
  type        = string
  default     = "S3"
  description = "The Location Where to Upload the Build Artifact"
}

variable "env_compute_type" {
  type = string
  default = "BUILD_GENERAL1_SMALL"
  description = "Size of the Machine"
}

variable "env_image" {
  type = string
  default = "aws/codebuild/standard:4.0"
  description = "CodeBuild Image to Use"
}

variable "env_type" {
  type = string
  default = "LINUX_CONTAINER"
  description = "Type of Operating System"
}

variable "env_image_pull_credentials_type" {
  type = string
  default = "CODEBUILD"
  description = "N/A"
}

variable "source_type" {
  type = string
  default = "CODECOMMIT"
  description = "Source Code Repository Type"
}

### CodePipeline Variables

variable "cp_policy_name" {
  default = "cp_cb_access_policy"
  description = "Name of the IAM Policy for CodePipeline"
}

variable "cp_role_name" {
  default = "cp_cb_access_role"
  description = "Name of the IAM Role for CodePipeline"
}

variable "codepipeline_name" {
  default = "s3_codepipeline"
  description = "Name of the CodePipeline"
}

variable "cp_artifact_type" {
  default = "S3"
  description = "The Type of Artifact Store"
}

variable "cp_encryption_type" {
  default = "KMS"
  description = "The Type of the Encryption Key"
}

variable "owner" {
  default = "AWS"
  description = "Owner of the Multiple Resources Used in CodePipeline Stages"
}

# Source Stage
variable "source_name" {
  default = "Source"
  description = "The Type of Action to be Taken"
}

variable "source_provider" {
  default = "CodeCommit"
  description = "The Provider of the Source Repository"
}

variable "branch_name" {
  default = "master"
  description = "Name of the Source Repository Branch"
}

# Build Stage
variable "build_name" {
  default = "Build"
  description = "Name of the Build Stage"
}

variable "build_provider" {
  default = "CodeBuild"
  description = "Name of the Tool Running the Build Stage"
}