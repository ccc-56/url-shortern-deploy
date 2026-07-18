
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

module "internet_gateway" {

 source = "../../modules/internet-gateway"
 vpc_id = module.vpc.vpc_id
 public_subnet_ids = module.vpc.public_subnet_ids
 vpc_name = var.vpc_name

}
