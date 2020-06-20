variable "REPOSITORY_URI" {}
variable "IMAGE_VERSION" {}

resource "aws_ecs_task_definition" "csuf-confessions" {
  family = "csuf-confessions"
  container_definitions = file("${path.module}/task.json")

  network_mode = "bridge"
}
