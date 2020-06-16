output "lb_sg_id" {
    value       = aws_security_group.lb_sg.id
    description = "LB SG ID"
}

output "app_sg_id" {
    value       = aws_security_group.app_sg.id
    description = "App SG ID"
}

output "db_sg_id" {
    value       = aws_security_group.db_sg.id
    description = "DB SG ID"
}
