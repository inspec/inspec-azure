variable "subscription_id" {}
variable "client_id" {}
variable "client_secret" {}
variable "tenant_id" {}

variable "location" {
  default = "East US"
}

# azure_log_profile vars
variable "log_profile_default_location" {
  type    = "string"
  default = "EastUS"
}

# azure_activity_log_alert vars
variable "activity_log_alert" {
  type    = "map"
  default = {
    "action_group" = "defaultActionGroup"
    "log_alert"    = "defaultLogAlert"
  }
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

variable "network_watcher" {
  default = false
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


# Azure mysql

variable "start_ip_address" {
  description = "Defines the start IP address used in your database firewall rule."
  default     = "0.0.0.0"
}

variable "end_ip_address" {
  description = "Defines the end IP address used in your database firewall rule."
  default     = "255.255.255.255"
}

variable "db_version" {
  description = "Specifies the version of MySQL to use. Valid values are 5.6 and 5.7."
  default     = "5.7"
}

variable "ssl_enforcement" {
  description = "Specifies if SSL should be enforced on connections. Possible values are Enforced and Disabled."
  default     = "Enabled"
}

variable "sku_name" {
  description = "Specifies the SKU Name for this MySQL Server. The name of the SKU, follows the tier + family + cores pattern (e.g. B_Gen4_1, GP_Gen5_8)."
  default     = "B_Gen4_2"
}

variable "sku_capacity" {
  description = "The scale up/out capacity, representing server's compute units."
  default     = 2
}

variable "sku_tier" {
  description = "The tier of the particular SKU. Possible values are Basic, GeneralPurpose, and MemoryOptimized."
  default     = "Basic"
}

variable "sku_family" {
  description = "The family of hardware Gen4 or Gen5, before selecting your family check the product documentation for availability in your region."
  default     = "Gen4"
}

variable "storage_mb" {
  description = "Max storage allowed for a server. Possible values are between 5120 MB(5GB) and 1048576 MB(1TB) for the Basic SKU and between 5120 MB(5GB) and 4194304 MB(4TB) for General Purpose/Memory Optimized SKUs."
  default     = 5120
}

variable "backup_retention_days" {
  description = "Backup retention days for the server, supported values are between 7 and 35 days."
  default     = 7
}

variable "geo_redundant_backup" {
  description = "Enable Geo-redundant or not for server backup. Valid values for this property are Enabled or Disabled, not supported for the basic tier."
  default     = "Disabled"
}

variable "charset" {
  description = "Specifies the Charset for the MySQL Database, which needs to be a valid MySQL Charset."
  default     = "utf8"
}

variable "collation" {
  description = "Specifies the Collation for the MySQL Database, which needs to be a valid MySQL Collation."
  default     = "utf8_unicode_ci"
}