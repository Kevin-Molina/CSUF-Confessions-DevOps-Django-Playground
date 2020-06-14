output "vpc_id" {
    value       = aws_vpc.vpc_us_east_1.id
    description = "VPC ID"
}

output "private_subnet_us_east_1a" {
    value       = aws_subnet.private_subnet_us_east_1a.id
    description = "Subnet ID"
}

output "private_subnet_us_east_1b" {
    value       = aws_subnet.private_subnet_us_east_1b.id
    description = "Subnet ID"
}

output "private_subnet_us_east_1c" {
    value       = aws_subnet.private_subnet_us_east_1c.id
    description = "Subnet ID"
}

output "public_subnet_us_east_1a" {
    value       = aws_subnet.public_subnet_us_east_1a.id
    description = "Subnet ID"
}

output "public_subnet_us_east_1b" {
    value       = aws_subnet.public_subnet_us_east_1b.id
    description = "Subnet ID"
}

output "public_subnet_us_east_1c" {
    value       = aws_subnet.public_subnet_us_east_1c.id
    description = "Subnet ID"
}