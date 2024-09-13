resource "aws_internet_gateway" "igw-iac" {
  vpc_id = aws_vpc.vpc-iac.id
}