output "namespace_id" {
  value = aws_service_discovery_private_dns_namespace.this.id
}

output "service_arn" {
  value = aws_service_discovery_service.app.arn
}

output "app_dns_name" {
  description = "Fully qualified DNS name the nginx upstream should target."
  value       = "${var.service_name}.${var.namespace_name}"
}
