terraform {
  backend "s3" {
    bucket = "shortn1-terraform-state-bucket"
    key    = "network/vpc.tfstate"
    region = "ap-south-1"
    dynamodb_table = "terraform-lock-dev"
  }
}
