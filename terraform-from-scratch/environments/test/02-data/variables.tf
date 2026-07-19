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

variable "vpc_name" {
  type = string
}

variable "tag_name" {
  type = string
}

variable "project_name" {
  type = string
}

variable "redis_engine" {
  type    = string
  default = "valkey"
}
