resource "aws_subnet" "subnet" {
  count                   = var.total_subnets
  vpc_id                  = var.vpc_id
  cidr_block              = var.cidr_block[count.index]
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = var.map_public_ip_on_launch
  tags = {
    Name = "${var.subnet_name}-${count.index}"
  }
}