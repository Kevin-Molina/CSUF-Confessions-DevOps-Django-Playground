# Simply specify the family to find the latest ACTIVE revision in that family.
data "terraform_remote_state" "csuf-confessions-task" {
  backend = "s3"
  config = {
    bucket = "confessions-terraform-state"
    key    = "task-definition.tfstate"
  }
}

data "terraform_remote_state" "cluster" {
    backend = "s3" 
    config = {
    bucket = "confessions-terraform-state"
    key    = "cluster.tfstate"
  }
}

data "terraform_remote_state" "target-group" {
    backend = "s3" 
    config = {
    bucket = "confessions-terraform-state"
    key    = "lb.tfstate"
  }
}


resource "aws_ecs_service" "csuf-confessions" {
  name          = "csuf-confessions"
  cluster       = data.terraform_remote_state.cluster.outputs.cluster
  desired_count = 1

  iam_role      = "arn:aws:iam::569741890825:role/aws-service-role/ecs.amazonaws.com/AWSServiceRoleForECS"

  # Track the latest ACTIVE revision
  task_definition = data.terraform_remote_state.csuf-confessions-task.outputs.csuf-confessions-task-arn

  load_balancer {
    target_group_arn = data.terraform_remote_state.target-group.outputs.target-group-arn
    container_name   = "csuf-confessions"
    container_port   = 80
  }

}
