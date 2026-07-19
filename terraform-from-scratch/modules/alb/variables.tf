variable "name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "security_group_ids" {
  type = list(string)
}

variable "target_port" {
  description = "Port the nginx targets listen on."
  type        = number
  default     = 80
}

variable "health_check_path" {
  type    = string
  default = "/"
}

variable "certificate_arn" {
  description = "ACM certificate ARN. When set, an HTTPS:443 listener is created."
  type        = string
  default     = ""
}

variable "enable_deletion_protection" {
  type    = bool
  default = false
}

variable "tags" {
  type    = map(string)
  default = {}
}
