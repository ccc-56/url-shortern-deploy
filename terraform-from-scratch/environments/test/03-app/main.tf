locals {
  name_prefix = var.vpc_name

  common_tags = {
    Environment = var.tag_name
    Project     = var.project_name
  }

  network = data.terraform_remote_state.network.outputs
  data    = data.terraform_remote_state.data.outputs
}

data "terraform_remote_state" "network" {
  backend = "s3"

  config = {
    bucket = var.state_bucket
    key    = var.network_state_key
    region = var.region
  }
}

data "terraform_remote_state" "data" {
  backend = "s3"

  config = {
    bucket = var.state_bucket
    key    = var.data_state_key
    region = var.region
  }
}

module "ecr" {
  source = "../../../modules/ecr"

  repository_names = [var.app_repo_name, var.nginx_repo_name]

  tags = local.common_tags
}

module "alb" {
  source = "../../../modules/alb"

  name               = "${local.name_prefix}-alb"
  vpc_id             = local.network.vpc_id
  public_subnet_ids  = local.network.public_subnet_ids
  security_group_ids = [local.network.alb_sg_id]
  target_port        = var.nginx_port
  certificate_arn    = var.certificate_arn

  tags = local.common_tags
}

module "service_discovery" {
  source = "../../../modules/service-discovery"

  vpc_id         = local.network.vpc_id
  namespace_name = var.service_namespace
  service_name   = var.app_service_name

  tags = local.common_tags
}

module "ecs" {
  source = "../../../modules/ecs"

  cluster_name = var.cluster_name
  region       = var.region

  app_image   = "${module.ecr.repository_urls[var.app_repo_name]}:${var.image_tag}"
  nginx_image = "${module.ecr.repository_urls[var.nginx_repo_name]}:${var.image_tag}"

  app_port   = var.app_port
  nginx_port = var.nginx_port

  redis_host = local.data.redis_endpoint_address
  redis_port = var.redis_port

  private_subnet_ids = local.network.private_subnet_ids
  app_sg_id          = local.network.app_sg_id
  nginx_sg_id        = local.network.nginx_sg_id

  target_group_arn              = module.alb.target_group_arn
  service_discovery_service_arn = module.service_discovery.service_arn

  desired_count = var.desired_count

  tags = local.common_tags

  # ECS services need the ALB listener present before they can register.
  depends_on = [module.alb]
}
