/*resource "aws_s3_bucket" "alb-bucket" {
  region = var.aws_region
  bucket = "alb-bucket"
  acl = "private"

  tags = {
    Name = "capstonealbbucket"
  }
}*/

resource "aws_lb" "capstoneLB" {
  name               = "capstoneLB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.web_sg.id]
  subnets            = [aws_subnet.public_sub1.id, aws_subnet.public_sub2.id]

  enable_deletion_protection = false

  access_logs {
    bucket  = "aws_s3_bucket.alb-bucket.bucket"
    #prefix  = "capstoneLB"
    enabled = false
  }

  tags = {
    Name = "capstoneLB"
  }
}

resource "aws_lb_target_group" "capstoneTG" {
  name     = "capstoneTG"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  tags = {
  Name = "capstoneTG"
  }
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.capstoneLB.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.capstoneTG.arn
  }
}
