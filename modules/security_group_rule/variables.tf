variable "cidr_value" {
  default = "0.0.0.0/0"
  description = "IP Address Range for the Security Group Rule"
}

variable "secgroup_id" {
  description = "ID for the security group to which this rule will be attached"
}

variable "from_port" {
  default = 0
  description = "Port range start"
}

variable "to_port" {
  default = 0
  description = "Port range end"
}

variable "protocol" {
  default = "-1"
  description = "Protocol to be used for communication"
}

variable "rule_type" {
  description = "Inbound or outbound rule"
}

