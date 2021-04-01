resource "aws_key_pair" "cliUserEc2" {
  key_name   = "cli-user-ec2"
  public_key = file("~/.ssh/cli-user-ec2.pub")
}
# ec2
resource "aws_instance" "jikankanriEc2" {
  ami           = "ami-0f27d081df46f326c"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.cliUserEc2.id
  subnet_id     = aws_subnet.jikankanriApp1a.id
  vpc_security_group_ids = [aws_security_group.jikankanriSg.id]
}

resource "aws_eip" "jikankanriEip" {
  instance = aws_instance.jikankanriEc2.id
  vpc      = true
}