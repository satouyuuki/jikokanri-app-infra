# Create a new load balancer
# resource "aws_security_group" "jikankanriElbSg" {
#   name        = "jikankanri_security_group_elb"
#   description = "jikankanri_security_group_elb"
#   vpc_id      = aws_vpc.jikankanriVpc.id
#   ingress {
#     from_port = 80
#     to_port = 80
#     protocol = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#   ingress {
#     from_port = 443
#     to_port = 443
#     protocol = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }

# # resource "aws_elb" "myAlb" {
# #   name               = "jikokanriAlb"
# #   security_groups = [ aws_security_group.jikankanriElbSg.id ]
# #   subnets = [ 
# #     aws_subnet.jikankanriApp1a.id, 
# #     aws_subnet.jikankanriApp1c.id
# #   ]
# #   tags = {
# #     Name = "jikokanri-terraform-elb"
# #   }

# #   listener {
# #     instance_port      = 80
# #     instance_protocol  = "http"
# #     lb_port            = 443
# #     lb_protocol        = "https"
# #     ssl_certificate_id = aws_acm_certificate_validation.elbAcmValid.certificate_arn
# #   }

# #   instances = [aws_instance.jikankanriEc2.id]
# # }

# # elbじゃなくalbじゃなくlbらしい
# resource "aws_lb" "myAlb" {
#   name               = "jikokanriAlb"
#   load_balancer_type = "application"
#   # availability_zones = ["ap-northeast-1a", "ap-northeast-1c"]
#   security_groups = [ aws_security_group.jikankanriElbSg.id ]
#   subnets = [ 
#     aws_subnet.jikankanriApp1a.id, 
#     aws_subnet.jikankanriApp1c.id
#   ]
#   tags = {
#     Name = "jikokanri-terraform-elb"
#   }
#   access_logs {
#     bucket  = aws_s3_bucket.jikokanriLogs.id
#     prefix  = "elb"
#     enabled = true
#   }
# }

# resource "aws_lb_listener" "myAlbListener" {
#   load_balancer_arn = aws_lb.myAlb.arn
#   port              = "80"
#   protocol          = "HTTP"
#   # ssl_policy        = "ELBSecurityPolicy-2016-08"
#   # certificate_arn   = aws_acm_certificate_validation.elbAcmValid.certificate_arn
#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.myAlbTg.arn
#   }
# }

# resource "aws_lb_target_group" "myAlbTg" {
#   name     = "tf-jikokanri-alb-tg"
#   port     = 80
#   protocol = "HTTP"
#   vpc_id   = aws_vpc.jikankanriVpc.id
# }

# resource "aws_lb_target_group_attachment" "myAlbTgAttach" {
#   target_group_arn = aws_lb_target_group.myAlbTg.arn
#   target_id        = aws_instance.jikankanriEc2.id
#   port             = 80
# }
