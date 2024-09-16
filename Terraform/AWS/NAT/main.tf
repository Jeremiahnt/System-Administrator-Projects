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

locals {
  web_servers = {
    my-app-00 = {
      machine_type = "t2.micro"
      subnet_id    = aws_subnet.private_us_east_1a.id
    }
    my-app-01 = {
      machine_type = "t2.micro"
      subnet_id    = aws_subnet.private_us_east_1b.id
    }
  }
}


resource "aws_instance" "vm" {
  for_each      = local.web_servers

  ami           = data.aws_ami.vm-image.id
  instance_type = each.value.machine_type
  subnet_id     = each.value.subnet_id
  vpc_security_group_ids = [aws_security_group.sg-iac.id]

  user_data = file("apache.sh")

  tags = {
    Name = each.key 
  }
}