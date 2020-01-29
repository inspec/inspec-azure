resource "azurerm_monitor_action_group" "default" {
  name                = var.activity_log_alert["action_group"]
  short_name          = "defaultAG"
  resource_group_name = azurerm_resource_group.rg.name
}

module "activity_log_alert_5_3" {
  source                  = "./modules/activity_log_alert"
  name                    = "5_3"
  operation               = "Microsoft.Authorization/policyAssignments/write"
  activity_log_alert_name = var.activity_log_alert["log_alert"]
  resource_group_name     = azurerm_resource_group.rg.name
  resource_group_id       = azurerm_resource_group.rg.id
  action_group            = azurerm_monitor_action_group.default.id
}

module "activity_log_alert_5_4" {
  source                  = "./modules/activity_log_alert"
  name                    = "5_4"
  operation               = "Microsoft.Network/networkSecurityGroups/write"
  activity_log_alert_name = var.activity_log_alert["log_alert"]
  resource_group_name     = azurerm_resource_group.rg.name
  resource_group_id       = azurerm_resource_group.rg.id
  action_group            = azurerm_monitor_action_group.default.id
}

module "activity_log_alert_5_5" {
  source                  = "./modules/activity_log_alert"
  name                    = "5_5"
  operation               = "Microsoft.Network/networkSecurityGroups/delete"
  activity_log_alert_name = var.activity_log_alert["log_alert"]
  resource_group_name     = azurerm_resource_group.rg.name
  resource_group_id       = azurerm_resource_group.rg.id
  action_group            = azurerm_monitor_action_group.default.id
}

module "activity_log_alert_5_6" {
  source                  = "./modules/activity_log_alert"
  name                    = "5_6"
  operation               = "Microsoft.Network/networkSecurityGroups/securityRules/write"
  activity_log_alert_name = var.activity_log_alert["log_alert"]
  resource_group_name     = azurerm_resource_group.rg.name
  resource_group_id       = azurerm_resource_group.rg.id
  action_group            = azurerm_monitor_action_group.default.id
}

module "activity_log_alert_5_7" {
  source                  = "./modules/activity_log_alert"
  name                    = "5_7"
  operation               = "Microsoft.Network/networkSecurityGroups/securityRules/delete"
  activity_log_alert_name = var.activity_log_alert["log_alert"]
  resource_group_name     = azurerm_resource_group.rg.name
  resource_group_id       = azurerm_resource_group.rg.id
  action_group            = azurerm_monitor_action_group.default.id
}

module "activity_log_alert_5_8" {
  source                  = "./modules/activity_log_alert"
  name                    = "5_8"
  operation               = "Microsoft.Security/securitySolutions/write"
  activity_log_alert_name = var.activity_log_alert["log_alert"]
  resource_group_name     = azurerm_resource_group.rg.name
  resource_group_id       = azurerm_resource_group.rg.id
  action_group            = azurerm_monitor_action_group.default.id
}

module "activity_log_alert_5_9" {
  source                  = "./modules/activity_log_alert"
  name                    = "5_9"
  operation               = "Microsoft.Security/securitySolutions/delete"
  activity_log_alert_name = var.activity_log_alert["log_alert"]
  resource_group_name     = azurerm_resource_group.rg.name
  resource_group_id       = azurerm_resource_group.rg.id
  action_group            = azurerm_monitor_action_group.default.id
}

module "activity_log_alert_5_10" {
  source                  = "./modules/activity_log_alert"
  name                    = "5_10"
  operation               = "Microsoft.Sql/servers/firewallRules/write"
  activity_log_alert_name = var.activity_log_alert["log_alert"]
  resource_group_name     = azurerm_resource_group.rg.name
  resource_group_id       = azurerm_resource_group.rg.id
  action_group            = azurerm_monitor_action_group.default.id
}

module "activity_log_alert_5_11" {
  source                  = "./modules/activity_log_alert"
  name                    = "5_11"
  operation               = "Microsoft.Sql/servers/firewallRules/delete"
  activity_log_alert_name = var.activity_log_alert["log_alert"]
  resource_group_name     = azurerm_resource_group.rg.name
  resource_group_id       = azurerm_resource_group.rg.id
  action_group            = azurerm_monitor_action_group.default.id
}

module "activity_log_alert_5_12" {
  source                  = "./modules/activity_log_alert"
  name                    = "5_12"
  operation               = "Microsoft.Security/policies/write"
  activity_log_alert_name = var.activity_log_alert["log_alert"]
  resource_group_name     = azurerm_resource_group.rg.name
  resource_group_id       = azurerm_resource_group.rg.id
  action_group            = azurerm_monitor_action_group.default.id
}