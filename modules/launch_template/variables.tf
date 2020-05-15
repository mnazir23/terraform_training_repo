variable "template_name" {
  type        = string
  default     = "ec2_launch_template"
  description = "Name of the Launch Template"
}

variable "ami_id" {
  type        = string
  default     = "ami-085925f297f89fce1"
  description = "AMI ID of the Image to be Used"
}

variable "vm_size" {
  type        = string
  default     = "t2.micro"
  description = "Size of the VM"
}

variable "key_pair_name" {
  default = "maham-terraform"
  description = "Public Key for SSHing into the Machine"
}

variable "availability_zone" {
  default     = "us-east-1a"
  description = "Availability Zone for the Launch Template"
}

variable "secgroup_id" {
  description = "Security Group Settings for the Launch Template"
}

variable "user_data" {
  default     = ""
  description = "User Data for the Machines"
}


