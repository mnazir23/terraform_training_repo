# Security Group For Public EC2 Instance
resource "aws_security_group" "prod-sg" {
  tags = {
    name   = var.sg_name
  }
  vpc_id = var.vpc_id
}
