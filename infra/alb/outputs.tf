output "alb" {
    value       = aws_lb.alb
    description = "AWS ALB"
}

output "target-group-arn" {
    value = aws_lb_target_group.target-group.arn
    description = "Target Group ID"
}