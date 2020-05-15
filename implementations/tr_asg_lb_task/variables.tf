variable "aws_region" {
  type        = string
  default     = "us-east-1"
  description = "AWS Region for Deployment"
}

### Security Group Variables
variable "secgroup_name" {
  default = "mn-test-sg"
  description = "Name of the security group"
}

variable "cidr_value" {
  default = "0.0.0.0/0"
  description = "CIDR Block for the security group"
}

# Subnet Variables
variable "cidr_block_one" {
  type    = list(string)
  default     = ["172.31.1.1/24"]
  description = "CIDR Block for the Subnet"
}

variable "cidr_block_two" {
  type    = list(string)
  default     = ["172.31.1.2/24"]
  description = "CIDR Block for the Subnet"
}


### EC2 Variables
variable "vm_name" {
  type        = string
  default     = "test_asg_vm"
  description = "Name of the EC2 VM"
}

variable "key_pair_name" {
  default = "maham-terraform"
  description = "Public Key for SSHing into the Machine"
}

### Load Balancer Variables
variable "subnet_one" {
  default = ""
  description = "Subnet ID for the Load Balancer"
}

variable "subnet_two" {
  default = ""
  description = "Subnet ID for the Load Balancer"
}

variable "availability_zone" {
  default = "us-east-1a"
  description = "AZ for EC2 Intance"
}