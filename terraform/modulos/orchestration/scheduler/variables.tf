variable "project_name" { type = string }
variable "schedule_expression" { type = string }
variable "ecs_cluster_arn" { type = string }
variable "ecs_task_definition_arn" { type = string }
variable "subnet_ids" { type = list(string) }
variable "security_group_ids" { type = list(string) }
variable "tags" { type = map(string) }
variable "assign_public_ip" { type = bool; default = false }
