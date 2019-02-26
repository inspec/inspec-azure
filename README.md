# InSpec for Azure

[![Build Status](https://travis-ci.org/inspec/inspec-azure.svg?branch=master)](https://travis-ci.org/inspec/inspec-azure)

This InSpec resource pack uses the Azure REST API and provides the required resources to write tests for resources in Azure.

## Prerequisites

* Ruby
* Bundler installed
* Azure Service Principal Account
* Azure Service Principal may read the Azure Active Directory

### Service Principal

Your Azure Service Principal Account must have `contributor` role to any subscription that you'd like to use this resource pack against. You should have the following pieces of information:

* TENANT_ID
* CLIENT_ID
* CLIENT_SECRET
* SUBSCRIPTION_ID

To create your account Service Principal Account:

1. Login to the Azure portal.
2. Click on `Azure Active Directory`.
3. Click on `APP registrations`.
4. Click on `New application registration`.
5. Fill in a name and a Sign-on URL. Select `Web app / API` from the `Application Type` drop down. Save your application.
6. Note your Application ID. This is your `client_id` above.
6. Click on `Settings`
7. Click on `Keys`
8. Create a new password. This value is your `client_secret` above.
9. Go to your subscription (click on `All Services` then subscriptions). Choose your subscription from that list.
11. Note your Subscription ID can be found here.
10. Click `Access Control (IAM)`
11. Click Add
13. Select the `contributor` role.
12. Select the application you just created and save.

These must be stored in a environment variables prefaced with `AZURE_`.  If you use Dotenv then you may save these values in your own `.envrc` file. Either source it or run `direnv allow`. If you don't use Dotenv then you may just create environment variables in the way that your prefer.

### Use the Resources

Since this is an InSpec resource pack, it only defines InSpec resources. To use these resources in your own controls you should create your own profile:

#### Create a new profile

```
$ inspec init profile my-profile
```
Example inspec.yml:
```
name: my-profile
title: My own Oneview profile
version: 0.1.0
inspec_version: '>= 2.2.7'
depends:
  - name: inspec-azure
    url: https://github.com/inspec/inspec-azure/archive/master.tar.gz
supports:
  - platform: azure
```

## Examples

Verify properties of an Azure VM

```
control 'azurerm_virtual_machine' do
  describe azurerm_virtual_machine(resource_group: 'MyResourceGroup', name: 'prod-web-01') do
    it                                { should exist }
    it                                { should have_monitoring_agent_installed }
    it                                { should_not have_endpoint_protection_installed([]) }
    it                                { should have_only_approved_extensions(['MicrosoftMonitoringAgent']) }
    its('type')                       { should eq 'Microsoft.Compute/virtualMachines' }
    its('installed_extensions_types') { should include('MicrosoftMonitoringAgent') }
    its('installed_extensions_names') { should include('LogAnalytics') }
  end
end
```

Verify properties of a security group

```
control 'azure_network_security_group' do
  describe azure_network_security_group(resource_group: 'ProductionResourceGroup', name: 'ProdServers') do
    it                            { should exist }
    its('type')                   { should eq 'Microsoft.Network/networkSecurityGroups' }
    its('security_rules')         { should_not be_empty }
    its('default_security_rules') { should_not be_empty }
    it                            { should_not allow_rdp_from_internet }
    it                            { should_not allow_ssh_from_internet }
  end
end
```

## Resource Documentation

The following resources are available in the InSpec Azure Resource Pack

- [azurerm_ad_user](docs/resources/azurerm_ad_user.md.erb)
- [azurerm_ad_users](docs/resources/azurerm_ad_users.md.erb)
- [azurerm_aks_cluster](docs/resources/azurerm_aks_cluster.md.erb)
- [azurerm_aks_clusters](docs/resources/azurerm_aks_clusters.md.erb)
- [azurerm_key_vault](docs/resources/azurerm_key_vault.md.erb)
- [azurerm_key_vault_key](docs/resources/azurerm_key_vault_key.md.erb)
- [azurerm_key_vault_keys](docs/resources/azurerm_key_vault_keys.md.erb)
- [azurerm_key_vault_secret](docs/resources/azurerm_key_vault_secret.md.erb)
- [azurerm_key_vault_secrets](docs/resources/azurerm_key_vault_secrets.md)
- [azurerm_key_vaults](docs/resources/azurerm_key_vaults.md.erb)
- [azurerm_monitor_activity_log_alert](docs/resources/azurerm_monitor_activity_log_alert.md.erb)
- [azurerm_monitor_activity_log_alerts](docs/resources/azurerm_monitor_activity_log_alerts.md.erb)
- [azurerm_monitor_log_profile](docs/resources/azurerm_monitor_log_profile.md.erb)
- [azurerm_monitor_log_profiles](docs/resources/azurerm_monitor_log_profiles.md.erb)
- [azurerm_network_security_group](docs/resources/azurerm_network_security_group.md.erb)
- [azurerm_network_security_groups](docs/resources/azurerm_network_security_groups.md.erb)
- [azurerm_network_watcher](docs/resources/azurerm_network_watcher.md.erb)
- [azurerm_network_watchers](docs/resources/azurerm_network_watchers.md.erb)
- [azurerm_resource_groups](docs/resources/azurerm_resource_groups.md.erb)
- [azurerm_security_center_policies](docs/resources/azurerm_security_center_policies.md.erb)
- [azurerm_security_center_policy](docs/resources/azurerm_security_center_policy.md.erb)
- [azurerm_sql_database](docs/resources/azurerm_sql_database.md.erb)
- [azurerm_sql_databases](docs/resources/azurerm_sql_databases.md.erb)
- [azurerm_sql_server](docs/resources/azurerm_sql_server.md.erb)
- [azurerm_sql_servers](docs/resources/azurerm_sql_servers.md.erb)
- [azurerm_storage_account_blob_container](docs/resources/azurerm_storage_account_blob_container.md.erb)
- [azurerm_storage_account_blob_containers](docs/resources/azurerm_storage_account_blob_containers.md.erb)
- [azurerm_subnet](docs/resources/azurerm_subnet.md.erb)
- [azurerm_subnets](docs/resources/azurerm_subnets.md.erb)
- [azurerm_virtual_machine](docs/resources/azurerm_virtual_machine.md.erb)
- [azurerm_virtual_machine_disk](docs/resources/azurerm_virtual_machine_disk.md.erb)
- [azurerm_virtual_machines](docs/resources/azurerm_virtual_machines.md.erb)
- [azurerm_virtual_network](docs/resources/azurerm_virtual_network.md.erb)
- [azurerm_virtual_networks](docs/resources/azurerm_virtual_networks.md.erb)

## Connectors

See [Connectors](docs/reference/connectors.md) for more information on the different connection strategies we support.

## Development

If you'd like to contribute to this project please see [Contributing Rules](CONTRIBUTING.md). The following instructions will help you get your development environment setup to run integration tests.

### Getting Started

Copy `.envrc-example` to `.envrc` and fill in the fields with the values from your account.
```
export AZURE_SUBSCRIPTION_ID=<subscription id>
export AZURE_CLIENT_ID=<client id>
export AZURE_TENANT_ID=<tenant id>
export AZURE_CLIENT_SECRET=<client secret>
```

For PowerShell, set the following environment variables
```
$env:AZURE_SUBSCRIPTION_ID="<subscription id>"
$env:AZURE_CLIENT_ID="<client id>"
$env:AZURE_CLIENT_SECRET="<tenant id>"
$env:AZURE_TENANT_ID="<client secret>"
```

**Setup Azure CLI**
- Follow the instructions for your platform [here](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
  * macOS: `brew update && brew install azure-cli`
- Login with the azure-cli
  * `rake azure:login`
- Verify azure-cli is logged in:
  * `az account show`

### Starting an Environment

First ensure your system has [Terraform](https://www.terraform.io/intro/getting-started/install.html) (Version 0.11.7) installed.

This environment may be used to run your profile against or to run integration tests on it. We are using [Terraform workspaces](https://www.terraform.io/docs/state/workspaces.html) to allow for teams to have completely unique environments without affecting each other.

### Direnv

[Direnv](https://direnv.net/) is used to initialize an environment variable `WORKSPACE` to your username. We recommend using `direnv` and allowing it to run in your environment. However, if you prefer to not use `direnv` you may also `source .envrc`.

### Remote State

Remote state has been removed. The first time you run Terraform after having
remote state removed you will be presented with a message like:

```
Do you want to migrate all workspaces to "local"?
  Both the existing "azurerm" backend and the newly configured "local" backend support
  workspaces. When migrating between backends, Terraform will copy all
  workspaces (with the same names). THIS WILL OVERWRITE any conflicting
  states in the destination.

  Terraform initialization doesn't currently migrate only select workspaces.
  If you want to migrate a select number of workspaces, you must manually
  pull and push those states.

  If you answer "yes", Terraform will migrate all states. If you answer
  "no", Terraform will abort.

  Enter a value: yes
```

Enter yes or press enter.

### Rake commands

Creating a new environment:
```
rake azure:login
rake tf:apply
```

Creating a new environment with a Network Watcher:
```
rake azure:login
rake network_watcher tf:apply
```
You may only have a single Network Watcher per a subscription. Use this carefully if you are working with other team members.

Updating a running environment (e.g. when you change the .tf file):
```
rake azure:login
rake tf:apply
```

Checking if your state has diverged from your plan:
```
rake azure:login
rake tf:plan
```

Destroying your environment:
```
rake azure:login
rake tf:destroy
```

### Running integration tests

To start up an environment and run all tests:
```
bundle
rake azure:login
rake azure
```

### Development

To run all tests:
```
bundle
rake
```

To run integration tests:
```
bundle
rake test:integration
```

To run integration tests including a Network Watcher:
```
bundle
rake network_watcher test:integration
```

To run a control called `azurerm_virtual_machine`:
```
bundle
rake test:integration[azurerm_virtual_machine]
```

You may run multiple controls:
```
bundle
rake test:integration[azure_resource_group,azurerm_virtual_machine]
```

### Optional Components

By default, rake tasks will only use core components. Optional components have
associated integrations that will be skipped unless you enable these. We have
the following optional pieces that may be managed with Terraform.

#### Network Watcher

Network Watcher may be enabled to run integration tests related to the Network
Watcher. We recommend leaving this disabled unless you are specifically working
on related resources. You may only have one Network Watcher enabled per an
Azure subscription at a time. To enable Network Watcher:

```
rake options[network_watcher]
direnv allow # or source .envrc
rake tf:apply
```

#### Graph API

Graph API support may be enabled to test with `azure_ad` related resources.
Graph requires granting "Active Directory Read" to the Service Principal. If
your account does not have access leave this disabled.

Please refer to the [Microsoft
Documentation](https://docs.microsoft.com/en-us/azure/active-directory/develop/active-directory-integrating-applications#updating-an-application)
for information on how to grant these permissions to your application.

Note: An Azure Administrator must grant your application these permissions.

```
rake options[graph]
direnv allow # or source .envrc
rake tf:apply
```

#### Managed Service Identity

Managed Service Identity (MSI) is another way to connect to the Azure APIs.
This option starts an additonal virtual machine with MSI enabled and a public
ip address. You will need to put a hole in your firewall to connect to the
virtual machine. You will also need to grant the `contributor` role to this
identity for your subscription.

```
rake options[msi]
direnv allow # or source .envrc
rake tf:apply
```

#### Using optional components

Optional Components may be combined when running tasks:

```
rake options[option_1,option_2,option3]
direnv allow # or source .envrc
rake tf:apply
```

To disable optional components run `rake options[]` including only the optional components you wish to enable. Any omitted component will be disabled.
```
rake options[] # disable all optional components
rake options[option_1] # enables option_1 disabling all other optional components
```

