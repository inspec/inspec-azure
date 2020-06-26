output "vnet_name" {
  value = azurerm_virtual_network.vnet.name
}

output "vnet_id" {
  value = azurerm_virtual_network.vnet.id
}

output "vnet_location" {
  value = azurerm_virtual_network.vnet.location
}

output "vnet_tags" {
  value = azurerm_virtual_network.vnet.tags
}

output "vnet_address_space" {
  value = azurerm_virtual_network.vnet.address_space
}

output "vnet_subnets" {
  value = [
  azurerm_subnet.subnet.name]
}

output "vnet_dns_servers" {
  value = data.azurerm_virtual_network.vnet.dns_servers
}

output "vnet_peerings" {
  value = data.azurerm_virtual_network.vnet.vnet_peerings
}

output "subnet_name" {
  value = azurerm_subnet.subnet.name
}

output "subnet_id" {
  value = azurerm_subnet.subnet.id
}

output "subnet_virutal_network_name" {
  value = azurerm_subnet.subnet.virtual_network_name
}

output "subnet_ip_configurations" {
  value = azurerm_subnet.subnet.ip_configurations
}

output "subnet_address_prefix" {
  value = azurerm_subnet.subnet.address_prefix
}

output "subnet_nsg" {
  value = azurerm_network_security_group.nsg.name
}

output "resource_group" {
  value = azurerm_resource_group.rg.name
}

output "storage_account" {
  value = azurerm_storage_account.sa.name
}

output "network_watcher_name" {
  value = azurerm_network_watcher.rg.*.name
}

output "network_watcher_id" {
  value = azurerm_network_watcher.rg.*.id
}

output "location" {
  value = var.location
}

output "os_disks" {
  description = "Virtual Machine OS disk names that were created."
  value = compact(list(var.linux_internal_os_disk,
    var.windows_internal_os_disk,
  var.public_vm_count == 1 ? var.linux_external_os_disk : ""))
}

output "managed_data_disks" {
  description = "Virtual Machine OS disk names that were created."
  value = compact(list(var.windows_internal_data_disk,
  var.public_vm_count == 1 ? var.linux_external_data_disk : ""))
}

output "data_disks" {
  description = "Virtual Machine data disk names that were created."
  value = list(
    azurerm_virtual_machine.vm_linux_internal.storage_data_disk[0].name,
    azurerm_virtual_machine.vm_windows_internal.storage_data_disk[0].name
  )
}

output "unencrypted_disk_name" {
  value = var.windows_internal_os_disk
}

output "encrypted_disk_name" {
  value = azurerm_managed_disk.disk.name
}

output "encrypted_disk_location" {
  value = azurerm_managed_disk.disk.location
}

output "managed_disk_name" {
  value = var.windows_internal_data_disk
}

output "unamaged_disk_name" {
  value = var.unmanaged_data_disk_name
}

output "vm_names" {
  description = "Virtual Machine names that were created."
  value = concat(azurerm_virtual_machine.vm_windows_internal.*.name,
    azurerm_virtual_machine.vm_linux_internal.*.name,
  azurerm_virtual_machine.vm_linux_external.*.name)
}

output "windows_vm_name" {
  value = azurerm_virtual_machine.vm_windows_internal.name
}

output "windows_vm_location" {
  value = azurerm_virtual_machine.vm_windows_internal.location
}

output "windows_vm_id" {
  value = azurerm_virtual_machine.vm_windows_internal.id
}

output "windows_vm_tags" {
  value = azurerm_virtual_machine.vm_windows_internal.tags
}

output "windows_vm_os_disk" {
  value = var.windows_internal_os_disk
}

output "windows_vm_data_disks" {
  value = [
  var.windows_internal_data_disk]
}

output "windows_vm_nic_name" {
  value = azurerm_network_interface.nic3.name
}

output "linux_vm_nic_name" {
  value = azurerm_network_interface.nic1.name
}

output "monitoring_agent_name" {
  value = var.monitoring_agent_name
}

output "network_security_group" {
  value = azurerm_network_security_group.nsg.name
}

output "network_security_group_id" {
  value = azurerm_network_security_group.nsg.id
}

output "network_security_group_insecure" {
  value = azurerm_network_security_group.nsg_insecure.name
}

output "network_security_group_open" {
  value = azurerm_network_security_group.nsg_open.name
}

output "activity_log_alert_name" {
  value = var.activity_log_alert["log_alert"]
}

output "sql_server_name" {
  value = azurerm_sql_server.sql_server.name
}

output "sql_database_name" {
  value = azurerm_sql_database.sql_database.name
}

output "key_vault_name" {
  value = azurerm_key_vault.disk_vault.name
}

output "key_vault_key_name" {
  value = azurerm_key_vault_key.vk.name
}

output "key_vault_secret_name" {
  value = azurerm_key_vault_secret.vs.name
}

output "storage_account_blob_container" {
  value = azurerm_storage_container.blob.name
}

output "mysql_server_name" {
  value = azurerm_mysql_server.mysql_server.name
}

output "mariadb_server_name" {
  value = azurerm_mariadb_server.mariadb_server.name
}

output "mysql_database_name" {
  value = azurerm_mysql_database.mysql_database.name
}

output "lb_name" {
  value = module.azurerm_lb.azurerm_lb_name
}

output "cluster_fqdn" {
  value = azurerm_kubernetes_cluster.cluster.fqdn
}

output "tenant_id" {
  value = var.tenant_id
}

output "parent_mg" {
  value = azurerm_management_group.mg_parent.group_id
}

output "child1_mg" {
  value = azurerm_management_group.mg_child_one.group_id
}

output "child2_mg" {
  value = azurerm_management_group.mg_child_two.group_id
}

output "parent_dn" {
  value = azurerm_management_group.mg_parent.display_name
}

output "webapp_name" {
  value = azurerm_app_service.app_service.name
}

output "contributor_role_name" {
  value = substr(data.azurerm_role_definition.contributor.id, -36, 36)
}

output "log_profile_name" {
  value = azurerm_monitor_log_profile.log_profile.name
}


output "postgresql_server_name" {
  value = azurerm_postgresql_server.postgresql.name
}

output "postgresql_database_name" {
  value = azurerm_postgresql_database.postgresql.name
}

output "event_hub_endpoint" {
  value = azurerm_eventhub.event_hub.name
}

output "event_hub_name" {
  value = azurerm_eventhub.event_hub.name
}

output "event_hub_authorization_rule" {
  value = azurerm_eventhub_authorization_rule.auth_rule_inspectesteh.name
}

output "cosmosdb_database_account" {
  value = azurerm_cosmosdb_account.inspectest_cosmosdb.name
}

output "event_hub_namespace_name" {
  value = azurerm_eventhub_namespace.event_hub_namespace.name
}

output "iothub_resource_name" {
  value = azurerm_iothub.iothub.name
}

output "iothub_event_hub_endpoint" {
  value = azurerm_iothub_consumer_group.inspecehtest_consumergroup.eventhub_endpoint_name
}

output "consumer_group" {
  value = azurerm_iothub_consumer_group.inspecehtest_consumergroup.name
}

output "consumer_groups" {
  value = ["$Default", azurerm_iothub_consumer_group.inspecehtest_consumergroup.name]
}

output "application_gateway_id" {
  description = "the id for the azurerm_application_gateway resource"
  value       = azurerm_application_gateway.network.id
}

output "application_gateway_name" {
  description = "the name for the azurerm_application_gateway resource"
  value       = azurerm_application_gateway.network.name
}
