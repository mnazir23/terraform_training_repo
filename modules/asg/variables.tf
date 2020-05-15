variable "group_name" {
    default = "test-asg-group-mn"
    description = "Name of the Auto Scaling Group"
}

variable "availability_zone" {
    type        = string
    description = "Availability Zone of the ASG"
}

variable "desired_capacity" {
    type        = string
    default     = "1"
    description = "Total EC2 Instances to Create"
}

variable "max_size" {
    type        = string
    default     = "2"
    description = "Upper Limit on the Number of Instances"
}

variable "min_size" {
    type        = string
    default     = "1"
    description = "Lower Limit on the Number of Instances"
}

variable "launch_template" {
    description = "ID for the Launch Template"
}

variable "template_version" {
    type        = string
    default     = "$Latest"
    description = "Version of the Launch Template to be Used"
}

variable "target_group_arns" {
    default = []
    description = "For ALB|NLB, We Attach the ASG to the Target Groups' of the ALB|NLB"
}

variable "load_balancers" {
    default = []
    description = "For ELB, We Pass in a List of the ELBs for the ASG"
}

variable "lb_type" {
    default = "appnet"
    description = "This Variable will Help us Determine Parameters for the ASG"
}