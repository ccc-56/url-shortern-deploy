mock_provider "aws" {}

variables {
  vpc_id         = "vpc-0123456789abcdef0"
  namespace_name = "shortname.internal"
  service_name   = "shortname-app"
}

run "namespace_and_service_configured" {
  command = plan

  assert {
    condition     = aws_service_discovery_private_dns_namespace.this.name == "shortname.internal"
    error_message = "Private DNS namespace should use the provided name"
  }

  assert {
    condition     = aws_service_discovery_private_dns_namespace.this.vpc == "vpc-0123456789abcdef0"
    error_message = "Namespace should be tied to the VPC"
  }

  assert {
    condition     = aws_service_discovery_service.app.name == "shortname-app"
    error_message = "Service name should match input"
  }

  assert {
    condition     = one(aws_service_discovery_service.app.dns_config[0].dns_records[*].type) == "A"
    error_message = "Service should expose an A record"
  }
}

run "app_dns_name_output_is_fqdn" {
  command = plan

  assert {
    condition     = output.app_dns_name == "shortname-app.shortname.internal"
    error_message = "app_dns_name should join service and namespace"
  }
}
