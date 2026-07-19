variable "cluster_name" {
  type = string
}

variable "region" {
  description = "AWS region, used for the awslogs log driver."
  type        = string
}

variable "app_image" {
  description = "Container image URI for the Node app."
  type        = string
}

variable "nginx_image" {
  description = "Container image URI for nginx."
  type        = string
}

variable "app_port" {
  type    = number
  default = 3000
}

variable "nginx_port" {
  type    = number
  default = 80
}

variable "task_cpu" {
  type    = string
  default = "1024"
}

variable "task_memory" {
  type    = string
  default = "2048"
}

variable "redis_host" {
  type = string
}

variable "redis_port" {
  type    = number
  default = 6379
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "app_sg_id" {
  type = string
}

variable "nginx_sg_id" {
  type = string
}

variable "target_group_arn" {
  description = "ALB target group the nginx service registers with."
  type        = string
}

variable "service_discovery_service_arn" {
  description = "Cloud Map service ARN the app service registers with."
  type        = string
}

variable "desired_count" {
  type    = number
  default = 1
}

variable "log_retention_days" {
  type    = number
  default = 14
}

variable "tags" {
  type    = map(string)
  default = {}
}
