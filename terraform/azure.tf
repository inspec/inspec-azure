terraform {
  required_version = "~> 0.11.0"
}

provider "azurerm" {
  version         = "~> 1.3"
  subscription_id = "${var.subscription_id}"
  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
  tenant_id       = "${var.tenant_id}"
}

provider "random" {
  version = "~> 1.2"
}

data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "rg" {
  name     = "Inspec-Azure-${terraform.workspace}"
  location = "${var.location}"
  tags {
    CreatedBy = "${terraform.workspace}"
  }
}

resource "azurerm_management_group" "mg_parent" {
  group_id = "mg_parent"
  display_name = "Management Group Parent"
}

resource "azurerm_management_group" "mg_child_one" {
  group_id = "mg_child_one"
  display_name = "Management Group Child 1"
  parent_management_group_id = "${azurerm_management_group.mg_parent.id}"
}

resource "azurerm_management_group" "mg_child_two" {
  group_id = "mg_child_two"
  display_name = "Management Group Child 2"
  parent_management_group_id = "${azurerm_management_group.mg_parent.id}"
}

resource "random_string" "password" {
  length = 16
  upper = true
  lower = true
  special = true
  override_special = "/@\" "
  min_numeric = 3
  min_special = 3
}

resource "azurerm_network_watcher" "rg" {
  name                = "${azurerm_resource_group.rg.name}-netwatcher"
  count               = "${var.network_watcher}"
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  tags {
    CreatedBy = "${terraform.workspace}"
  }
}

resource "random_string" "storage_account" {
  length  = 10
  special = false
  upper   = false
}

resource "azurerm_storage_account" "sa" {
  name                      = "${random_string.storage_account.result}"
  location                  = "${var.location}"
  resource_group_name       = "${azurerm_resource_group.rg.name}"
  enable_https_traffic_only = true
  account_tier              = "Standard"
  account_replication_type  = "LRS"
  depends_on                = ["azurerm_resource_group.rg"]
  tags                      = {
    user = "${terraform.workspace}"
  }
}

resource "azurerm_storage_container" "container" {
  name                  = "vhds"
  resource_group_name   = "${azurerm_resource_group.rg.name}"
  storage_account_name  = "${azurerm_storage_account.sa.name}"
  container_access_type = "private"
}

resource "random_pet" "blob_name" {
  length    = 2
  prefix    = "blob"
  separator = "-"
}

resource "azurerm_storage_container" "blob" {
  name                  = "${random_pet.blob_name.id}"
  resource_group_name   = "${azurerm_resource_group.rg.name}"
  storage_account_name  = "${azurerm_storage_account.sa.name}"
  container_access_type = "private"
}

resource "random_pet" "vault" {
  length    = 2
  prefix    = "vault"
  separator = "-"
}

resource "azurerm_key_vault" "disk_vault" {
  name                = "${random_pet.vault.id}"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  tenant_id           = "${var.tenant_id}"
  sku_name            = "premium"

  access_policy {
    tenant_id = "${var.tenant_id}"
    object_id = "${data.azurerm_client_config.current.service_principal_object_id}"

    key_permissions = [
      "create",
      "delete",
      "encrypt",
      "get",
      "import",
      "list",
      "sign",
      "unwrapKey",
      "verify",
      "wrapKey",
    ]

    secret_permissions = [
      "delete",
      "get",
      "list",
      "set",
    ]
  }

  enabled_for_disk_encryption = true
}

resource "azurerm_key_vault_secret" "vs" {
  name      = "secret"
  value     = "${random_string.password.result}"
  key_vault_id = "${azurerm_key_vault.disk_vault.id}"
}

resource "azurerm_key_vault_key" "vk" {
  name      = "key"
  key_vault_id = "${azurerm_key_vault.disk_vault.id}"
  key_type  = "EC"
  key_size  = 2048

  key_opts = [
    "sign",
    "verify",
  ]
}

resource "azurerm_managed_disk" "disk" {
  name                = "${var.encrypted_disk_name}"
  resource_group_name = "${azurerm_resource_group.rg.name}"

  location            = "${var.location}"

  storage_account_type= "${var.managed_disk_type}"
  create_option       = "Empty"
  disk_size_gb        = 1

  encryption_settings {
    enabled           = true
    disk_encryption_key {
      secret_url      = "${azurerm_key_vault_secret.vs.id}"
      source_vault_id = "${azurerm_key_vault.disk_vault.id}"
    }
    key_encryption_key {
      key_url         = "${azurerm_key_vault_key.vk.id}"
      source_vault_id = "${azurerm_key_vault.disk_vault.id}"
    }
  }
}

resource "azurerm_network_security_group" "nsg" {
  name                = "Inspec-NSG"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"

  security_rule {
    name                       = "SSH-RDP-Deny"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = ""
    destination_port_ranges    = ["22","3389"]
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_virtual_network" "vnet" {
  name                = "Inspec-VNet"
  address_space       = ["10.1.1.0/24"]
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
}

data "azurerm_virtual_network" "vnet" {
  name                = "${azurerm_virtual_network.vnet.name}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
}

resource "azurerm_subnet" "subnet" {
  name                 = "Inspec-Subnet"
  resource_group_name  = "${azurerm_resource_group.rg.name}"
  virtual_network_name = "${azurerm_virtual_network.vnet.name}"
  address_prefix       = "10.1.1.0/24"
}

resource "azurerm_subnet_network_security_group_association" "subnet_nsg" {
  network_security_group_id = "${azurerm_network_security_group.nsg.id}"
  subnet_id = "${azurerm_subnet.subnet.id}"
}

resource "azurerm_network_interface" "nic1" {
  name                = "Inspec-NIC-1"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"

  ip_configuration {
    name                          = "ipConfiguration1"
    subnet_id                     = "${azurerm_subnet.subnet.id}"
    private_ip_address_allocation = "dynamic"
  }
}

resource "azurerm_network_interface" "nic3" {
  name                = "Inspec-NIC-3"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"

  ip_configuration {
    name                          = "ipConfiguration1"
    subnet_id                     = "${azurerm_subnet.subnet.id}"
    private_ip_address_allocation = "dynamic"
  }
}

resource "azurerm_virtual_machine" "vm_linux_internal" {
  name                  = "Linux-Internal-VM"
  location              = "${var.location}"
  resource_group_name   = "${azurerm_resource_group.rg.name}"
  network_interface_ids = ["${azurerm_network_interface.nic1.id}"]
  vm_size               = "Standard_DS2_v2"

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04.0-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name          = "${var.linux_internal_os_disk}"
    vhd_uri       = "${azurerm_storage_account.sa.primary_blob_endpoint}${azurerm_storage_container.container.name}/linux-internal-osdisk.vhd"
    caching       = "ReadWrite"
    create_option = "FromImage"
  }

  storage_data_disk {
    name          = "${var.unmanaged_data_disk_name}"
    vhd_uri       = "${azurerm_storage_account.sa.primary_blob_endpoint}${azurerm_storage_container.container.name}/linux-internal-datadisk-1.vhd"
    disk_size_gb  = 15
    create_option = "empty"
    lun           = 0
  }

  os_profile {
    computer_name  = "linux-internal-1"
    admin_username = "azure"
    admin_password = "${random_string.password.result}"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  boot_diagnostics {
    enabled     = true
    storage_uri = "${azurerm_storage_account.sa.primary_blob_endpoint}"
  }
}

resource "azurerm_virtual_machine" "vm_windows_internal" {
  name                  = "Windows-Internal-VM"
  location              = "${var.location}"
  resource_group_name   = "${azurerm_resource_group.rg.name}"
  network_interface_ids = ["${azurerm_network_interface.nic3.id}"]
  vm_size               = "Standard_DS2_v2"

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }

  storage_os_disk {
    name              = "${var.windows_internal_os_disk}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_data_disk {
    name              = "${var.windows_internal_data_disk}"
    create_option     = "Empty"
    managed_disk_type = "Standard_LRS"
    lun               = 0
    disk_size_gb      = "1024"
  }

  os_profile {
    computer_name  = "win-internal-1"
    admin_username = "azure"
    admin_password = "${random_string.password.result}"
  }

  os_profile_windows_config {
    provision_vm_agent = true
  }
}

resource "random_pet" "workspace" {
  length  = 2
}

resource "azurerm_log_analytics_workspace" "workspace" {
  name                = "${random_pet.workspace.id}"
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  sku                 = "Standard"
  retention_in_days   = 30
}

resource "azurerm_virtual_machine_extension" "log_extension" {
  name                 = "${var.monitoring_agent_name}"
  location             = "${var.location}"
  resource_group_name  = "${azurerm_resource_group.rg.name}"
  virtual_machine_name = "${azurerm_virtual_machine.vm_windows_internal.name}"
  publisher            = "Microsoft.EnterpriseCloud.Monitoring"
  type                 = "MicrosoftMonitoringAgent"
  type_handler_version = "1.0"

  settings = <<SETTINGS
    {
      "workspaceId": "${azurerm_log_analytics_workspace.workspace.workspace_id}"
    }
SETTINGS

  protected_settings = <<PROTECTED_SETTINGS
    {
      "workspaceKey": "${azurerm_log_analytics_workspace.workspace.primary_shared_key}"
    }
PROTECTED_SETTINGS
}

data "azurerm_monitor_log_profile" "log_profile" {
  name = "azure_log_profile"
}

resource "azurerm_monitor_log_profile" "azure_log_profile" {
  name                = "${data.azurerm_monitor_log_profile.log_profile.name}"
  categories          = ["${data.azurerm_monitor_log_profile.log_profile.categories}"]
  locations           = ["${data.azurerm_monitor_log_profile.log_profile.locations}"]
  storage_account_id  = "${data.azurerm_monitor_log_profile.log_profile.storage_account_id}"

  retention_policy {
    enabled = true
    days    = 365
  }
}

# MSI External Access VM
# Use only when testing MSI access controls
resource "azurerm_public_ip" "public_ip" {
  name                         = "Inspec-PublicIP-1"
  count                        = "${var.public_vm_count}"
  location                     = "${var.location}"
  resource_group_name          = "${azurerm_resource_group.rg.name}"
  public_ip_address_allocation = "dynamic"
}

resource "azurerm_network_interface" "nic2" {
  name                = "Inspec-NIC-2"
  count               = "${var.public_vm_count}"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"

  ip_configuration {
    name                          = "ipConfiguration1"
    subnet_id                     = "${azurerm_subnet.subnet.id}"
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = "${azurerm_public_ip.public_ip.0.id}"
  }
}

resource "azurerm_virtual_machine" "vm_linux_external" {
  name                  = "Linux-External-VM"
  count                 = "${var.public_vm_count}"
  location              = "${var.location}"
  resource_group_name   = "${azurerm_resource_group.rg.name}"
  network_interface_ids = ["${azurerm_network_interface.nic2.0.id}"]
  vm_size               = "Standard_DS2_v2"

  tags {
    Description = "Externally facing Linux machine with SSH access"
  }

  identity = {
    type = "SystemAssigned"
  }

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04.0-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "${var.linux_external_os_disk}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_data_disk {
    name          = "${var.linux_external_data_disk}"
    create_option = "Empty"
    managed_disk_type = "Standard_LRS"
    lun           = 0
    disk_size_gb  = 15
  }

  os_profile {
    computer_name  = "linux-external-1"
    admin_username = "azure"
    admin_password = "${random_string.password.result}"
  }

  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys {
      path     = "/home/azure/.ssh/authorized_keys"
      key_data = "${var.public_key}"
    }
  }
}

resource "azurerm_virtual_machine_extension" "virtual_machine_extension" {
  name                 = "MSIExtension"
  count                = "${var.public_vm_count}"
  location             = "${var.location}"
  resource_group_name  = "${azurerm_resource_group.rg.name}"
  virtual_machine_name = "${azurerm_virtual_machine.vm_linux_external.0.name}"
  publisher            = "Microsoft.ManagedIdentity"
  type                 = "ManagedIdentityExtensionForLinux"
  type_handler_version = "1.0"

  settings = <<SETTINGS
    {
        "port": 50342
    }
SETTINGS
}

resource "random_string" "sql_server" {
  length  = 10
  special = false
  upper   = false
}

resource "random_string" "sql_database" {
  length  = 10
  special = false
  upper   = false
}

resource "azurerm_sql_server" "sql-server" {
  name                         = "${random_string.sql_server.result}"
  resource_group_name          = "${azurerm_resource_group.rg.name}"
  location                     = "${var.location}"
  version                      = "${var.sql-server-version}"
  administrator_login          = "${terraform.workspace}"
  administrator_login_password = "P4assw0rd!"
}

resource "azurerm_sql_database" "sql-database" {
  name                = "${random_string.sql_database.result}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  location            = "${var.location}"
  server_name         = "${random_string.sql_server.result}"
  depends_on          = ["azurerm_sql_server.sql-server"]
  tags {}
}

resource "tls_private_key" "key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "azurerm_kubernetes_cluster" "cluster" {
  name                = "inspecakstest"
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  dns_prefix          = "inspecaksagent1"
  depends_on          = ["azurerm_resource_group.rg"]

  agent_pool_profile {
    name            = "inspecaks"
    count           = 5
    vm_size         = "Standard_DS1_v2"
    os_type         = "Linux"
    os_disk_size_gb = 30
  }
  linux_profile {
    admin_username = "inspecuser1"

    ssh_key {
      key_data = "${tls_private_key.key.public_key_openssh}"
    }
  }
  service_principal {
    client_id     = "${var.client_id}"
    client_secret = "${var.client_secret}"
  }
}

resource "azurerm_app_service_plan" "app-service-plan" {
  name                = "app-serv-plan-${random_pet.workspace.id}"
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  kind                = "Windows"

  sku {
    tier              = "Free"
    size              = "F1"
  }
}

resource "azurerm_app_service" "app-service" {
  name                = "app-serv-${random_pet.workspace.id}"
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  app_service_plan_id = "${azurerm_app_service_plan.app-service-plan.id}"
  https_only          = "true"

  identity = {
    type              = "SystemAssigned"
  }
}

data "azurerm_builtin_role_definition" "contributor" {
  name = "Contributor"
}