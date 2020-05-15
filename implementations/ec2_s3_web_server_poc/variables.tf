variable "aws_region" {
  type        = string
  default     = "us-east-1"
  description = "Region of AWS that will be used"
}

### IAM Role Variables
variable "role_name" {
  default = "ec2_s3_radonly"
  description = "Name of the IAM role to be created"
}


### S3 Variables
variable "s3_bucket_name" {
  default = "test-mn-bucket"
  description = "S3 Bucket Name"
}

variable "access_level" {
  default = "private"
  description = "S3 bucket access level"
}

variable "main_user_id" {
  default = "<>"
  description = "My AWS Account ID"
}

### Security Group Variables
variable "secgroup_name" {
  default = "mn-test-sg"
  description = "Name of the security group"
}

variable "cidr_value" {
  default = "0.0.0.0/0"
  description = "CIDR Block for the security group"
}

### EC2 Variables
variable "machine_name" {
  default = "mn-test-instance"
  description = "Name of the EC2 instance"
}

variable "key_pair_name" {
  default = "maham-terraform"
  description = "Public key for SSHing into the machine"
}