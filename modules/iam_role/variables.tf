variable "role_name" {
  type        = string 
  description = "Name of the Role"
}

variable "policy_name" {
  type        = string 
  description = "Name of the Polciy"
}

variable "role_json" {
  description = "JSON containing all the information about the Role to create"
}

variable "policy_arn" {
  description = "ARN for an existing policy on AWS"
}
