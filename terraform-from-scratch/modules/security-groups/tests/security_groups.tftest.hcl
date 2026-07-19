mock_provider "aws" {}

variables {
  vpc_id      = "vpc-0123456789abcdef0"
  name_prefix = "short-dev"
  tags        = { Environment = "test" }
}

run "all_groups_attach_to_vpc" {
  command = plan

  assert {
    condition     = aws_security_group.alb.vpc_id == "vpc-0123456789abcdef0"
    error_message = "ALB SG should attach to the VPC"
  }

  assert {
    condition = alltrue([
      aws_security_group.alb.name == "short-dev-alb-sg",
      aws_security_group.nginx.name == "short-dev-nginx-sg",
      aws_security_group.app.name == "short-dev-app-sg",
      aws_security_group.redis.name == "short-dev-redis-sg",
    ])
    error_message = "Security group names should use the name_prefix"
  }
}

run "alb_allows_public_http_https" {
  command = plan

  assert {
    condition     = length([for r in aws_security_group.alb.ingress : r if contains(r.cidr_blocks, "0.0.0.0/0") && r.from_port == 80]) == 1
    error_message = "ALB SG should allow public HTTP"
  }

  assert {
    condition     = length([for r in aws_security_group.alb.ingress : r if contains(r.cidr_blocks, "0.0.0.0/0") && r.from_port == 443]) == 1
    error_message = "ALB SG should allow public HTTPS"
  }
}

run "internal_ports_use_expected_defaults" {
  command = plan

  assert {
    condition     = one([for r in aws_security_group.app.ingress : r.from_port]) == 3000
    error_message = "App SG should default to port 3000"
  }

  assert {
    condition     = one([for r in aws_security_group.redis.ingress : r.from_port]) == 6379
    error_message = "Redis SG should default to port 6379"
  }
}
