variable "vpc_id" {
  description = "ID for the VPC to which this subnet belongs"
}

variable "cidr_block" {
  type    = list(string)
  default = []

}

variable "availability_zone" {
  type        = string
  description = "Availability zone for the subnet"
}

variable "map_public_ip_on_launch" {
  description = "This attribute determines if the subnet should be public or private"
}

variable "total_subnets" {
  description = "Determines how many subnets to create"
}

variable "subnet_name" {
  description = "Name for the Subnet"
}