variable "region" {
  type    = string
  default = "ap-south-1"
}

variable "state_bucket" {
  description = "S3 bucket holding the layered remote state."
  type        = string
  default     = "shortn1-terraform-state-bucket"
}

variable "network_state_key" {
  description = "State key of the network layer to read outputs from."
  type        = string
  default     = "test/network.tfstate"
}

variable "data_state_key" {
  description = "State key of the data layer to read outputs from."
  type        = string
  default     = "test/data.tfstate"
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
  default = "url-shortener-test-cluster"
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
  default = "urls-test/app"
}

variable "nginx_repo_name" {
  type    = string
  default = "urls-test/nginx"
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
