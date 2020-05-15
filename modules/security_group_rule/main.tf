# Ingress Security Port 22
resource "aws_security_group_rule" "ssh_inbound_access" {
  from_port         = var.from_port
  protocol          = var.protocol
  security_group_id = var.secgroup_id
  to_port           = var.to_port
  type              = var.rule_type
  cidr_blocks       = [var.cidr_value]
}
