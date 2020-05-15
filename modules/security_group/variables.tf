variable "sg_name" {
  description = "Name for the Security Group"
}

variable "vpc_id" {
  default = null
  description = "VPC to which this security group will belong"
}

