output "vpc_id" {
    value       = aws_vpc.vpc_us_east_1.id
    description = "VPC ID"
}