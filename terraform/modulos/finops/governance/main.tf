resource "aws_budgets_budget" "project_budget" {
  name = "${var.project_name}-monthly-budget"; budget_type = "COST"; limit_amount = var.monthly_budget_limit; limit_unit = "USD"; time_period_start = "2024-01-01_00:00"; time_unit = "MONTHLY"
  notification { comparison_operator = "GREATER_THAN"; threshold = 80; threshold_type = "PERCENTAGE"; notification_type = "ACTUAL"; subscriber_email_addresses = [var.owner_email] }
  tags = var.tags
}
