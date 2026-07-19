region = "ap-south-1"

vpc_name = "short-prod-vpc"

vpc_cidr = "10.85.0.0/16"

azs = [
  "ap-south-1a",
  "ap-south-1b"
]

public_subnet_cidrs = [
  "10.85.10.0/24",
  "10.85.20.0/24"
]

private_subnet_cidrs = [
  "10.85.11.0/24",
  "10.85.21.0/24"
]

tag_name = "short-prod"

project_name = "url-shortener"
