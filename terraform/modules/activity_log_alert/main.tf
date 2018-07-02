# module: azure_activity_log_alert

variable "name" {}
variable "condition" {}
variable "activity_log_alert_name" {}
variable "resource_group" {}
variable "action_group" {}
variable depends_on { default = [], type = "list"}

# managed by azure-cli because they are currently not in TerraForm Azure provider
resource "null_resource" "azure_activity_log_alert" {
  provisioner "local-exec" {
    command = <<CMD
    az monitor activity-log alert create --name ${var.activity_log_alert_name}_${var.name} --resource-group ${var.resource_group} \
      --condition '${var.condition}' \
      --action-group ${var.action_group}
    CMD
  }

  provisioner "local-exec" {
    command    = "az monitor activity-log alert delete --name ${var.activity_log_alert_name}_${var.name} --resource-group ${var.resource_group}"
    when       = "destroy"
    on_failure = "continue"
  }
}