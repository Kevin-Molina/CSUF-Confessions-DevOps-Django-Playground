terraform {
  backend "s3" {
    bucket = "confessions-terraform-state"
    key    = "cluster.tfstate"
  }
}
