output "vpc_id" {
    value = aws_vpc.prod-vpc.id
}

output "default_route_table_id" {
    value = aws_vpc.prod-vpc.default_route_table_id
}