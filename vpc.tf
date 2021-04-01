resource "aws_vpc" "jikankanriVpc" {
  cidr_block = "192.168.0.0/16"
  instance_tenancy = "default"
  enable_dns_hostnames = true
  tags = {
    Name = "jikankanri-vpc"
  }
}

resource "aws_internet_gateway" "jikankanriIg" {
  vpc_id = aws_vpc.jikankanriVpc.id
  depends_on = [aws_vpc.jikankanriVpc]
}

resource "aws_subnet" "jikankanriApp1a" {
  vpc_id     = aws_vpc.jikankanriVpc.id
  cidr_block = "192.168.1.0/24"
  availability_zone = "ap-northeast-1a"
}

resource "aws_subnet" "jikankanriDb1a" {
  vpc_id     = aws_vpc.jikankanriVpc.id
  cidr_block = "192.168.2.0/24"
  availability_zone = "ap-northeast-1a"
}

resource "aws_subnet" "jikankanriApp1c" {
  vpc_id     = aws_vpc.jikankanriVpc.id
  cidr_block = "192.168.3.0/24"
  availability_zone = "ap-northeast-1c"
}

resource "aws_subnet" "jikankanriDb1c" {
  vpc_id     = aws_vpc.jikankanriVpc.id
  cidr_block = "192.168.4.0/24"
  availability_zone = "ap-northeast-1c"
}

resource "aws_route_table" "jikankanriTable" {
  vpc_id = aws_vpc.jikankanriVpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.jikankanriIg.id
  }
}
resource "aws_route_table_association" "jikankanriTableAsso" {
  subnet_id      = aws_subnet.jikankanriApp1a.id
  route_table_id = aws_route_table.jikankanriTable.id
}
resource "aws_security_group" "jikankanriSg" {
  name        = "jikankanri_security_group"
  description = "jikankanri_security_group"
  vpc_id      = aws_vpc.jikankanriVpc.id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["147.192.123.0/24", "133.106.130.0/24", "14.15.19.0/24"]
  }

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    # security_groups = [aws_security_group.jikankanriElbSg.id]
  }

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    # security_groups = [aws_security_group.jikankanriElbSg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}