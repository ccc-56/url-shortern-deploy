locals {
  common_tags = {
    Environment = var.tag_name
    Project     = var.project_name
  }
}

data "terraform_remote_state" "network" {
  backend = "s3"

  config = {
    bucket = var.state_bucket
    key    = var.network_state_key
    region = var.region
  }
}

module "elasticache" {
  source = "../../../modules/elasticache"

  name               = "${var.vpc_name}-cache"
  engine             = var.redis_engine
  subnet_ids         = data.terraform_remote_state.network.outputs.private_subnet_ids
  security_group_ids = [data.terraform_remote_state.network.outputs.redis_sg_id]

  tags = local.common_tags
}
