output "id" {
  value       = var.lb_type == "appnet" ? aws_autoscaling_group.lb_asg.0.id : aws_autoscaling_group.elb_asg.0.id
}
