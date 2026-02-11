variable "project_name" { type = string }
variable "environment" { type = string }
variable "cpu" { default = 256 }
variable "memory" { default = 512 }
variable "container_image" { type = string }
variable "secrets_map" { type = map(string); default = {} }
variable "env_vars" { type = map(string); default = {} }
variable "tags" { type = map(string) }
