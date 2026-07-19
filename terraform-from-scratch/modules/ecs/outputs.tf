output "cluster_arn" {
  value = aws_ecs_cluster.this.arn
}

output "cluster_name" {
  value = aws_ecs_cluster.this.name
}

output "app_service_name" {
  value = aws_ecs_service.app.name
}

output "nginx_service_name" {
  value = aws_ecs_service.nginx.name
}

output "execution_role_arn" {
  value = aws_iam_role.execution.arn
}
