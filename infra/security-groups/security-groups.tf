data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "confessions-terraform-state"
    key = "vpc-us-east-1.tfstate"
  }
}

terraform {
  backend "s3" {
    bucket = "confessions-terraform-state"
    key    = "security-groups.tfstate"
  }
}

resource "aws_security_group" "db_sg" {
  name        = "DB-SG"
  description = "Database Security Group"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  tags = {
    Name = "DB SG"
  }
}

resource "aws_security_group" "app_sg" {
  name        = "App-SG"
  description = "Application Security Group"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  tags = {
    Name = "App SG"
  }
}

resource "aws_security_group" "lb_sg" {
  name        = "LB-SG"
  description = "Load Balancer Security Group"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  tags = {
    Name = "LB SG"
  }
}


resource "aws_security_group_rule" "app_rule_ssh_access" {
  type                      = "ingress"
  description               = "Allow SSH access"
  from_port                 = 22
  to_port                   = 22
  protocol                  = "tcp"
  cidr_blocks               = ["0.0.0.0/0"]
  security_group_id         = aws_security_group.app_sg.id
}


resource "aws_security_group_rule" "db_rule_ingress_from_app" {
  type                     = "ingress"
  description              = "Inbound from app on 5432"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  security_group_id        = aws_security_group.db_sg.id
  source_security_group_id = aws_security_group.app_sg.id
}

resource "aws_security_group_rule" "app_rule_http_ingress_from_alb" {
  type                      = "ingress"
  description               = "Inbound from LB on 80"
  from_port                 = 80
  to_port                   = 80
  protocol                  = "tcp"
  security_group_id         = aws_security_group.app_sg.id
  source_security_group_id  = aws_security_group.lb_sg.id
}

resource "aws_security_group_rule" "app_rule_egress_to_db" {
  type                      = "egress"
  description               = "Outbound to DB on 5432"
  from_port                 = 5432
  to_port                   = 5432
  protocol                  = "tcp"
  security_group_id         = aws_security_group.app_sg.id
  source_security_group_id  = aws_security_group.db_sg.id
}


resource "aws_security_group_rule" "app_rule_http_egress" {
  type                      = "egress"
  description               = "Outbound to over HTTP"
  from_port                 = 80
  to_port                   = 80
  protocol                  = "tcp"
  cidr_blocks               = ["0.0.0.0/0"]
  security_group_id         = aws_security_group.app_sg.id
}

resource "aws_security_group_rule" "app_rule_https_egress" {
  type                      = "egress"
  description               = "Outbound over HTTPS"
  from_port                 = 443
  to_port                   = 443
  protocol                  = "tcp"
  cidr_blocks               = ["0.0.0.0/0"]
  security_group_id         = aws_security_group.app_sg.id
}

resource "aws_security_group_rule" "app_rule_dynamic_port_ingress_from_lb" {
  type                      = "ingress"
  description               = "Ingress from LB to App (dynamic ports)"
  from_port                 = 32768
  to_port                   = 65535
  protocol                  = "tcp"
  security_group_id         = aws_security_group.app_sg.id
  source_security_group_id  = aws_security_group.lb_sg.id
}



resource "aws_security_group_rule" "lb_rule_http_ingress" {
  type                      = "ingress"
  description               = "Allow http access"
  from_port                 = 80
  to_port                   = 80
  protocol                  = "tcp"
  cidr_blocks               = ["0.0.0.0/0"]
  security_group_id         = aws_security_group.lb_sg.id
}

resource "aws_security_group_rule" "lb_rule_https_ingress" {
  type                      = "ingress"
  description               = "Allow https access"
  from_port                 = 443
  to_port                   = 443
  protocol                  = "tcp"
  cidr_blocks               = ["0.0.0.0/0"]
  security_group_id         = aws_security_group.lb_sg.id
}


resource "aws_security_group_rule" "lb_rule_http_egress_to_app" {
  type                      = "egress"
  description               = "Outbound to App on 80"
  from_port                 = 80
  to_port                   = 80
  protocol                  = "tcp"
  security_group_id         = aws_security_group.lb_sg.id
  source_security_group_id  = aws_security_group.app_sg.id
}

resource "aws_security_group_rule" "lb_rule_dynamic_port_egress_to_app" {
  type                      = "egress"
  description               = "Egress from LB to App (dynamic ports)"
  from_port                 = 32768
  to_port                   = 65535
  protocol                  = "tcp"
  security_group_id         = aws_security_group.lb_sg.id
  source_security_group_id  = aws_security_group.app_sg.id
}
