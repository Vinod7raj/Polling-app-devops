output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnets" {
  value = aws_subnet.prod_public[*].id
}

output "private_subnets" {
  value = aws_subnet.prod_priv[*].id
}
