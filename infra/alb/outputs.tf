output "alb" {
    value       = aws_lb.alb
    description = "AWS ALB"
}

output "target-group-id" {
    value = aws_lb_target_group.target-group.id
    description = "Target Group ID"
}