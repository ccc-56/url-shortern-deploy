
resource "aws_vpc" "main" {

  cidr_block = "10.61.0.0/16"

  tags = {
    Name = "shortern-vpc"
  }
}


resource "aws_subnet" "public1" {

  vpc_id = aws_vpc.main.id

  cidr_block = "10.61.10.0/24"

  availability_zone = "ap-south-1a"

  tags = {
    Name = "public-a"
  }
}

resource "aws_subnet" "public2" {

  vpc_id = aws_vpc.main.id

  cidr_block = "10.61.20.0/24"

  availability_zone = "ap-south-1b"

  tags = {
    Name = "public-b"
  }
}

