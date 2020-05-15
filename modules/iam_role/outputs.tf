output "role_name" {
  value       = aws_iam_role.service_role.name
}

output "id" {
  value       = aws_iam_role.service_role.unique_id
}

output "arn" {
  value       = aws_iam_role.service_role.arn
}