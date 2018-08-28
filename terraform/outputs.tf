output "vnet_name" {
  value = "${azurerm_virtual_network.vnet.name}"
}

output "vnet_id" {
  value = "${azurerm_virtual_network.vnet.id}"
}

output "vnet_location" {
  value = "${azurerm_virtual_network.vnet.location}"
}

output "vnet_tags" {
  value = "${azurerm_virtual_network.vnet.tags}"
}

output "vnet_address_space" {
  value = "${azurerm_virtual_network.vnet.address_space}"
}

output "vnet_subnets" {
  value = ["${azurerm_subnet.subnet.name}"]
}

output "vnet_dns_servers" {
  value = "${data.azurerm_virtual_network.vnet.dns_servers}"
}

output "vnet_peerings" {
  value = "${data.azurerm_virtual_network.vnet.vnet_peerings}"
}

output "subnet_name" {
  value = "${azurerm_subnet.subnet.name}"
}

output "subnet_id" {
  value = "${azurerm_subnet.subnet.id}"
}

output "subnet_virutal_network_name" {
  value = "${azurerm_subnet.subnet.virtual_network_name}"
}

output "subnet_ip_configurations" {
  value = "${azurerm_subnet.subnet.ip_configurations}"
}

output "subnet_address_prefix" {
  value = "${azurerm_subnet.subnet.address_prefix}"
}

output "subnet_nsg" {
  value = "${azurerm_network_security_group.nsg.name}"
}

output "resource_group" {
  value = "${azurerm_resource_group.rg.name}"
}

output "network_watcher_name" {
  value = "${azurerm_network_watcher.rg.*.name}"
}

output "network_watcher_id" {
  value = "${azurerm_network_watcher.rg.*.id}"
}

output "location" {
  value = "${var.location}"
}

output "os_disks" {
  description = "Virtual Machine OS disk names that were created."
  value = "${compact(list(var.linux_internal_os_disk,
                          var.windows_internal_os_disk,
                          var.public_vm_count == 1 ? var.linux_external_os_disk : ""))}"
}

output "managed_data_disks" {
  description = "Virtual Machine OS disk names that were created."
  value = "${compact(list(var.windows_internal_data_disk,
                          var.public_vm_count == 1 ? var.linux_external_data_disk : ""))}"
}

output "unencrypted_disk_name" {
  value = "${var.windows_internal_os_disk}"
}

output "encrypted_disk_name" {
  value = "${azurerm_managed_disk.disk.name}"
}

output "encrypted_disk_location" {
  value = "${azurerm_managed_disk.disk.location}"
}

output "managed_disk_name" {
  value = "${var.windows_internal_data_disk}"
}

output "unamaged_disk_name" {
  value = "${var.unmanaged_data_disk_name}"
}

output "vm_names" {
  description = "Virtual Machine names that were created."
  value       = "${concat(azurerm_virtual_machine.vm_windows_internal.*.name,
                          azurerm_virtual_machine.vm_linux_internal.*.name,
                          azurerm_virtual_machine.vm_linux_external.*.name)
                  }"
}

output "windows_vm_name" {
  value = "${azurerm_virtual_machine.vm_windows_internal.name}"
}

output "windows_vm_location" {
  value = "${azurerm_virtual_machine.vm_windows_internal.location}"
}

output "windows_vm_id" {
  value = "${azurerm_virtual_machine.vm_windows_internal.id}"
}

output "windows_vm_tags" {
  value = "${azurerm_virtual_machine.vm_windows_internal.tags}"
}

output "windows_vm_os_disk" {
  value = "${var.windows_internal_os_disk}"
}

output "windows_vm_data_disks" {
  value = ["${var.windows_internal_data_disk}"]
}

output "monitoring_agent_name" {
  value = "${var.monitoring_agent_name}"
}

output "network_security_group" {
  value = "${azurerm_network_security_group.nsg.name}"
}

output "network_security_group_id" {
  value = "${azurerm_network_security_group.nsg.id}"
}

output "activity_log_alert_name" {
  value = "${var.activity_log_alert["log_alert"]}"
}
