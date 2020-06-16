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

resource "aws_security_group_rule" "db_ingress" {
  type                     = "ingress"
  description              = "Inbound from app on 5432"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  security_group_id        = aws_security_group.db_sg.id
  source_security_group_id = aws_security_group.app_sg.id
}

resource "aws_security_group_rule" "lb_ingress" {
  type                      = "ingress"
  description               = "Inbound from LB on 80"
  from_port                 = 80
  to_port                   = 80
  protocol                  = "tcp"
  security_group_id         = aws_security_group.lb_sg.id
  source_security_group_id  = aws_security_group.lb_sg.id
}

resource "aws_security_group_rule" "app_egress" {
  type                      = "egress"
  description               = "Output to DB on 5432"
  from_port                 = 5432
  to_port                   = 5432
  protocol                  = "tcp"
  security_group_id         = aws_security_group.app_sg.id
  source_security_group_id  = aws_security_group.db_sg.id
}

resource "aws_security_group_rule" "lb_egress" {
  type                      = "egress"
  description               = "Output to App on 80"
  from_port                 = 80
  to_port                   = 80
  protocol                  = "tcp"
  security_group_id         = aws_security_group.lb_sg.id
  source_security_group_id  = aws_security_group.app_sg.id
}

resource "aws_security_group_rule" "ssh_access" {
  type                      = "ingress"
  description               = "Allow SSH access"
  from_port                 = 22
  to_port                   = 22
  protocol                  = "tcp"
  cidr_blocks               = ["0.0.0.0/0"]
  security_group_id         = aws_security_group.app_sg.id
}


resource "aws_security_group_rule" "outbound_http_access" {
  type                      = "egress"
  description               = "Allow port http outbound"
  from_port                 = 80
  to_port                   = 80
  protocol                  = "tcp"
  cidr_blocks               = ["0.0.0.0/0"]
  security_group_id         = aws_security_group.app_sg.id
}

resource "aws_security_group_rule" "outbound_https_access" {
  type                      = "egress"
  description               = "Allow port https outbound"
  from_port                 = 443
  to_port                   = 443
  protocol                  = "tcp"
  cidr_blocks               = ["0.0.0.0/0"]
  security_group_id         = aws_security_group.app_sg.id
}