output "csuf-confessions-task-arn" {
    value       = aws_ecs_task_definition.csuf-confessions.arn
    description = "Task Definition arn"
}
