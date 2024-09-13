resource "aws_eip" "eip-iac" {
  instance = aws_instance.vm.id
  domain   = "vpc"
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.eip-iac.id
  subnet_id     = aws_subnet.public_us_east_1a.id

  tags = {
    Name = "gw NAT"
  }

  depends_on = [aws_internet_gateway.igw-iac]
}