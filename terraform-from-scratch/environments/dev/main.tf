
module "vpc" {

 source = "../../modules/network"

 vpc_name = var.vpc_name

 vpc_cidr = var.vpc_cidr

 azs = var.azs

 public_subnet_cidrs = var.public_subnet_cidrs

 private_subnet_cidrs = var.private_subnet_cidrs

 tags = {
   Environment = var.tag_name
   Project = var.project_name
 }

}
