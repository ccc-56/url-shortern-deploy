output "alb_dns_name" {
  description = "Public DNS name of the ALB; point your CNAME here."
  value       = module.alb.alb_dns_name
}

output "ecr_repository_urls" {
  value = module.ecr.repository_urls
}

output "app_discovery_dns" {
  description = "DNS name nginx must proxy to (rebuild the nginx image to match)."
  value       = module.service_discovery.app_dns_name
}

output "cluster_name" {
  value = module.ecs.cluster_name
}

output "redis_endpoint" {
  value = local.data.redis_endpoint_address
}
