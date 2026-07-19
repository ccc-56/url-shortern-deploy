output "alb_sg_id" {
  value = aws_security_group.alb.id
}

output "nginx_sg_id" {
  value = aws_security_group.nginx.id
}

output "app_sg_id" {
  value = aws_security_group.app.id
}

output "redis_sg_id" {
  value = aws_security_group.redis.id
}
