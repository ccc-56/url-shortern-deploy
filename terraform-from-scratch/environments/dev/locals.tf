locals {
  common_tags = {
    Environment = var.tag_name
    Project     = var.project_name
  }
}
