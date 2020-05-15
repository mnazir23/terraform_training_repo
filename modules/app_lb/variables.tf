variable "internal" {
    description = "Boolean determining if the load balancer is internal or externally facing."
    type        = bool
    default     = false
}

variable "lb_name" {
    type        = string
    description = "Load Balancer Name"
}

variable "type" {
    type        = string
    default     = "application"
    description = "Load Balancer Type"
    }

variable "subnets" {
    type        = list(string)
    default     = null
    description = "A list of subnets to associate with the load balancer. e.g. ['subnet-1a2b3c4d','subnet-1a2b3c4e','subnet-1a2b3c4f']"
}

variable "security_groups" {
  description = "The security groups to attach to the load balancer. e.g. [\"sg-edcd9784\",\"sg-edcd9785\"]"
  type        = list(string)
  default     = []
}

variable "tally" {
    default = 1
    description = "Count for the Number of Resources to be Created"
}

variable "port" {
  type        = string
  default     = "80"
  description = "Frontend Port for the Load Balancer"
}

variable "protocol" {
  type        = string
  default     = "HTTP"
  description = "Frontend Protocol for the Load Balancer"
}

variable "target_group_name" {
  type        = string
  default     = "asg-target-group"
  description = "The Name of the Target Group"
}

variable "target_port" {
  type        = string
  default     = "80"
  description = "Target Port for the EC2"
}

variable "target_protocol" {
  type        = string
  default     = "HTTP"
  description = "Target Protocol for the EC2"
}

variable "vpc_id" {
  description = "VPC ID for the Target Group"
}

variable "target_type" {
  type        = string
  default     = "instance"
  description = "Type of the Target Group"
}

variable "default_action" {
  type        = string
  default     = "forward"
  description = "Action for the Load Balancer to Perform (forward, redirect etc.)"
}
