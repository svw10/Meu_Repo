resource "aws_cloudwatch_log_group" "this" {
  name = "/ecs/${var.project_name}/${var.environment}/task"; retention_in_days = 7; tags = var.tags
}
resource "aws_iam_role" "execution_role" {
  name = "${var.project_name}-${var.environment}-exec-role"
  assume_role_policy = jsonencode({ Version = "2012-10-17", Statement = [{ Action = "sts:AssumeRole", Effect = "Allow", Principal = { Service = "ecs-tasks.amazonaws.com" }}] })
  tags = var.tags
}
resource "aws_iam_role_policy" "execution_policy" {
  name = "secrets-access"; role = aws_iam_role.execution_role.id
  policy = jsonencode({ Version = "2012-10-17", Statement = [{ Effect = "Allow", Action = ["ecr:*", "logs:*", "secretsmanager:GetSecretValue"], Resource = "*" }] })
}
resource "aws_iam_role" "task_role" {
  name = "${var.project_name}-${var.environment}-task-role"
  assume_role_policy = jsonencode({ Version = "2012-10-17", Statement = [{ Action = "sts:AssumeRole", Effect = "Allow", Principal = { Service = "ecs-tasks.amazonaws.com" }}] })
  tags = var.tags
}
resource "aws_ecs_cluster" "this" { name = "${var.project_name}-cluster"; tags = var.tags }
resource "aws_ecs_task_definition" "this" {
  family = "${var.project_name}-${var.environment}"; network_mode = "awsvpc"; requires_compatibilities = ["FARGATE"]
  cpu = var.cpu; memory = var.memory; execution_role_arn = aws_iam_role.execution_role.arn; task_role_arn = aws_iam_role.task_role.arn
  container_definitions = jsonencode([{
    name = "app"; image = var.container_image; essential = true
    logConfiguration = { logDriver = "awslogs", options = { "awslogs-group" = aws_cloudwatch_log_group.this.name, "awslogs-region" = data.aws_region.current.name, "awslogs-stream-prefix" = "ecs" } }
    environment = [for k, v in var.env_vars : { name = k, value = v }]
    secrets = [for k, v in var.secrets_map : { name = k, valueFrom = v }]
  }])
  tags = var.tags
}
data "aws_region" "current" {}
