variable "vpc_id" {
  type = string
}

variable "name_prefix" {
  description = "Prefix for security group names."
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

variable "redis_port" {
  type    = number
  default = 6379
}

variable "tags" {
  type    = map(string)
  default = {}
}
