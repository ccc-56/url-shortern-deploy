output "vpc_id" {
  value = module.vpc.vpc_id
}

output "alb_dns_name" {
  description = "Public DNS name of the ALB; point your CNAME here."
  value       = module.alb.alb_dns_name
}

output "ecr_repository_urls" {
  value = module.ecr.repository_urls
}

output "redis_endpoint" {
  value = module.elasticache.endpoint_address
}

output "app_discovery_dns" {
  description = "DNS name nginx must proxy to (rebuild the nginx image to match)."
  value       = module.service_discovery.app_dns_name
}

output "cluster_name" {
  value = module.ecs.cluster_name
}
