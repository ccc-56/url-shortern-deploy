variable "vpc_id" {
  type = string
}

variable "vpc_name" {
  type = string
}

variable "public_subnet_ids" {
  type    = list(string)
  default = []
}

