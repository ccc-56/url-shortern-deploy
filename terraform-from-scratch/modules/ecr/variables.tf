variable "repository_names" {
  description = "ECR repositories to create (e.g. urls/app, urls/nginx)."
  type        = list(string)
  default     = ["urls/app", "urls/nginx"]
}

variable "image_tag_mutability" {
  type    = string
  default = "MUTABLE"
}

variable "scan_on_push" {
  type    = bool
  default = true
}

variable "force_delete" {
  description = "Allow deleting the repo even if it still contains images."
  type        = bool
  default     = true
}

variable "tags" {
  type    = map(string)
  default = {}
}
