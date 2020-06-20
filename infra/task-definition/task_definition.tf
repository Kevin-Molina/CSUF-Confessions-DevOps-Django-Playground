variable "REPOSITORY_URI" {}
variable "IMAGE_VERSION" {}

resource "aws_ecs_task_definition" "csuf-confessions" {
  family = "csuf-confessions"
  container_definitions = templatefile("${path.module}/task.tmpl", {IMAGE_VERSION=var.IMAGE_VERSION, REPOSITORY_URI=var.REPOSITORY_URI})
  network_mode = "bridge"
}
