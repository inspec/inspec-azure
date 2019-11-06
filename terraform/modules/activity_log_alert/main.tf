variable "name" {}
variable "operation" {}
variable "activity_log_alert_name" {}
variable "resource_group_name" {}
variable "resource_group_id" {}
variable "action_group" {}

resource "azurerm_monitor_activity_log_alert" "main" {
  name                = "${var.activity_log_alert_name}_${var.name}"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_group_id]

  criteria {
    operation_name = var.operation
    category       = "Administrative"
  }

  action {
    action_group_id = var.action_group
  }
}