# Unit tests for the network module.
# These run with a mocked AWS provider and `command = plan`, so they need
# no AWS credentials and create no real infrastructure.

mock_provider "aws" {}

variables {
  vpc_name             = "test-vpc"
  vpc_cidr             = "10.0.0.0/16"
  azs                  = ["ap-south-1a", "ap-south-1b"]
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.101.0/24", "10.0.102.0/24"]
  tags = {
    Environment = "test"
    Project     = "url-shortener"
  }
}

run "vpc_is_configured_correctly" {
  command = plan

  assert {
    condition     = aws_vpc.this.cidr_block == "10.0.0.0/16"
    error_message = "VPC CIDR block did not match the provided vpc_cidr"
  }

  assert {
    condition     = aws_vpc.this.enable_dns_hostnames == true
    error_message = "DNS hostnames should be enabled on the VPC"
  }

  assert {
    condition     = aws_vpc.this.enable_dns_support == true
    error_message = "DNS support should be enabled on the VPC"
  }

  assert {
    condition     = aws_vpc.this.tags["Name"] == "test-vpc"
    error_message = "VPC Name tag should equal var.vpc_name"
  }

  assert {
    condition     = aws_vpc.this.tags["Environment"] == "test"
    error_message = "VPC should merge in the caller-provided tags"
  }
}

run "creates_one_subnet_per_cidr" {
  command = plan

  assert {
    condition     = length(aws_subnet.public) == length(var.public_subnet_cidrs)
    error_message = "One public subnet should be created per public_subnet_cidrs entry"
  }

  assert {
    condition     = length(aws_subnet.private) == length(var.private_subnet_cidrs)
    error_message = "One private subnet should be created per private_subnet_cidrs entry"
  }
}

run "subnets_have_expected_attributes" {
  command = plan

  assert {
    condition     = aws_subnet.public[0].cidr_block == "10.0.1.0/24"
    error_message = "First public subnet CIDR did not match input"
  }

  assert {
    condition     = aws_subnet.public[0].availability_zone == "ap-south-1a"
    error_message = "Public subnet AZ should follow the azs list order"
  }

  assert {
    condition     = alltrue([for s in aws_subnet.public : s.map_public_ip_on_launch])
    error_message = "Public subnets must auto-assign public IPs"
  }

  assert {
    condition     = aws_subnet.private[1].tags["Name"] == "test-vpc-private-2"
    error_message = "Private subnet Name tag should be indexed from 1"
  }

  assert {
    condition     = aws_subnet.public[1].tags["Name"] == "test-vpc-public-2"
    error_message = "Public subnet Name tag should be indexed from 1"
  }
}

run "supports_a_single_az_deployment" {
  command = plan

  variables {
    azs                  = ["ap-south-1a"]
    public_subnet_cidrs  = ["10.0.1.0/24"]
    private_subnet_cidrs = ["10.0.101.0/24"]
  }

  assert {
    condition     = length(aws_subnet.public) == 1
    error_message = "Single-CIDR input should yield exactly one public subnet"
  }

  assert {
    condition     = length(aws_subnet.private) == 1
    error_message = "Single-CIDR input should yield exactly one private subnet"
  }
}
