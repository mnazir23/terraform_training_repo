# Public Route Table

resource "aws_route_table" "public_route" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.igw_id
  }
  tags = {
    Name = "prod-public-route"
  }
}

# Associate Public Subnet with Public Route Table
resource "aws_route_table_association" "public_subnet_assoc" {
  count          = 1
  route_table_id = aws_route_table.public_route.id
  subnet_id      = var.public_subnets.*.id[count.index]
}
