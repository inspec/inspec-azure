output "resource_group" {
  value = "${azurerm_resource_group.rg.name}"
}

output "network_watcher_name" {
  value = "${azurerm_network_watcher.rg.name}"
}

output "network_watcher_id" {
  value = "${azurerm_network_watcher.rg.id}"
}

output "location" {
  value = "${var.location}"
}

output "os_disks" {
  value = [
           "${var.linux_internal_os_disk}",
           "${var.windows_internal_os_disk}"
          ]
}

output "managed_data_disks" {
  value = [
           "${var.windows_internal_data_disk}"
          ]
}

output "unencrypted_disk_name" {
  value = "${var.windows_internal_os_disk}",
}

output "encrypted_disk_name" {
  value = "${azurerm_managed_disk.disk.name}",
}

output "encrypted_disk_location" {
  value = "${azurerm_managed_disk.disk.location}",
}

output "managed_disk_name" {
  value = "${var.windows_internal_data_disk}"
}

output "unamaged_disk_name" {
  value = "${var.unmanaged_data_disk_name}"
}

output "vm_names" {
  value = [
           "${azurerm_virtual_machine.vm_windows_internal.name}",
           "${azurerm_virtual_machine.vm_linux_internal.name}",
          ]
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
