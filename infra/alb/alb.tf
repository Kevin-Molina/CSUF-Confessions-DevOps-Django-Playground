data "terraform_remote_state" "subnet_group" {
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
  security_groups    = [data.terraform_remote_state.security_group.outputs.alb_sg_id]
  subnets            = [data.terraform_remote_state.subnet_group.outputs.public_subnet_us_east_1a, 
                        data.terraform_remote_state.subnet_group.outputs.public_subnet_us_east_1b, 
                        data.terraform_remote_state.subnet_group.outputs.public_subnet_us_east_1c]
}