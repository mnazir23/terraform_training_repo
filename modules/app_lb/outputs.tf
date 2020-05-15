output "id" {
  value       = aws_lb.app_lb.id
}

output "target_group_id" {
  value       = aws_lb_target_group.app_target.id
}