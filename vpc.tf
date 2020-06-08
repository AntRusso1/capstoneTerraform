provider "aws" {
	region = var.aws_region
	shared_credentials_file = var.account_cred
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "capstoneVPC"
  }
}

resource "aws_subnet" "public_sub1" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name = "capstonePubicSubnet1"
  }
}

resource "aws_subnet" "public_sub2" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name = "capstonePubicSubnet2"
  }
}

resource "aws_subnet" "private_sub" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.3.0/24"
  tags = {
    Name = "capstonePrivateSubnet"
  }
}

resource "aws_eip" "private_eip" {
  vpc = true
}

resource "aws_internet_gateway" "public_gw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "capstonePublicGW"
  }
}

resource "aws_nat_gateway" "private_gw" {
  allocation_id = aws_eip.private_eip.id
  subnet_id     = aws_subnet.public_sub2.id
  tags = {
    Name = "capstonePrivateGW"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.public_gw.id
  }
  tags = {
    Name = "capstonePublicRT"
  }
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.private_gw.id
  }
  tags = {
    Name = "capstonePrivateRT"
  }
}

resource "aws_route_table_association" "private_rt_assoc" {
  subnet_id      = aws_subnet.private_sub.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "public_rt_assoc1" {
  subnet_id      = aws_subnet.public_sub1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_rt_assoc2" {
  subnet_id      = aws_subnet.public_sub2.id
  route_table_id = aws_route_table.public_rt.id
}
