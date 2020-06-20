data "terraform_remote_state" "alb" {
  backend = "s3"
  config = {
    bucket = "confessions-terraform-state"
    key = "lb.tfstate"
  }
}


resource "aws_route53_zone" "primary" {
  name = "csufconfessions.com"
}

resource "aws_route53_record" "csufconfessions" {
  allow_overwrite = true
  zone_id = aws_route53_zone.primary.zone_id
  name    = "csufconfessions.com"
  type    = "A"

  alias {
      name                   = data.terraform_remote_state.alb.outputs.alb.dns_name
      zone_id                = data.terraform_remote_state.alb.outputs.alb.zone_id
      evaluate_target_health = false
  }
}

resource "aws_route53_record" "www_csufconfessions" {
  allow_overwrite = true
  zone_id = aws_route53_zone.primary.zone_id
  name    = "www.csufconfessions.com"
  type    = "A"

  alias {
      name                   = data.terraform_remote_state.alb.outputs.alb.dns_name
      zone_id                = data.terraform_remote_state.alb.outputs.alb.zone_id
      evaluate_target_health = false
  }
}