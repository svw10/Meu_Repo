resource "aws_dynamodb_table" "this" {
  name = var.table_name; billing_mode = "PAY_PER_REQUEST"; hash_key = var.hash_key; range_key = var.range_key
  server_side_encryption { enabled = true }
  point_in_time_recovery { enabled = true }
  attribute { name = var.hash_key; type = "S" }
  dynamic "attribute" { for_each = var.range_key != null ? [1] : []; content { name = var.range_key; type = "S" } }
  dynamic "ttl" { for_each = var.ttl_attribute != null ? [1] : []; content { attribute_name = var.ttl_attribute; enabled = true } }
  tags = var.tags
}
