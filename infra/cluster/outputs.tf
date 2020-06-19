output "cluster" {
    value       = aws_ecs_cluster.cluster.id
    description = "Cluster ID"
}