# Serverless ElastiCache (Valkey/Redis). TLS is always enabled, which matches
# the app connecting via rediss://.
resource "aws_elasticache_serverless_cache" "this" {
  engine = var.engine
  name   = var.name

  subnet_ids         = var.subnet_ids
  security_group_ids = var.security_group_ids

  tags = merge(var.tags, { Name = var.name })
}
