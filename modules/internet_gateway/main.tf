resource "aws_internet_gateway" "prod-igw" {
  vpc_id = var.vpc_id
}