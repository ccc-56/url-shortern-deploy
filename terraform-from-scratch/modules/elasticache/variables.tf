variable "name" {
  type = string
}

variable "engine" {
  description = "Serverless cache engine (valkey or redis)."
  type        = string
  default     = "valkey"
}

variable "subnet_ids" {
  description = "Private subnets for the serverless cache."
  type        = list(string)
}

variable "security_group_ids" {
  type = list(string)
}

variable "tags" {
  type    = map(string)
  default = {}
}
