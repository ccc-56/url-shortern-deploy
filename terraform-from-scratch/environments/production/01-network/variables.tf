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
