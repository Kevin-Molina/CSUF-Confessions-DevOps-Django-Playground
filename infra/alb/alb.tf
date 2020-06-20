terraform {
  backend "s3" {
    bucket = "confessions-terraform-state"
    key    = "lb.tfstate"
  }
}

data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "confessions-terraform-state"
    key = "vpc-us-east-1.tfstate"
  }
}

data "terraform_remote_state" "security_group" {
  backend = "s3"
  config = {
    bucket = "confessions-terraform-state"
    key = "security-groups.tfstate"
  }
}

resource "aws_lb" "alb" {
  name               = "confession-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [data.terraform_remote_state.security_group.outputs.lb_sg_id]
  subnets            = [data.terraform_remote_state.vpc.outputs.public_subnet_us_east_1a, 
                        data.terraform_remote_state.vpc.outputs.public_subnet_us_east_1b, 
                        data.terraform_remote_state.vpc.outputs.public_subnet_us_east_1c]
}

resource "aws_lb_listener" "http_redirect" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "back_end" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "arn:aws:acm:us-east-1:569741890825:certificate/9a05b634-84f4-4410-a8cd-a4cffa08253b"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target-group.arn
  }
}


resource "aws_lb_target_group" "target-group" {
  name        = "confession-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id
}
