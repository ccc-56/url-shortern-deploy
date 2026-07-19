region = "ap-south-1"

vpc_name = "short-test-vpc"

vpc_cidr = "10.75.0.0/16"

azs = [
  "ap-south-1a",
  "ap-south-1b"
]

public_subnet_cidrs = [
  "10.75.10.0/24",
  "10.75.20.0/24"
]

private_subnet_cidrs = [
  "10.75.11.0/24",
  "10.75.21.0/24"
]

tag_name = "short-test"

project_name = "url-shortener"
