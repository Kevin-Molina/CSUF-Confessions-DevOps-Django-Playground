terraform {
  backend "s3" {
    bucket = "confessions-terraform-state"
    key    = "cluster.tfstate"
  }
}

resource "aws_ecs_cluster" "cluster" {
  name = "CONFESSION_CLUSTER"
}