resource "aws_eip" "prod-eip" {
  vpc = true
}

resource "aws_nat_gateway" "gw" {
  allocation_id = aws_eip.prod-eip.id
  subnet_id     = var.subnet_id
  tags = {
    Name = "prod-nat-gw"
  }
}