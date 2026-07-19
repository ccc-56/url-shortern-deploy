variable "namespace_name" {
  description = "Private DNS namespace (e.g. shortname.internal)."
  type        = string
  default     = "shortname.internal"
}

variable "service_name" {
  description = "Cloud Map service name for the app (e.g. shortname-app)."
  type        = string
  default     = "shortname-app"
}

variable "vpc_id" {
  type = string
}

variable "dns_ttl" {
  type    = number
  default = 15
}

variable "tags" {
  type    = map(string)
  default = {}
}
