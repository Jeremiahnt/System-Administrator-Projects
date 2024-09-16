output "vpc-id" {
    description = "ID of deployment's VPC"
    value = aws_vpc.vpc-iac.id
}

output "subnet_ids" {
  description = "The IDs of the subnets created"
  value       = [aws_subnet.public_us_east_1a.id, aws_subnet.public_us_east_1b.id]
}