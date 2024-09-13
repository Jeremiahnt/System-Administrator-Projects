resource "aws_route_table" "route-table-iac-public" {
  vpc_id = aws_vpc.vpc-iac.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw-iac.id
  }
}

resource "aws_route_table" "route-table-iac-private" {
  vpc_id = aws_vpc.vpc-iac.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
}

resource "aws_route_table_association" "A-public" {
  subnet_id      = aws_subnet.public_us_east_1a.id
  route_table_id = aws_route_table.route-table-iac-public.id
}

resource "aws_route_table_association" "B-public" {
  subnet_id      = aws_subnet.public_us_east_1b.id
  route_table_id = aws_route_table.route-table-iac-public.id
}

resource "aws_route_table_association" "A-private" {
  subnet_id      = aws_subnet.private_us_east_1a.id
  route_table_id = aws_route_table.route-table-iac-private.id
}

resource "aws_route_table_association" "B-private" {
  subnet_id      = aws_subnet.private_us_east_1b.id
  route_table_id = aws_route_table.route-table-iac-private.id
}