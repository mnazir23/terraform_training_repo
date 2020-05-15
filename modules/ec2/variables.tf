variable "subnet_id" {
  default = null
  description = "Subnet ID for the Subnet Under which this EC2 Instance will Reside"
}

variable "machine_name" {
    description = "Name for the EC2 Instance"
}

variable "secgroup_id" {
  default = ""
  description = "ID for the Security Group to be Attached"
}

variable "key_name" {
  description = "SSH Key File For Logging into the Machine"
}

variable "user_data" {
  default     = ""
  description = "Any commands to be executed when EC2 instance gets launched"
}

variable "iam_role" {
  default = "None"
  description = "IAM Role to be attached to the EC2 instance"
}

variable "availability_zone" {
  default = "us-east-1a"
  description = "AZ for EC2 Intance"
}