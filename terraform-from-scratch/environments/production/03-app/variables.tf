variable "region" {
  type    = string
  default = "ap-south-1"
}

variable "state_bucket" {
  description = "S3 bucket holding the layered remote state."
  type        = string
  default     = "shortn1-terraform-state-bucket"
}

variable "state_region" {
  description = "Region of the remote-state S3 bucket (independent of the deploy region)."
  type        = string
  default     = "ap-south-1"
}

variable "network_state_key" {
  description = "State key of the network layer to read outputs from."
  type        = string
  default     = "prod/network.tfstate"
}

variable "data_state_key" {
  description = "State key of the data layer to read outputs from."
  type        = string
  default     = "prod/data.tfstate"
}

variable "vpc_name" {
  type = string
}

variable "tag_name" {
  type = string
}

variable "project_name" {
  type = string
}

variable "cluster_name" {
  type    = string
  default = "url-shortener-prod-cluster"
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

variable "app_repo_name" {
  type    = string
  default = "urls-prod/app"
}

variable "nginx_repo_name" {
  type    = string
  default = "urls-prod/nginx"
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
