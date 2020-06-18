# Simply specify the family to find the latest ACTIVE revision in that family.
data "aws_ecs_task_definition" "csuf-confessions" {
  task_definition = "${aws_ecs_task_definition.confession.family}"
}

resource "aws_ecs_task_definition" "csuf-confessions" {
  family = "csuf-confessions"

  container_definitions = <<DEFINITION
[
  {
    "cpu": 341,
    "environment": [
      {
      "name": "SECRET_KEY",
      "value": "SECRET_KEY"
      },
      {
      "name": "DEBUG_MODE",
      "value": "DEBUG_MODE"
      },
      {
      "name": "DEBUG_MODE",
      "value": "DEBUG_MODE"
      }

    ],
    "essential": true,
    "image": "csuf-confessions:latest",
    "memory": 623,
    "name": "csuf-confessions"
  }
]
DEFINITION
}

resource "aws_ecs_service" "csuf-confessions" {
  name          = "csuf-confessions"
  cluster       = "${aws_ecs_cluster.foo.id}"
  desired_count = 2

  # Track the latest ACTIVE revision
  task_definition = "${aws_ecs_task_definition.csuf-confessions.family}:${max("${aws_ecs_task_definition.csuf-confessions.revision}", "${data.aws_ecs_task_definition.csuf-confessions.revision}")}"
}