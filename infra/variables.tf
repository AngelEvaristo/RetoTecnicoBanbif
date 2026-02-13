variable "region" { type = string }
variable "project_name" { type = string }
variable "ecr_repository_name" { type = string }
variable "image_tag" { type = string }

variable "container_port" {
  type    = number
  default = 3000
}

variable "cpu" {
  type    = number
  default = 256
}

variable "memory" {
  type    = number
  default = 512
}
