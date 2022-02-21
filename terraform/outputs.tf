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

output "virtual_network_peering_name" {
  value = azurerm_virtual_network_peering.network_peering.name
}

output "virtual_network_peering_id" {
  value = azurerm_virtual_network_peering.network_peering.id
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

output "container_registry_name" {
    value = azurerm_container_registry.acr.name
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

output "attached_disk_name" {
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
  value = azurerm_management_group.mg_parent.0.group_id
}

output "child1_mg" {
  value = azurerm_management_group.mg_child_one.0.group_id
}

output "child2_mg" {
  value = azurerm_management_group.mg_child_two.0.group_id
}

output "parent_dn" {
  value = azurerm_management_group.mg_parent.0.display_name
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

output "hdinsight_cluster_name" {
  description = "HDINSIGHT cluster name."
  value       = var.hd_insight_cluster_count > 0 ? azurerm_hdinsight_interactive_query_cluster.hdinsight_cluster.0.name : ""
}

output "ip_address_name" {
  description = "tha name of the azurerm_public_ip"
  value       = var.public_ip_count > 0 ? azurerm_public_ip.public_ip_address[0].name : ""
}

output "api_management_name" {
  description = "the name for the azurerm_api_management resource"
  value       = var.api_management_count > 0 ? azurerm_api_management.apim01[0].name : ""
}
output "azure_streaming_job_function_name" {
  description = "the name for the azure_streaming_service_job"
  value       = azurer_stream_analytics_function_javascript_udf.streaming_job_function.name
}
output "azure_streaming_job_name" {
  description = "the name for the azure_streaming_service_resource_job_function"
  value       = azurer_stream_analytics_job.streaming_job.name
}

output "azurerm_app_service_plan_name" {
  description = "The name for azurerm_app_service_plan resource for functions"
  value = azurerm_app_service_plan.web_app_function_app_service.name
}

output "web_app_function_db_name" {
  description = "the name for the azurerm_storage_account resource for functions"
  value       = azurerm_storage_account.web_app_function_db.name
}

output "web_app_function_app_name" {
  description = "the name for the web app function"
  value = azurerm_function_app.web_app_function.name
}

output "web_app_function_name" {
  description = "the name for the web app function"
  value = "HttpTrigger1"
}

output "policy_definition_id" {
  description = "The ID of the policy Definition"
  value = azurerm_policy_definition.inspec_policy_definition.id
}
output "policy_definition_associated_cosmodb_id" {
  description = "The Resource ID for which a policy definition is run against"
  value = azurerm_cosmosdb_account.inspectest_cosmosdb.id
}

output "ddos_protection_plan_name" {
  value = azurerm_network_ddos_protection_plan.andpp.name
}

output "ddos_protection_plan_location" {
  value = azurerm_network_ddos_protection_plan.andpp.location

}

output "dns_zones" {
  value = azurerm_dns_zone.example-public.name
}

output "dns_location" {
  value = "global"
}

output "bastionHostName" {
  description = "Name of the bastion Host"
  value = azurerm_bastion_host.abh.name
}

output "bastionHostLocation" {
  description = "Location of the bastion Hosts"
  value = azurerm_bastion_host.abh.location
}

//output "policy_exemption_name" {
//  description = "the name of the policy exemption"
//  value = azurerm_policy_exemption.inspec_compliance_policy_exemption.name
//}

output "df_name" {
  value = azurerm_data_factory.adf.name
}

output "df_location" {
  value = azurerm_data_factory.adf.location
}

output "df_pipeline_name" {
  value = azurerm_data_factory_pipeline.df_pipeline.name
}

output "inspec_db_migration_service_name" {
  value = var.inspec_db_migration_service.name
}

output "inspec_db_migration_service_sku_name" {
  value = var.inspec_db_migration_service.sku_name
}

output "circuitName" {
  value = azurerm_express_route_circuit.express_route.name
}

output "circuitLocation" {
  value = azurerm_express_route_circuit.express_route.location
}

output "peeringLocation" {
  value = azurerm_express_route_circuit.express_route.peering_location
}

output "serviceProviderName" {
  value = azurerm_express_route_circuit.express_route.service_provider_name
}

output "bandwidthInMbps" {
  value = azurerm_express_route_circuit.express_route.bandwidth_in_mbps
}

output "sku_name" {
  value = var.express_route_circuit_sku_name
}

output "sku_family" {
  value = azurerm_express_route_circuit.express_route.sku[0].family
}

output "sku_tier" {
  value = azurerm_express_route_circuit.express_route.sku[0].tier
}

output "circuitProvisioningState" {
  value = var.circuit_provisioning_state
}

output "allowClassicOperations" {
  value = var.allow_classic_operations
}

output "serviceProviderProvisioningState" {
  value = var.service_provider_provisioning_state
}

output "express_route_name" {
  value = var.express_route_name
}

output "inspec_container_group_name" {
  description = "the name of the container group"
  value = azurerm_container_group.inspec_container_trial.name
}

output "sample_directory_object" {
  description = "the name of the directory object"
  value = var.sample_directory_object
}

output "linked_service_name" {
  value = azurerm_data_factory_linked_service_mysql.dflsmsql.name
}

output "inspec_redis_cache_name" {
  description = "The name of the redis cache created for cloud packs"
  value = azurerm_redis_cache.inspec_compliance_redis_cache.name
}

output "inspec_virtual_wan" {
  description = "The resource name of the inspec virtual WAN"
  value = azurerm_virtual_wan.inspec-nw-wan.name
}

output "inspec_migrate_project_name" {
  description = "The name of the Azure Migrate Project that was setup manually since there is no tf resource"
  value = var.inspec_migrate_project_name
}

output "inspec_vnw_gateway_name" {
  description = "The name of the Azure Virtual Network Gateway"
  value = azurerm_virtual_network_gateway.inspec-nw-gateway.name
}

output "inspec_adls_account_name" {
  description = "The storage account for the ADLS"
  value = azurerm_storage_account.sa.name
}

output "inspec_adls_fs_name" {
  description = "The ADLS File System name"
  value = azurerm_storage_data_lake_gen2_filesystem.inspec_adls_gen2.name
}

output "inspec_adls_dns_suffix" {
  description = "The default DNS suffix for ADLS"
  value = "dfs.core.windows.net"
}

output "inspec_sql_managed_instance_name" {
  description = "The SQL managed instance name"
  value = azurerm_sql_managed_instance.sql_instance_for_inspec.name
}

output "inspec_sql_virtual_machine" {
  description = "SQL VM"
  value = azurerm_mssql_virtual_machine.inspec_sql_vm.id
}