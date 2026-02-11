resource "aws_iam_role" "scheduler_role" {
  name = "${var.project_name}-scheduler-role"
  assume_role_policy = jsonencode({ Version = "2012-10-17", Statement = [{ Action = "sts:AssumeRole", Principal = { Service = "scheduler.amazonaws.com" }, Effect = "Allow" }] })
  tags = var.tags
}
resource "aws_iam_role_policy" "scheduler_policy" {
  name = "invoke-ecs"; role = aws_iam_role.scheduler_role.id
  policy = jsonencode({ Version = "2012-10-17", Statement = [{ Effect = "Allow", Action = ["ecs:RunTask", "iam:PassRole"], Resource = "*" }] })
}
resource "aws_scheduler_schedule" "this" {
  name = "${var.project_name}-run-schedule"; group_name = "default"; flexible_time_window { mode = "OFF" }; schedule_expression = var.schedule_expression
  target {
    arn = var.ecs_cluster_arn; role_arn = aws_iam_role.scheduler_role.arn
    ecs_parameters {
      task_definition_arn = var.ecs_task_definition_arn; launch_type = "FARGATE"
      network_configuration { subnets = var.subnet_ids; security_groups = var.security_group_ids; assign_public_ip = var.assign_public_ip }
    }
  }
}
