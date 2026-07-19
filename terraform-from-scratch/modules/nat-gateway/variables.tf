variable "vpc_id" {
  type = string
}

variable "vpc_name" {
  type = string
}

variable "public_subnet_id" {
  description = "Public subnet in which the NAT gateway is placed."
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnets whose default route goes through the NAT gateway."
  type        = list(string)
  default     = []
}

variable "tags" {
  type    = map(string)
  default = {}
}
