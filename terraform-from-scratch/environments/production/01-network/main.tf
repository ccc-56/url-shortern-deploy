locals {
  name_prefix = var.vpc_name

  common_tags = {
    Environment = var.tag_name
    Project     = var.project_name
  }
}

module "vpc" {
  source = "../../../modules/network"

  vpc_name             = var.vpc_name
  vpc_cidr             = var.vpc_cidr
  azs                  = var.azs
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs

  tags = local.common_tags
}

module "internet_gateway" {
  source = "../../../modules/internet-gateway"

  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  vpc_name          = var.vpc_name

  tags = local.common_tags
}

module "nat_gateway" {
  source = "../../../modules/nat-gateway"

  vpc_id             = module.vpc.vpc_id
  vpc_name           = var.vpc_name
  public_subnet_id   = module.vpc.public_subnet_ids[0]
  private_subnet_ids = module.vpc.private_subnet_ids

  tags = local.common_tags
}

module "security_groups" {
  source = "../../../modules/security-groups"

  vpc_id      = module.vpc.vpc_id
  name_prefix = local.name_prefix
  app_port    = var.app_port
  nginx_port  = var.nginx_port
  redis_port  = var.redis_port

  tags = local.common_tags
}
