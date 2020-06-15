output "ecs_instance_profile" {
    value       = aws_iam_instance_profile.ecs_instance_profile.name
    description = "ECS Instance Profile Name"
}
