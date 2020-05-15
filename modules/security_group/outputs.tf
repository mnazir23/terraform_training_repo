output "secgroup_id" {
  value       = aws_security_group.prod-sg.id
}

output "vpc_id" {
  value       = aws_security_group.prod-sg.vpc_id
}