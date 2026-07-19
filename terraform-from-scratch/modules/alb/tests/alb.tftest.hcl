mock_provider "aws" {}

variables {
  name               = "short-dev-alb"
  vpc_id             = "vpc-0123456789abcdef0"
  public_subnet_ids  = ["subnet-1", "subnet-2"]
  security_group_ids = ["sg-alb"]
  tags               = { Environment = "test" }
}

run "internet_facing_alb_with_ip_target_group" {
  command = plan

  assert {
    condition     = aws_lb.this.internal == false
    error_message = "ALB should be internet-facing"
  }

  assert {
    condition     = aws_lb_target_group.nginx.target_type == "ip"
    error_message = "Fargate target group must use target_type ip"
  }

  assert {
    condition     = aws_lb_target_group.nginx.vpc_id == "vpc-0123456789abcdef0"
    error_message = "Target group should attach to the VPC"
  }
}

run "http_only_when_no_certificate" {
  command = plan

  assert {
    condition     = aws_lb_listener.http.port == 80
    error_message = "An HTTP listener on port 80 should exist"
  }

  assert {
    condition     = length(aws_lb_listener.https) == 0
    error_message = "No HTTPS listener should exist without a certificate"
  }
}

run "https_listener_when_certificate_provided" {
  command = plan

  variables {
    certificate_arn = "arn:aws:acm:ap-south-1:123456789012:certificate/abc"
  }

  assert {
    condition     = length(aws_lb_listener.https) == 1
    error_message = "An HTTPS listener should be created when a certificate is provided"
  }
}
