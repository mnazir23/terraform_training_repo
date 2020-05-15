resource "aws_lb" "app_lb" {
    name               = var.lb_name
    load_balancer_type = var.type
    internal           = var.internal
    security_groups    = var.security_groups
    subnets            = var.subnets

}

resource "aws_lb_target_group" "app_target" {
  name     = var.target_group_name
  target_type = var.target_type
  port     = var.target_port
  protocol = var.target_protocol
  vpc_id   = var.vpc_id
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = var.port
  protocol          = var.protocol
  default_action {
    type             = var.default_action
    target_group_arn = aws_lb_target_group.app_target.arn
  }
}