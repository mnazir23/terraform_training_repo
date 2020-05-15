output "public_ip" {
  value       = aws_instance.prod-web.public_ip
}

output "private_ip" {
  value       = aws_instance.prod-web.private_ip
}

output "primary_network_interface_id" {
  value = aws_instance.prod-web.primary_network_interface_id
}

output "id" {
  value = aws_instance.prod-web.id
}