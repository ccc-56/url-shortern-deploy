output "nat_gateway_id" {
  value = aws_nat_gateway.this.id
}

output "nat_eip" {
  value = aws_eip.nat.public_ip
}

output "private_route_table_id" {
  value = aws_route_table.private.id
}
