output "vpc-id" {
    description = "ID of deployment's VPC"
    value = aws_vpc.vpc-iac.id
}

output "security-group" {
    description = "security group id"
    value = aws_s3_bucket.s3-iac.arn
}

output "subnet_ids" {
  description = "The IDs of the subnets created"
  value       = [aws_subnet.subnet-iac-1.id, aws_subnet.subnet-iac-2.id]
}