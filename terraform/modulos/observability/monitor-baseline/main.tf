data "aws_region" "current" {}
resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "${var.project_name}-${var.environment}-dashboard"
  dashboard_body = jsonencode({ widgets = [{ type = "metric", x = 0, y = 0, width = 12, height = 6, properties = { metrics = [["AWS/ECS", "CPUUtilization", "ClusterName", var.cluster_name]], period = 300, stat = "Average", region = data.aws_region.current.name, title = "CPU Health" } }] })
}
