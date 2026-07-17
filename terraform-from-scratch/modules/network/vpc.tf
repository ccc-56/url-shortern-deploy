
resource "aws_vpc" "this" {

  cidr_block = var.vpc_cidr

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(
    var.tags,
    {
      Name = var.vpc_name
    }
  )
}

resource "aws_subnet" "public" {

  count = length(var.public_subnet_cidrs)

  vpc_id = aws_vpc.this.id

  cidr_block = var.public_subnet_cidrs[count.index]

  availability_zone = var.azs[count.index]

  map_public_ip_on_launch = true


  tags = merge(
    var.tags,
    {
      Name = "${var.vpc_name}-public-${count.index + 1}"
    }
  )
}


resource "aws_subnet" "private" {

  count = length(var.private_subnet_cidrs)

  vpc_id = aws_vpc.this.id

  cidr_block = var.private_subnet_cidrs[count.index]

  availability_zone = var.azs[count.index]


  tags = merge(
    var.tags,
    {
      Name = "${var.vpc_name}-private-${count.index + 1}"
    }
  )
}

