variable "vpc_id" {
  description = "ID for the VPC to which this subnet belongs"
}

variable "igw_id" {
  description = "ID for the Internet Gateway"
}

variable "public_subnets" {
  description = "Public Subnets to which Route Table will be Connected"
}