locals {
  name_prefix = var.vpc_name

  common_tags = {
    Environment = var.tag_name
    Project     = var.project_name
  }
}

module "vpc" {
  source = "../../modules/network"

  vpc_name             = var.vpc_name
  vpc_cidr             = var.vpc_cidr
  azs                  = var.azs
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs

  tags = local.common_tags
}

module "internet_gateway" {
  source = "../../modules/internet-gateway"

  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  vpc_name          = var.vpc_name

  tags = local.common_tags
}

module "nat_gateway" {
  source = "../../modules/nat-gateway"

  vpc_id             = module.vpc.vpc_id
  vpc_name           = var.vpc_name
  public_subnet_id   = module.vpc.public_subnet_ids[0]
  private_subnet_ids = module.vpc.private_subnet_ids

  tags = local.common_tags
}

module "security_groups" {
  source = "../../modules/security-groups"

  vpc_id      = module.vpc.vpc_id
  name_prefix = local.name_prefix
  app_port    = var.app_port
  nginx_port  = var.nginx_port
  redis_port  = var.redis_port

  tags = local.common_tags
}

module "ecr" {
  source = "../../modules/ecr"

  repository_names = [var.app_repo_name, var.nginx_repo_name]

  tags = local.common_tags
}

module "alb" {
  source = "../../modules/alb"

  name               = "${local.name_prefix}-alb"
  vpc_id             = module.vpc.vpc_id
  public_subnet_ids  = module.vpc.public_subnet_ids
  security_group_ids = [module.security_groups.alb_sg_id]
  target_port        = var.nginx_port
  certificate_arn    = var.certificate_arn

  tags = local.common_tags
}

module "service_discovery" {
  source = "../../modules/service-discovery"

  vpc_id         = module.vpc.vpc_id
  namespace_name = var.service_namespace
  service_name   = var.app_service_name

  tags = local.common_tags
}

module "elasticache" {
  source = "../../modules/elasticache"

  name               = "${local.name_prefix}-cache"
  engine             = var.redis_engine
  subnet_ids         = module.vpc.private_subnet_ids
  security_group_ids = [module.security_groups.redis_sg_id]

  tags = local.common_tags
}

module "ecs" {
  source = "../../modules/ecs"

  cluster_name = var.cluster_name
  region       = var.region

  app_image   = "${module.ecr.repository_urls[var.app_repo_name]}:${var.image_tag}"
  nginx_image = "${module.ecr.repository_urls[var.nginx_repo_name]}:${var.image_tag}"

  app_port   = var.app_port
  nginx_port = var.nginx_port

  redis_host = module.elasticache.endpoint_address
  redis_port = var.redis_port

  private_subnet_ids = module.vpc.private_subnet_ids
  app_sg_id          = module.security_groups.app_sg_id
  nginx_sg_id        = module.security_groups.nginx_sg_id

  target_group_arn              = module.alb.target_group_arn
  service_discovery_service_arn = module.service_discovery.service_arn

  desired_count = var.desired_count

  tags = local.common_tags

  # ECS services need the ALB listener present before they can register.
  depends_on = [module.alb]
}
