variable "nat_id" {
  description = "NAT Gateway ID for the Route Table"
}

variable "private_subnets" {
  description = "Subnets to which Route Table will be Associated with"
}

variable "vpc_id" {
  description = "VPC ID"
}