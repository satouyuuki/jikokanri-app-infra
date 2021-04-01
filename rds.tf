# rds
resource "aws_security_group" "jikankanriRdsSg" {
  name        = "jikankanri_rds_security_group"
  description = "jikankanri_rds_security_group"
  vpc_id      = aws_vpc.jikankanriVpc.id
  ingress {
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    cidr_blocks = ["192.168.1.0/24"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# resource "aws_security_group_rule" "jikankanriRdsSgRule" {
#   type                     = "ingress"
#   from_port                = 3306
#   to_port                  = 3306
#   protocol                 = "tcp"
  # source_security_group_id = aws_security_group.jikankanriSg.id
#   cidr_blocks = ["192.168.1.0/24"]
#   security_group_id        = aws_security_group.jikankanriRdsSg.id
# }

resource "aws_db_subnet_group" "jikankanriRdsSubnetGroup" {
  name       = "jikankanri_subnet_group"
  subnet_ids = [
    aws_subnet.jikankanriDb1a.id,
    aws_subnet.jikankanriDb1c.id
  ]

  tags = {
    Name = "My jikankanriDB subnet group"
  }
}
resource "aws_db_instance" "jikankanriRds" {
  allocated_storage    = 20
  engine               = "mysql"
  engine_version       = "8.0.20"
  instance_class       = "db.t2.micro"
  name                 = "jikankanri_rds"
  username             = "root"
  password             = "password"
  vpc_security_group_ids = [ aws_security_group.jikankanriRdsSg.id ]
  availability_zone = "ap-northeast-1a"
  db_subnet_group_name = aws_db_subnet_group.jikankanriRdsSubnetGroup.name
  skip_final_snapshot  = true
}
