resource "aws_route" "aws-route-iac" {
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw-iac.id
  route_table_id         = aws_route_table.route-table-iac.id
}

resource "aws_security_group" "sg-iac" {
  name        = "iac"
  description = "security group for vm deployment"
  vpc_id      = aws_vpc.vpc-iac.id

  ingress = [
    {
       description      = "security lol"
       from_port        = 0
       to_port          = 0
       protocol         = "-1"
       cidr_blocks      = ["0.0.0.0/0", aws_vpc.vpc-iac.cidr_block]
       ipv6_cidr_blocks = []
       prefix_list_ids  = []
       security_groups  = []
       self             = false
    }
  ]

  egress = [
    {
       description      = "security lol"
       from_port        = 0
       to_port          = 0
       protocol         = "-1"
       cidr_blocks      = ["0.0.0.0/0", aws_vpc.vpc-iac.cidr_block]
       ipv6_cidr_blocks = []
       prefix_list_ids  = []
       security_groups  = []
       self             = false
    }
  ]
}

resource "aws_network_interface" "nic-iac" {
  subnet_id       = aws_subnet.subnet-iac-1.id
  private_ip      = "10.0.1.20"
  security_groups = [aws_security_group.sg-iac.id]
}

data "aws_ami" "vm-image" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "vm" {
  ami           = data.aws_ami.vm-image.id
  instance_type = "t2.micro"

  network_interface {
    network_interface_id = aws_network_interface.nic-iac.id
    device_index         = 0
  }

  user_data = file("apache.sh")
}