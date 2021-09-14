variable "subscription_id" {}
variable "client_id" {}
variable "client_secret" {}
variable "tenant_id" {}

variable "location" {
  default = "East US"
}

# azure_log_profile vars
variable "log_profile_default_location" {
  type    = string
  default = "EastUS"
}

# azure_activity_log_alert vars
variable "activity_log_alert" {
  type = map(string)

  default = {
    "action_group" = "defaultActionGroup"
    "log_alert"    = "defaultLogAlert"
  }
}

variable "container_registry_name" {
  default = "containerRegistry"
}

variable "linux_external_os_disk" {
  default = "linux-external-osdisk"
}

variable "linux_internal_os_disk" {
  default = "Linux-Internal-OSDisk-MD"
}

variable "windows_internal_os_disk" {
  default = "Windows-Internal-OSDisk-MD"
}

variable "windows_internal_data_disk" {
  default = "Windows-Internal-DataDisk-1-MD"
}

variable "linux_external_data_disk" {
  default = "linux-external-datadisk-1"
}

variable "monitoring_agent_name" {
  default = "LogAnalytics"
}

variable "managed_disk_type" {
  default = "Standard_LRS"
}

variable "encrypted_disk_name" {
  default = "Encrypted-DataDisk"
}

variable "unmanaged_data_disk_name" {
  default = "linux-internal-datadisk-1"
}

variable "network_watcher_count" {
  # You may only have one Network Watcher enabled per an Azure subscription at a time.
  default = 1
}

variable "public_key" {
  default = ""
}

variable "public_vm_count" {
  default = 0
}

variable "sql-server-version" {
  default = "12.0"
}

variable "remote_port" {
  type        = "map"
  description = "Protocols to be used for remote vm access. [protocol, backend_port].  Frontend port will be automatically generated starting at 50000 and in the output."

  default = {
    ssh = ["Tcp", "22"]
  }
}

variable "lb_port" {
  type        = "map"
  description = "Protocols to be used for lb health probes and rules. [frontend_port, protocol, backend_port]"

  default = {
    http      = ["80", "Tcp", "80", "Default"]
    https     = ["443", "Tcp", "443", "SourceIP"]
    http-test = ["990", "Tcp", "990", "SourceIPProtocol"]
  }
}

variable "hd_insight_cluster_count" {
  default = 1
}

variable "public_ip_count" {
  default = 1
}

variable "api_management_count" {
  default = 1
}

variable "management_group_count" {
  default = 1
}

variable "policy_definition_name" {
  default = "inspec_compliance_audit"
}

variable "policy_definition_display_name" {
  default = "inspec_compliance_audit"
}

variable "policy_assignment_name" {
  default = "inspec_policy_assignment_name"
}

variable "policy_assignment_description" {
  default = "Policy Assignment created for inspec Cloud resource packs testing"
}

variable "policy_assignment_display_name" {
  default = "inspec_policy_assignment_name"
}

variable "express_route_name" {
  default = "AARNet"
}

variable "inspec_db_migration_service" {
  default = {
    name = "inspec-compliance-migration-dev"
    sku_name = "Standard_1vCores"
  }
}

variable "express_route_circuit_sku_name" {
  default = "Standard_MeteredData"
}

variable "circuit_provisioning_state" {
  default = "Enabled"
}

variable "allow_classic_operations" {
  default = false
}

variable "service_provider_provisioning_state" {
  default = "NotProvisioned"
}

variable "inspec_container_group_name" {
  default = "inspec_container_trial"
}

variable "sample_directory_object" {
  default = "adc07321-ef2b-44d5-a210-559aa5f10f2d"
}

variable "inspec_compliance_redis_cache_name" {
  default = "inspec-compliance-redis-cache"
}

variable "inspec_wan_name" {
  default = "inspec-nw-wan"
}

variable "inspec_adls_file_system_name" {
  default = "inspec-adls-fs"
}
