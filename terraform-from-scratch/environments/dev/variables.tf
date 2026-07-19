variable "region" {
  type    = string
  default = "ap-south-1"
}

variable "vpc_name" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "azs" {
  type = list(string)
}

variable "public_subnet_cidrs" {
  type = list(string)
}

variable "private_subnet_cidrs" {
  type = list(string)
}

variable "tag_name" {
  type = string
}

variable "project_name" {
  type = string
}

# --- Application / platform ---
variable "cluster_name" {
  type    = string
  default = "url-shortener-cluster"
}

variable "app_port" {
  type    = number
  default = 3000
}

variable "nginx_port" {
  type    = number
  default = 80
}

variable "redis_port" {
  type    = number
  default = 6379
}

variable "redis_engine" {
  type    = string
  default = "valkey"
}

variable "app_repo_name" {
  type    = string
  default = "urls/app"
}

variable "nginx_repo_name" {
  type    = string
  default = "urls/nginx"
}

variable "image_tag" {
  type    = string
  default = "latest"
}

variable "service_namespace" {
  type    = string
  default = "shortname.internal"
}

variable "app_service_name" {
  type    = string
  default = "shortname-app"
}

variable "desired_count" {
  type    = number
  default = 1
}

variable "certificate_arn" {
  description = "ACM certificate ARN for HTTPS. Leave empty for HTTP only."
  type        = string
  default     = ""
}
