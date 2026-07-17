provider "aws" {
  region = "ap-south-1"
}

resource "aws_s3_bucket" "tfstate" {
  bucket = "shortn1-terraform-state-bucket"
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.tfstate.id

  versioning_configuration {
    status = "Enabled"
  }
}
