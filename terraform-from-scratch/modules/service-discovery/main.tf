resource "aws_service_discovery_private_dns_namespace" "this" {
  name = var.namespace_name
  vpc  = var.vpc_id

  tags = var.tags
}

resource "aws_service_discovery_service" "app" {
  name = var.service_name

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.this.id

    dns_records {
      type = "A"
      ttl  = var.dns_ttl
    }

    routing_policy = "MULTIVALUE"
  }

  health_check_custom_config {}

  tags = var.tags
}
