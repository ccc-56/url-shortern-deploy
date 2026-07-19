# Unit tests for the internet-gateway module.
# These run with a mocked AWS provider and `command = plan`, so they need
# no AWS credentials and create no real infrastructure.

mock_provider "aws" {}

variables {
  vpc_id            = "vpc-0123456789abcdef0"
  vpc_name          = "test-vpc"
  public_subnet_ids = ["subnet-aaa", "subnet-bbb"]
}

run "gateway_and_route_table_attach_to_vpc" {
  command = plan

  assert {
    condition     = aws_internet_gateway.this.vpc_id == "vpc-0123456789abcdef0"
    error_message = "Internet gateway should attach to the provided vpc_id"
  }

  assert {
    condition     = aws_internet_gateway.this.tags["Name"] == "test-vpc-igw"
    error_message = "Internet gateway Name tag should be <vpc_name>-igw"
  }

  assert {
    condition     = aws_route_table.public.vpc_id == "vpc-0123456789abcdef0"
    error_message = "Public route table should attach to the provided vpc_id"
  }
}

run "default_route_points_to_internet_gateway" {
  command = plan

  assert {
    condition     = one([for r in aws_route_table.public.route : r.cidr_block]) == "0.0.0.0/0"
    error_message = "Public route table must contain a default 0.0.0.0/0 route"
  }
}

run "one_association_per_public_subnet" {
  command = plan

  assert {
    condition     = length(aws_route_table_association.public) == length(var.public_subnet_ids)
    error_message = "One route table association should be created per public subnet id"
  }

  assert {
    condition     = aws_route_table_association.public[0].subnet_id == "subnet-aaa"
    error_message = "Association should reference the provided subnet ids in order"
  }
}

run "no_associations_when_no_public_subnets" {
  command = plan

  variables {
    public_subnet_ids = []
  }

  assert {
    condition     = length(aws_route_table_association.public) == 0
    error_message = "No associations should be created when public_subnet_ids is empty"
  }
}
