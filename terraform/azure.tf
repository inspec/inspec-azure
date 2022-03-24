terraform {
  required_version = "~> 0.12.0"
}

provider "azurerm" {
  version         = "~> 2.76.0"
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
  features {}
}

provider "random" {
  version = "~> 2.2.1"
}

data "azurerm_client_config" "current" {}

data "azurerm_role_definition" "contributor" {
  name = "Contributor"
}

resource "azurerm_resource_group" "rg" {
  name     = "Inspec-Azure-${terraform.workspace}"
  location = var.location
  tags = {
    CreatedBy  = terraform.workspace
    ExampleTag = "example"
  }
}

resource "azurerm_container_registry" "acr" {
  name                     = var.container_registry_name
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  sku                      = "Basic"
}

resource "azurerm_management_group" "mg_parent" {
  count = var.management_group_count
  group_id = "mg_parent"
  display_name = "Management Group Parent"
}

resource "azurerm_management_group" "mg_child_one" {
  count = var.management_group_count
  group_id = "mg_child_one"
  display_name = "Management Group Child 1"
  parent_management_group_id = azurerm_management_group.mg_parent.0.id
}

resource "azurerm_management_group" "mg_child_two" {
  count = var.management_group_count
  group_id = "mg_child_two"
  display_name = "Management Group Child 2"
  parent_management_group_id = azurerm_management_group.mg_parent.0.id
}

resource "random_string" "password" {
  length           = 16
  upper            = true
  lower            = true
  special          = true
  override_special = "/@\" "
  min_numeric      = 3
  min_special      = 3
}

resource "azurerm_network_watcher" "rg" {
  name                = "${azurerm_resource_group.rg.name}-netwatcher"
  count               = var.network_watcher_count
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tags = {
    CreatedBy = terraform.workspace
  }
}

resource "random_string" "storage_account" {
  length  = 10
  special = false
  upper   = false
}

resource "azurerm_storage_account" "sa" {
  name                      = random_string.storage_account.result
  location                  = var.location
  resource_group_name       = azurerm_resource_group.rg.name
  enable_https_traffic_only = true
  account_tier              = "Standard"
  account_replication_type  = "LRS"
  depends_on                = [azurerm_resource_group.rg]
  tags = {
    user = terraform.workspace
  }
}

resource "azurerm_storage_container" "container" {
  name                  = "vhds"
  storage_account_name  = azurerm_storage_account.sa.name
  container_access_type = "private"
}

resource "random_pet" "blob_name" {
  length    = 2
  prefix    = "blob"
  separator = "-"
}

resource "azurerm_storage_container" "blob" {
  name                  = random_pet.blob_name.id
  storage_account_name  = azurerm_storage_account.sa.name
  container_access_type = "private"
}

resource "random_pet" "vault" {
  length    = 2
  prefix    = "vault"
  separator = "-"
}

resource "azurerm_key_vault" "disk_vault" {
  name                = random_pet.vault.id
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  tenant_id           = var.tenant_id
  sku_name            = "premium"

  access_policy {
    tenant_id = var.tenant_id
    object_id = data.azurerm_client_config.current.service_principal_object_id

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
  name         = "secret"
  value        = random_string.password.result
  key_vault_id = azurerm_key_vault.disk_vault.id
}

resource "azurerm_key_vault_key" "vk" {
  name         = "key"
  key_vault_id = azurerm_key_vault.disk_vault.id
  key_type     = "EC"
  key_size     = 2048

  key_opts = [
    "sign",
    "verify",
  ]
}

resource "azurerm_managed_disk" "disk" {
  name                = var.encrypted_disk_name
  resource_group_name = azurerm_resource_group.rg.name

  location = var.location

  storage_account_type = var.managed_disk_type
  create_option        = "Empty"
  disk_size_gb         = 1

  encryption_settings {
    enabled = true
    disk_encryption_key {
      secret_url      = azurerm_key_vault_secret.vs.id
      source_vault_id = azurerm_key_vault.disk_vault.id
    }
    key_encryption_key {
      key_url         = azurerm_key_vault_key.vk.id
      source_vault_id = azurerm_key_vault.disk_vault.id
    }
  }
}

resource "azurerm_network_security_group" "nsg" {
  name                = "Inspec-NSG"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_network_security_group" "nsg_insecure" {
  name                = "Inspec-NSG-Insecure"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_network_security_rule" "SSHAllow" {
  name                        = "SSH-Allow"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.nsg_insecure.name
}

resource "azurerm_network_security_rule" "RDP-Allow" {
  name                        = "RDP-Allow"
  priority                    = 105
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "3389"
  source_address_prefix       = "Internet"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.nsg_insecure.name
}

resource "azurerm_network_security_rule" "DB-Allow" {
  name                        = "DB-Allow"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_ranges     = ["1433-1434", "1521", "4300-4350", "5000-6000"]
  source_address_prefix       = "Internet"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.nsg_insecure.name
}

resource "azurerm_network_security_rule" "File-Allow" {
  name                        = "File-Allow"
  priority                    = 120
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_ranges     = ["130-140", "445", "20-21", "69"]
  source_address_prefix       = "0.0.0.0/0"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.nsg_insecure.name
}

resource "azurerm_network_security_group" "nsg_open" {
  name                = "Inspec-NSG-Open"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  security_rule {
    name                       = "Open-All-To-World"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_virtual_network" "vnet" {
  name                = "Inspec-VNet"
  address_space       = ["10.1.1.0/24"]
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
}

data "azurerm_virtual_network" "vnet" {
  name                = azurerm_virtual_network.vnet.name
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "subnet" {
  name                 = "Inspec-Subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefix       = "10.1.1.0/24"
  # "Soft" deprecated, required until v2 of azurerm provider:
#  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_subnet_network_security_group_association" "subnet_nsg" {
  network_security_group_id = azurerm_network_security_group.nsg.id
  subnet_id                 = azurerm_subnet.subnet.id
}

resource "azurerm_network_interface" "nic1" {
  name                = "Inspec-NIC-1"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "ipConfiguration1"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "dynamic"
  }
}

resource "azurerm_network_interface" "nic3" {
  name                = "Inspec-NIC-3"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "ipConfiguration1"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "dynamic"
  }
}

resource "azurerm_virtual_machine" "vm_linux_internal" {
  name                  = "Linux-Internal-VM"
  location              = var.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.nic1.id]
  vm_size               = "Standard_DS2_v2"

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04.0-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name          = var.linux_internal_os_disk
    vhd_uri       = "${azurerm_storage_account.sa.primary_blob_endpoint}${azurerm_storage_container.container.name}/linux-internal-osdisk.vhd"
    caching       = "ReadWrite"
    create_option = "FromImage"
  }

  storage_data_disk {
    name          = var.unmanaged_data_disk_name
    vhd_uri       = "${azurerm_storage_account.sa.primary_blob_endpoint}${azurerm_storage_container.container.name}/linux-internal-datadisk-1.vhd"
    disk_size_gb  = 15
    create_option = "empty"
    lun           = 0
  }

  os_profile {
    computer_name  = "linux-internal-1"
    admin_username = "azure"
    admin_password = random_string.password.result
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  boot_diagnostics {
    enabled     = true
    storage_uri = azurerm_storage_account.sa.primary_blob_endpoint
  }
}

resource "azurerm_virtual_machine" "vm_windows_internal" {
  name                  = "Windows-Internal-VM"
  location              = var.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.nic3.id]
  vm_size               = "Standard_DS2_v2"

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }

  storage_os_disk {
    name              = var.windows_internal_os_disk
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_data_disk {
    name              = var.windows_internal_data_disk
    create_option     = "Empty"
    managed_disk_type = "Standard_LRS"
    lun               = 0
    disk_size_gb      = "1024"
  }

  os_profile {
    computer_name  = "win-internal-1"
    admin_username = "azure"
    admin_password = random_string.password.result
  }

  os_profile_windows_config {
    provision_vm_agent = true
  }
}

resource "random_pet" "workspace" {
  length = 2
}

resource "azurerm_log_analytics_workspace" "workspace" {
  name                = random_pet.workspace.id
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Standard"
  retention_in_days   = 30
}

resource "azurerm_virtual_machine_extension" "log_extension" {
  name                 = var.monitoring_agent_name
  location             = var.location
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_machine_name = azurerm_virtual_machine.vm_windows_internal.name
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

# Only one log_profile can be created per subscription if this fails run:
# az monitor log-profiles list --query [*].[id,name]
# the default log_profile should be deleted to enable this TF to work:
# az monitor log-profiles delete --name default
resource "azurerm_monitor_log_profile" "log_profile" {
  name = "default"

  categories = [
    "Action",
    "Write",
  ]

  locations = [
    "eastus",
    "global",
  ]

  storage_account_id = azurerm_storage_account.sa.id

  retention_policy {
    enabled = true
    days    = 365
  }
  depends_on = [azurerm_storage_account.sa]
}

# MSI External Access VM
# Use only when testing MSI access controls
resource "azurerm_public_ip" "public_ip" {
  name                = "Inspec-PublicIP-1"
  count               = var.public_vm_count
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "nic2" {
  name                = "Inspec-NIC-2"
  count               = var.public_vm_count
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "ipConfiguration1"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip[0].id
  }
}

resource "azurerm_virtual_machine" "vm_linux_external" {
  name                  = "Linux-External-VM"
  count                 = var.public_vm_count
  location              = var.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.nic2[0].id]
  vm_size               = "Standard_DS2_v2"

  tags = {
    Description = "Externally facing Linux machine with SSH access"
  }

  identity {
    type = "SystemAssigned"
  }

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04.0-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = var.linux_external_os_disk
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_data_disk {
    name              = var.linux_external_data_disk
    create_option     = "Empty"
    managed_disk_type = "Standard_LRS"
    lun               = 0
    disk_size_gb      = 15
  }

  os_profile {
    computer_name  = "linux-external-1"
    admin_username = "azure"
    admin_password = random_string.password.result
  }

  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys {
      path     = "/home/azure/.ssh/authorized_keys"
      key_data = var.public_key
    }
  }
}

resource "azurerm_virtual_machine_extension" "virtual_machine_extension" {
  name                 = "MSIExtension"
  count                = var.public_vm_count
  location             = var.location
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_machine_name = azurerm_virtual_machine.vm_linux_external[0].name
  publisher            = "Microsoft.ManagedIdentity"
  type                 = "ManagedIdentityExtensionForLinux"
  type_handler_version = "1.0"

  settings = <<SETTINGS
    {
        "port": 50342
    }
SETTINGS
}

resource "random_string" "sql" {
  length  = 10
  special = false
  upper   = false
}

resource "azurerm_sql_server" "sql_server" {
  name                         = "sql-srv-${random_string.sql.result}"
  resource_group_name          = azurerm_resource_group.rg.name
  location                     = var.location
  version                      = var.sql-server-version
  administrator_login          = "inspec-azure"
  administrator_login_password = "P4assw0rd!"
}

resource "azurerm_sql_database" "sql_database" {
  name                = "sqldb${random_string.sql.result}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  server_name         = azurerm_sql_server.sql_server.name
  depends_on          = [azurerm_sql_server.sql_server]
}


resource "random_string" "mysql_server" {
  length  = 10
  special = false
  upper   = false
}

resource "azurerm_mysql_server" "mysql_server" {
  name                = "mysql-svr-${random_string.sql.result}"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  sku {
    name     = "B_Gen5_2"
    capacity = "2"
    tier     = "Basic"
    family   = "Gen5"
  }

  storage_profile {
    storage_mb            = "5120"
    backup_retention_days = "7"
    geo_redundant_backup  = "Disabled"
  }

  administrator_login          = "iazAdmin"
  administrator_login_password = "P4assw0rd!"
  version                      = "5.7"
  ssl_enforcement              = "Enabled"
}

resource "azurerm_mysql_database" "mysql_database" {
  name                = "mysqldb${random_string.sql.result}"
  resource_group_name = azurerm_resource_group.rg.name
  server_name         = azurerm_mysql_server.mysql_server.name
  charset             = "utf8"
  collation           = "utf8_unicode_ci"
}

resource "azurerm_mysql_firewall_rule" "mysql_firewall_rule" {
  name                = "mysql-srv-firewall"
  resource_group_name = azurerm_resource_group.rg.name
  server_name         = azurerm_mysql_server.mysql_server.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "255.255.255.255"
}

resource "azurerm_mariadb_server" "mariadb_server" {
  name                = "maridb-svr-${random_string.sql.result}"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  sku {
    name     = "B_Gen5_2"
    capacity = "2"
    tier     = "Basic"
    family   = "Gen5"
  }

  storage_profile {
    storage_mb            = "5120"
    backup_retention_days = "7"
    geo_redundant_backup  = "Disabled"
  }

  administrator_login          = "iazAdmin"
  administrator_login_password = "P4assw0rd!"
  version                      = "10.2"
  ssl_enforcement              = "Enabled"
}

resource "azurerm_mariadb_firewall_rule" "mariadb_firewall_rule" {
  name                = "mariadb-srv-firewall"
  resource_group_name = azurerm_resource_group.rg.name
  server_name         = azurerm_mariadb_server.mariadb_server.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "255.255.255.255"
}

resource "random_string" "lb-random" {
  length  = 10
  special = false
  upper   = false
}
module "azurerm_lb" {
  source              = "./modules/load_balancer"
  use_loadbalancer    = "true"
  resource_group_name = azurerm_resource_group.rg.name
  lb_name             = "${random_string.lb-random.result}-lb"
  location            = var.location
  remote_port         = var.remote_port
  lb_port             = var.lb_port
}

resource "tls_private_key" "key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "azurerm_kubernetes_cluster" "cluster" {
  name                = "inspecakstest"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "inspecaksagent1"
  depends_on          = [azurerm_resource_group.rg]

  agent_pool_profile {
    name            = "inspecaks"
    count           = 2
    vm_size         = "Standard_DS1_v2"
    os_type         = "Linux"
    os_disk_size_gb = 30
  }
  linux_profile {
    admin_username = "inspecuser1"

    ssh_key {
      key_data = tls_private_key.key.public_key_openssh
    }
  }
  service_principal {
    client_id     = var.client_id
    client_secret = var.client_secret
  }
}


resource "azurerm_storage_account" "hdinsight_storage_account" {
  name                     = "hdinsight${random_string.storage_account.result}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "hdinsight_storage_container" {
  name                  = "hdinsight${random_string.storage_account.result}"
  storage_account_name  = azurerm_storage_account.hdinsight_storage_account.name
  container_access_type = "private"
}

resource "azurerm_hdinsight_interactive_query_cluster" "hdinsight_cluster" {
  count               = var.hd_insight_cluster_count
  name                = "hdinsight6fbw66f8ch"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  cluster_version     = "4.0"
  tier                = "Standard"

  component_version {
    interactive_hive = "3.1"
  }

  gateway {
    enabled  = true
    username = "inspec_test_user"
    password = "F8Sr'{DN"
  }

  storage_account {
    storage_container_id = azurerm_storage_container.hdinsight_storage_container.id
    storage_account_key  = azurerm_storage_account.hdinsight_storage_account.primary_access_key
    is_default           = true
  }

  roles {
    head_node {
      vm_size  = "STANDARD_D13_V2"
      username = "inspec_test_user_head"
      password = "r<u@8Kj#"
    }

    worker_node {
      vm_size               = "Standard_D14_V2"
      username              = "inspec_test_user_worker"
      password              = "ny'$YW5y"
      target_instance_count = 1
    }

    zookeeper_node {
      vm_size  = "Standard_A4_V2"
      username = "inspec_test_user_zookeeper"
      password = "Nv$h9g<d"
    }
  }
}

resource "azurerm_app_service_plan" "app_service_plan" {
  name                = "app-serv-plan-${random_pet.workspace.id}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  kind                = "Windows"

  sku {
    tier = "Free"
    size = "F1"
  }
}

resource "azurerm_app_service" "app_service" {
  name                = "app-serv-${random_pet.workspace.id}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  app_service_plan_id = azurerm_app_service_plan.app_service_plan.id
  https_only          = "true"

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_postgresql_server" "postgresql" {
  name                = "postgresql-srv-${random_string.sql.result}"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  sku {
    name     = "B_Gen5_2"
    capacity = 2
    tier     = "Basic"
    family   = "Gen5"
  }

  storage_profile {
    storage_mb            = 5120
    backup_retention_days = 7
    geo_redundant_backup  = "Disabled"
  }

  administrator_login          = "iazAdmin"
  administrator_login_password = "P4assw0rd!"
  version                      = "9.5"
  ssl_enforcement              = "Enabled"
}

resource "azurerm_postgresql_database" "postgresql" {
  name                = "postgresqldb${random_string.sql.result}"
  resource_group_name = azurerm_resource_group.rg.name
  server_name         = azurerm_postgresql_server.postgresql.name
  charset             = "UTF8"
  collation           = "English_United States.1252"
}

resource "random_string" "event_hub" {
  length  = 10
  special = false
  upper   = false
}

resource "azurerm_eventhub_namespace" "event_hub_namespace" {
  name                = "inspec${random_string.event_hub.result}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Standard"
  capacity            = 1
  kafka_enabled       = true
}

resource "azurerm_eventhub" "event_hub" {
  name                = "inspectesteh"
  namespace_name      = azurerm_eventhub_namespace.event_hub_namespace.name
  resource_group_name = azurerm_resource_group.rg.name
  partition_count     = 2
  message_retention   = 1
}

resource "azurerm_eventhub_authorization_rule" "auth_rule_inspectesteh" {
  name                = "inspectesteh_endpoint"
  namespace_name      = azurerm_eventhub_namespace.event_hub_namespace.name
  eventhub_name       = azurerm_eventhub.event_hub.name
  resource_group_name = azurerm_resource_group.rg.name
  listen              = false
  send                = true
  manage              = false
}

resource "azurerm_iothub" "iothub" {
  name                = "inspectest-iothub-${random_string.event_hub.result}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku {
    name     = "S1"
    tier     = "Standard"
    capacity = 1
  }


  endpoint {
    type                       = "AzureIotHub.EventHub"
    connection_string          = azurerm_eventhub_authorization_rule.auth_rule_inspectesteh.primary_connection_string
    name                       = "inspectesteh"
    batch_frequency_in_seconds = 300
    max_chunk_size_in_bytes    = 314572800
  }


  route {
    name      = "ExampleRoute"
    source    = "DeviceLifecycleEvents"
    condition = "true"
    endpoint_names = [
      "inspectesteh",
    ]
    enabled = true
  }
}

resource "azurerm_iothub_consumer_group" "inspecehtest_consumergroup" {
  name                   = "inspectest_consumer_group"
  iothub_name            = azurerm_iothub.iothub.name
  eventhub_endpoint_name = "events"
  resource_group_name    = azurerm_resource_group.rg.name
}

resource "random_string" "cosmo_db" {
  length  = 10
  special = false
  upper   = false
}

resource "azurerm_cosmosdb_account" "inspectest_cosmosdb" {
  name                = "inspec${random_string.cosmo_db.result}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  offer_type          = "Standard"
  kind                = "GlobalDocumentDB"

  consistency_policy {
    consistency_level       = "BoundedStaleness"
    max_interval_in_seconds = 10
    max_staleness_prefix    = 200
  }

  geo_location {
    prefix            = "inspectest-geo-prefix-${random_string.cosmo_db.result}"
    location          = azurerm_resource_group.rg.location
    failover_priority = 0
  }
}

resource "azurerm_virtual_network" "app-gw" {
  name                = "app-gw-network"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  address_space       = ["10.254.0.0/16"]
}

resource "azurerm_virtual_network_peering" "network_peering" {
  name                      = "virtual-network-peering-test"
  resource_group_name       = azurerm_resource_group.rg.name
  virtual_network_name      = azurerm_virtual_network.vnet.name
  remote_virtual_network_id = azurerm_virtual_network.app-gw.id
}

resource "azurerm_subnet" "frontend" {
  name                 = "frontend"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.app-gw.name
  address_prefix       = "10.254.0.0/24"
}

resource "azurerm_subnet" "backend" {
  name                 = "backend"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.app-gw.name
  address_prefix       = "10.254.2.0/24"
}

resource "azurerm_public_ip" "test" {
  name  = "example-pip"
  resource_group_name = azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location
  allocation_method = "Dynamic"
}

# since these variables are re-used - a locals block makes this more maintainable
locals {
  backend_address_pool_name      = "${azurerm_virtual_network.app-gw.name}-beap"
  frontend_port_name             = "${azurerm_virtual_network.app-gw.name}-feport"
  frontend_ip_configuration_name = "${azurerm_virtual_network.app-gw.name}-feip"
  http_setting_name              = "${azurerm_virtual_network.app-gw.name}-be-htst"
  listener_name                  = "${azurerm_virtual_network.app-gw.name}-httplstn"
  request_routing_rule_name      = "${azurerm_virtual_network.app-gw.name}-rqrt"
  redirect_configuration_name    = "${azurerm_virtual_network.app-gw.name}-rdrcfg"
}

resource "random_string" "appgw-random" {
  length  = 10
  special = false
  upper   = false
}

resource "azurerm_application_gateway" "network" {
  name                = "${random_string.appgw-random.result}-appgw"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  sku {
    name     = "Standard_Small"
    tier     = "Standard"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "my-gateway-ip-configuration"
    subnet_id = azurerm_subnet.frontend.id
  }

  frontend_port {
    name = local.frontend_port_name
    port = 443
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.test.id
  }

  backend_address_pool {
    name = local.backend_address_pool_name
  }

  backend_http_settings {
    name                  = local.http_setting_name
    cookie_based_affinity = "Disabled"
    path                  = "/path1/"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 1
  }

  ssl_certificate {
    name     = "inspec.example.com"
    data     = filebase64("app-gw/inspec.example.com.pfx")
    password = "InSpec1234"
  }

  http_listener {
    name                           = local.listener_name
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.frontend_port_name
    protocol                       = "Https"
    ssl_certificate_name           = "inspec.example.com"
  }

  request_routing_rule {
    name                        = local.request_routing_rule_name
    rule_type                   = "Basic"
    http_listener_name          = local.listener_name
    redirect_configuration_name = local.redirect_configuration_name
  }

  redirect_configuration {
    name          = local.redirect_configuration_name
    target_url    = "http://example.com"
    redirect_type = "Permanent"
  }

  ssl_policy {
    # https://docs.microsoft.com/en-us/azure/application-gateway/application-gateway-ssl-policy-overview
    # disabled_protocols   = ["TLSv1_0", "TLSv1_1"]
    # min_protocol_version = "TLSv1_2"
    policy_name = "AppGwSslPolicy20170401S"
    policy_type = "Predefined"
  }
}

resource "random_string" "ip-address-random" {
  length  = 10
  special = false
  upper   = false
}

resource "azurerm_public_ip" "public_ip_address" {
  count               = var.public_ip_count
  name                = random_string.ip-address-random.result
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
}

resource "random_string" "apim-random" {
  length  = 10
  special = false
  upper   = false
}

resource "azurerm_api_management" "apim01" {
  count               = var.api_management_count
  name                = "apim-${random_string.apim-random.result}"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  publisher_name      = "My Inspec"
  publisher_email     = "company@inspec.io"

  sku_name = "Developer_1"

  policy {
    xml_content = <<XML
    <policies>
      <inbound />
      <backend />
      <outbound />
      <on-error />
    </policies>
XML

  }
}
resource "azurerm_stream_analytics_job" "streaming_job" {
  name                                     = "job-for-streaming-function"
  resource_group_name                      = azurerm_resource_group.rg.name
  location                                 = var.location
  compatibility_level                      = "1.1"
  data_locale                              = "en-GB"
  events_late_arrival_max_delay_in_seconds = 60
  events_out_of_order_max_delay_in_seconds = 50
  events_out_of_order_policy               = "Adjust"
  output_error_policy                      = "Drop"
  streaming_units                          = 3

  tags = {
    user = terraform.workspace
  }

  transformation_query = <<QUERY
    SELECT *
    INTO [YourOutputAlias]
    FROM [YourInputAlias]
QUERY

}

resource "azurer_stream_analytics_function_javascript_udf" "streaming_job_function" {
  name                      = "javascript-script-for-streaming-function"
  stream_analytics_job_name = azurerm_stream_analytics_job.streaming_job.name
  resource_group_name       = azurerm_stream_analytics_job.streaming_job.resource_group_name

  script = <<SCRIPT
function getRandomNumber(in) {
  return in;
}
SCRIPT


  input {
    type = "bigint"
  }
  output {
    type = "bigint"
  }
}

variable "functionapp" {
  type = "string"
  default = "../test/fixtures/functionapp.zip"
}

data "azurerm_storage_account_sas" "sas" {
  connection_string = azurerm_storage_account.web_app_function_db.primary_connection_string
  https_only = true
  start = "2021-01-01"
  expiry = "2022-12-31"
  resource_types {
    object = true
    container = false
    service = false
  }
  services {
    blob = true
    queue = false
    table = false
    file = false
  }
  permissions {
    read = true
    write = false
    delete = false
    list = false
    add = false
    create = false
    update = false
    process = false
  }
}

resource "azurerm_storage_container" "sc_deployments" {
  name = "function-releases"
  storage_account_name = azurerm_storage_account.web_app_function_db.name
  container_access_type = "private"
}

resource "azurerm_storage_account" "web_app_function_db" {
  name                     = "functionsapp${random_string.storage_account.result}"
  location                 = var.location
  resource_group_name      = azurerm_resource_group.rg.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
  depends_on               = [azurerm_resource_group.rg]
  tags = {
    user = terraform.workspace
  }
}

resource "azurerm_redis_cache" "inspec_compliance_redis_cache" {
  name                = var.inspec_compliance_redis_cache_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  capacity            = 2
  family              = "C"
  sku_name            = "Standard"
  enable_non_ssl_port = false
  minimum_tls_version = "1.2"

  redis_configuration {
    maxfragmentationmemory_reserved = "50"
  }
}

resource "azurerm_storage_blob" "functioncode" {
  name = "functionapp.zip"
  storage_account_name = azurerm_storage_account.web_app_function_db.name
  storage_container_name = azurerm_storage_container.sc_deployments.name
  type = "block"
  source = var.functionapp
}

resource "azurerm_app_service_plan" "web_app_function_app_service" {
  name                = "functionsapp_service${random_pet.workspace.id}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tags = {
    user = terraform.workspace
  }

  sku {
    tier = "Free"
    size = "F1"
  }
}

resource "azurerm_function_app" "web_app_function" {
  name                       = "functions-function-app${random_pet.workspace.id}"
  location                   = azurerm_resource_group.rg.location
  resource_group_name        = azurerm_resource_group.rg.name
  app_service_plan_id        = azurerm_app_service_plan.web_app_function_app_service.id
  storage_connection_string  = azurerm_storage_account.web_app_function_db.primary_connection_string

  app_settings = {
    https_only = true
    FUNCTIONS_WORKER_RUNTIME = "node"
    WEBSITE_NODE_DEFAULT_VERSION = "~14"
    FUNCTION_APP_EDIT_MODE = "readonly"
    HASH = base64encode(filesha256(var.functionapp))
    WEBSITE_RUN_FROM_PACKAGE = "https://${azurerm_storage_account.web_app_function_db.name}.blob.core.windows.net/${azurerm_storage_container.sc_deployments.name}/${azurerm_storage_blob.functioncode.name}${data.azurerm_storage_account_sas.sas.sas}"
  }

  tags = {
    user = terraform.workspace
  }
}

resource "azurerm_container_group" "inspec_container_trial" {
  name                = var.inspec_container_group_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  ip_address_type     = "public"
  dns_name_label      = "inspec-container-trial-aci-label"
  os_type             = "Linux"

  container {
    name   = "hello-world-inspec"
    image  = "mcr.microsoft.com/azuredocs/aci-helloworld:latest"
    cpu    = "0.5"
    memory = "0.5"

    ports {
      port     = 443
      protocol = "TCP"
    }
  }

  container {
    name   = "setup-hw-tutorials"
    image  = "mcr.microsoft.com/azuredocs/aci-tutorial-sidecar"
    cpu    = "0.5"
    memory = "0.5"
  }

  tags = {
    environment = "inspec_trial"
  }
}

resource "azurerm_policy_definition" "inspec_policy_definition" {
  name = var.policy_definition_name
  policy_type = "Custom"
  mode = "All"
  display_name = var.policy_definition_display_name

  policy_rule = <<POLICY_RULE
    {
    "if": {
      "not": {
        "field": "location",
        "in": "[parameters('allowedLocations')]"
      }
    },
    "then": {
      "effect": "audit"
      }
    }
  POLICY_RULE

  parameters = <<PARAMETERS
    {
    "allowedLocations": {
      "type": "Array",
      "metadata": {
        "description": "The list of allowed locations for resources.",
        "displayName": "Allowed locations",
        "strongType": "location"
      }
    }
  }
  PARAMETERS

}

resource "azurerm_policy_assignment" "inspec_compliance_policy_assignment" {
  name = var.policy_assignment_name
  scope = azurerm_resource_group.rg.id
  policy_definition_id = azurerm_policy_definition.inspec_policy_definition.id
  description = var.policy_assignment_description
  display_name = var.policy_assignment_display_name

  parameters = <<PARAMETERS
    {
      "allowedLocations": {
        "value": [ "East US" ]
      }
    }
  PARAMETERS
}

resource "azurerm_bastion_host" "abh" {
  name = "test_bastion"
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  ip_configuration {
    name = "configuration"
    subnet_id = azurerm_subnet.subnet.id
    public_ip_address_id = azurerm_public_ip.public_ip_address.id
  }
}

resource "azurerm_network_ddos_protection_plan" "andpp" {
  name                = "example-protection-plan"
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_dns_zone" "example-public" {
  name                = "mydomain_example.com"
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_private_dns_zone" "example-private" {
  name                = "mydomain_example.com"
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_data_factory" "adf" {
  name                = "adf-eaxmple"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_data_factory_pipeline" "df_pipeline" {
  name                = "example-pipeline"
  resource_group_name = azurerm_resource_group.rg.name
  data_factory_name   = azurerm_data_factory.adf.name
}

resource "azurerm_data_factory_linked_service_mysql" "dflsmsql" {
  name                = "dflsm-sql"
  resource_group_name = azurerm_resource_group.rg.name
  data_factory_name   = azurerm_data_factory.adf.name
  connection_string   = "Server=test;Port=3306;Database=test;User=test;SSLMode=1;UseSystemTrustStore=0;Password=test"
}

// the resource itself is not yet available in tf because of this open issue
// https://github.com/terraform-providers/terraform-provider-azurerm/issues/9197
//resource "azurerm_policy_exemption" "inspec_compliance_policy_exemption" {
//  name                 = "AllowOutliers"
//  scope                = azurerm_resource_group.rg.id
//  exemption_category   = "Waiver"
//  display_name         = "Exempt Allowed locations"
//  description          = "Exempt resource group to run only inside the classified locations"
//  expires_on           = "2050-01-01T00:00:00"
//  policy_assignment_id = azurerm_policy_assignment.inspec_compliance_policy_assignment.id
//  policy_definition_reference_ids = [
//    "Limit_Skus"
//  ]
//}

resource "azurerm_database_migration_service" "inspec-compliance-migration-dev" {
  location = azurerm_resource_group.rg.location
  name = var.inspec_db_migration_service.name
  resource_group_name = azurerm_resource_group.rg.name
  sku_name = var.inspec_db_migration_service.sku_name
  subnet_id = azurerm_subnet.subnet.id
}

resource "azurerm_express_route_circuit" "express_route" {
  name                  = "expressRoute1"
  resource_group_name   = azurerm_resource_group.rg.name
  location              = azurerm_resource_group.rg.location
  service_provider_name = "Equinix"
  peering_location      = "Silicon Valley"
  bandwidth_in_mbps     = 50

  sku {
    tier   = "Standard"
    family = "MeteredData"
  }

  tags = {
    environment = "Production"
  }
}

resource "azurerm_virtual_wan" "inspec-nw-wan" {
  location = var.location
  name = var.inspec_wan_name
  resource_group_name = azurerm_resource_group.rg.name
}


resource "azurerm_virtual_network" "inspec-gw-vnw" {
  name                = "inspec-gw-vnw"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "inspec-gw-subnet" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.inspec-gw-vnw.name
  address_prefix     = "10.0.1.0/24"
}

resource "azurerm_virtual_network_gateway" "inspec-nw-gateway" {
  name                = "inspec-dev-vnw-gateway"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  type     = "Vpn"
  vpn_type = "RouteBased"

  active_active = false
  enable_bgp    = false
  sku           = "Basic"

  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.test.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.inspec-gw-subnet.id
  }

  vpn_client_configuration {
    address_space = ["10.2.0.0/24"]

    root_certificate {
      name = "DigiCert-Federated-ID-Root-CA"

      public_cert_data = <<EOF
MIIDuzCCAqOgAwIBAgIQCHTZWCM+IlfFIRXIvyKSrjANBgkqhkiG9w0BAQsFADBn
MQswCQYDVQQGEwJVUzEVMBMGA1UEChMMRGlnaUNlcnQgSW5jMRkwFwYDVQQLExB3
d3cuZGlnaWNlcnQuY29tMSYwJAYDVQQDEx1EaWdpQ2VydCBGZWRlcmF0ZWQgSUQg
Um9vdCBDQTAeFw0xMzAxMTUxMjAwMDBaFw0zMzAxMTUxMjAwMDBaMGcxCzAJBgNV
BAYTAlVTMRUwEwYDVQQKEwxEaWdpQ2VydCBJbmMxGTAXBgNVBAsTEHd3dy5kaWdp
Y2VydC5jb20xJjAkBgNVBAMTHURpZ2lDZXJ0IEZlZGVyYXRlZCBJRCBSb290IENB
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAvAEB4pcCqnNNOWE6Ur5j
QPUH+1y1F9KdHTRSza6k5iDlXq1kGS1qAkuKtw9JsiNRrjltmFnzMZRBbX8Tlfl8
zAhBmb6dDduDGED01kBsTkgywYPxXVTKec0WxYEEF0oMn4wSYNl0lt2eJAKHXjNf
GTwiibdP8CUR2ghSM2sUTI8Nt1Omfc4SMHhGhYD64uJMbX98THQ/4LMGuYegou+d
GTiahfHtjn7AboSEknwAMJHCh5RlYZZ6B1O4QbKJ+34Q0eKgnI3X6Vc9u0zf6DH8
Dk+4zQDYRRTqTnVO3VT8jzqDlCRuNtq6YvryOWN74/dq8LQhUnXHvFyrsdMaE1X2
DwIDAQABo2MwYTAPBgNVHRMBAf8EBTADAQH/MA4GA1UdDwEB/wQEAwIBhjAdBgNV
HQ4EFgQUGRdkFnbGt1EWjKwbUne+5OaZvRYwHwYDVR0jBBgwFoAUGRdkFnbGt1EW
jKwbUne+5OaZvRYwDQYJKoZIhvcNAQELBQADggEBAHcqsHkrjpESqfuVTRiptJfP
9JbdtWqRTmOf6uJi2c8YVqI6XlKXsD8C1dUUaaHKLUJzvKiazibVuBwMIT84AyqR
QELn3e0BtgEymEygMU569b01ZPxoFSnNXc7qDZBDef8WfqAV/sxkTi8L9BkmFYfL
uGLOhRJOFprPdoDIUBB+tmCl3oDcBy3vnUeOEioz8zAkprcb3GHwHAK+vHmmfgcn
WsfMLH4JCLa/tRYL+Rw/N3ybCkDp00s0WUZ+AoDywSl0Q/ZEnNY0MsFiw6LyIdbq
M/s/1JRtO3bDSzD9TazRVzn2oBqzSa8VgIo5C1nOnoAKJTlsClJKvIhnRlaLQqk=
EOF

    }

    revoked_certificate {
      name       = "Verizon-Global-Root-CA"
      thumbprint = "912198EEF23DCAC40939312FEE97DD560BAE49B1"
    }
  }
}

resource "azurerm_virtual_network_gateway_connection" "nw-gateway-connection" {
  name                = "inspec-nw-gateway-connection"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  type                            = "Vnet2Vnet"
  virtual_network_gateway_id      = azurerm_virtual_network_gateway.inspec-nw-gateway.id
  peer_virtual_network_gateway_id = azurerm_virtual_network_gateway.inspec-nw-gateway.id

  shared_key = "4-v3ry-53cr37-1p53c-5h4r3d-k3y"
}

resource "azurerm_storage_data_lake_gen2_filesystem" "inspec_adls_gen2" {
  name               = var.inspec_adls_file_system_name
  storage_account_id = azurerm_storage_account.sa.id

  properties = {
    inspec = "aGVsbG8="
  }
}

resource "azurerm_route_table" "route_table_sql_instance_inspec" {
  name                          = "routetable-inspec"
  location                      = azurerm_resource_group.rg.location
  resource_group_name           = azurerm_resource_group.rg.name
  disable_bgp_route_propagation = false
  depends_on = [
    azurerm_subnet.subnet,
  ]
}

resource "azurerm_subnet_route_table_association" "route_table_assoc_inspec" {
  subnet_id      = azurerm_subnet.subnet.id
  route_table_id = azurerm_route_table.route_table_sql_instance_inspec.id
}


resource "azurerm_sql_managed_instance" "sql_instance_for_inspec" {
  name                         = "sql-instance-for-inspec"
  resource_group_name          = azurerm_resource_group.rg.name
  location                     = azurerm_resource_group.rg.location
  administrator_login          = "inspec-admin"
  administrator_login_password = "Qwertyuiopasdfghjkl1"
  license_type                 = "BasePrice"
  subnet_id                    = azurerm_subnet.subnet.id
  sku_name                     = "GP_Gen5"
  vcores                       = 4
  storage_size_in_gb           = 32

  depends_on = [
    azurerm_subnet_network_security_group_association.subnet_nsg,
    azurerm_subnet_route_table_association.route_table_assoc_inspec,
  ]
}

resource "azurerm_mssql_virtual_machine" "inspec_sql_vm" {
  virtual_machine_id               = azurerm_virtual_machine.vm_windows_internal.id
  sql_license_type                 = "PAYG"
  r_services_enabled               = true
  sql_connectivity_port            = 1433
  sql_connectivity_type            = "PRIVATE"
  sql_connectivity_update_password = "Password1234!"
  sql_connectivity_update_username = "sqllogin"

  auto_patching {
    day_of_week                            = "Sunday"
    maintenance_window_duration_in_minutes = 60
    maintenance_window_starting_hour       = 2
  }
}