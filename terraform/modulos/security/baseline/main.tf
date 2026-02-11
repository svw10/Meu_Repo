data "aws_caller_identity" "current" {}
resource "aws_kms_key" "platform_key" {
  description = "Chave Mestra para ${var.project_name}"; deletion_window_in_days = 30; enable_key_rotation = true
  tags = merge(var.tags, { Compliance = "PCI-DSS" })
}
resource "aws_guardduty_detector" "main" { enable = true; finding_publishing_frequency = "FIFTEEN_MINUTES"; tags = var.tags }
