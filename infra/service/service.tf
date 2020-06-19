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



resource "aws_ecs_service" "csuf-confessions" {
  name          = "csuf-confessions"
  cluster       = data.terraform_remote_state.cluster.outputs.cluster
  desired_count = 2

  # Track the latest ACTIVE revision
  task_definition = data.terraform_remote_state.csuf-confessions-task.outputs.csuf-confessions-task-arn

  load_balancer {
    target_group_arn = "${aws_lb_target_group.foo.arn}"
    container_name   = "mongo"
    container_port   = 8080
  }

}
