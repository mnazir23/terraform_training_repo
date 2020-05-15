# Private Route Table

resource "aws_route_table" "private_route" {
  vpc_id = var.vpc_id
  route {
    nat_gateway_id = var.nat_id
    cidr_block     = "0.0.0.0/0"
  }
  tags = {
    Name = "prod-private-route"
  }
}

# Associate Private Subnet with Private Route Table
resource "aws_route_table_association" "private_subnet_assoc" {
  count          = 1
  route_table_id = aws_route_table.private_route.id
  subnet_id      = var.private_subnets.*.id[count.index]
}
