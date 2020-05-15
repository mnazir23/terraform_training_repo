resource "aws_vpc" "prod-vpc" {
    tags = {
        Name = "prod-vpc"
    }
    cidr_block = var.cidr_block
}