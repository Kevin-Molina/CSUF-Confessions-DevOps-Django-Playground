terraform {
  backend "s3" {
    bucket = "confessions-terraform-state"
    key    = "r53.tfstate"
  }
}