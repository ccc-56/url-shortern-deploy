mock_provider "aws" {}

variables {
  vpc_id             = "vpc-0123456789abcdef0"
  vpc_name           = "test-vpc"
  public_subnet_id   = "subnet-public-1"
  private_subnet_ids = ["subnet-private-1", "subnet-private-2"]
  tags               = { Environment = "test" }
}

run "nat_gateway_sits_in_public_subnet" {
  command = plan

  assert {
    condition     = aws_nat_gateway.this.subnet_id == "subnet-public-1"
    error_message = "NAT gateway should be placed in the provided public subnet"
  }

  assert {
    condition     = aws_eip.nat.domain == "vpc"
    error_message = "NAT EIP should be a VPC EIP"
  }
}

run "private_route_table_routes_through_nat" {
  command = plan

  assert {
    condition     = aws_route_table.private.vpc_id == "vpc-0123456789abcdef0"
    error_message = "Private route table should attach to the provided VPC"
  }

  assert {
    condition     = one([for r in aws_route_table.private.route : r.cidr_block]) == "0.0.0.0/0"
    error_message = "Private route table must have a default route"
  }

  assert {
    condition     = length(aws_route_table_association.private) == length(var.private_subnet_ids)
    error_message = "One association per private subnet is expected"
  }
}

run "no_associations_without_private_subnets" {
  command = plan

  variables {
    private_subnet_ids = []
  }

  assert {
    condition     = length(aws_route_table_association.private) == 0
    error_message = "No associations should be created without private subnets"
  }
}
