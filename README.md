# InSpec for Azure

This InSpec resource pack uses the Azure REST API and provides the required resources to write tests for resources in Azure.

## Prerequisites

* Ruby
* Bundler installed
* Azure Service Principal Account

Your Azure Service Principal Account must have `contributor` role to any subscription that you'd like to use this resource pack against. You should have the following pieces of information:

* TENANT_ID
* CLIENT_ID
* CLIENT_SECRET
* SUBSCRIPTION_ID

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

- [azure_monitor_log_profile](docs/resources/azure_monitor_log_profile.md.erb)
- [azure_monitor_log_profiles](docs/resources/azure_monitor_log_profiles.md.erb)
- [azurerm_monitor_activity_log_alert](docs/resources/azurerm_monitor_activity_log_alert.md.erb)
- [azurerm_monitor_activity_log_alerts](docs/resources/azurerm_monitor_activity_log_alerts.md.erb)
- [azurerm_network_security_group](docs/resources/azurerm_network_security_group.md.erb)
- [azurerm_network_security_groups](docs/resources/azurerm_network_security_groups.md.erb)
- [azurerm_network_watcher](docs/resources/azurerm_network_watcher.md.erb)
- [azurerm_network_watchers](docs/resources/azurerm_network_watchers.md.erb)
- [azurerm_resource_groups](docs/resources/azurerm_resource_groups.md.erb)
- [azurerm_security_center_policies](docs/resources/azurerm_security_center_policies.md.erb)
- [azurerm_security_center_policy](docs/resources/azurerm_security_center_policy.md.erb)
- [azurerm_virtual_machine](docs/resources/azurerm_virtual_machine.md.erb)
- [azurerm_virtual_machine_disk](docs/resources/azurerm_virtual_machine_disk.md.erb)
- [azurerm_virtual_machines](docs/resources/azurerm_virtual_machines.md.erb)


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

[Direnv](https://direnv.net/) is used to initial an environment variable `WORKSPACE` to your username. We recommend using `direnv` and allowing it to run in your environment. However, if you prefer to not use `direnv` you may also `source .envrc`.

### Remote State

Remote state is being used to store the Terraform state file. You'll need the following configuration keys to enable remote state:

```
TF_STORAGE_ACCOUNT_NAME=
TF_ACCESS_KEY=
TF_CONTAINER_NAME=$WORKSPACE
```

By convention `TF_CONTAINER_NAME` will always be your workspace name. To get started:

1. Log into Azure
2. Add a container matching your workspace name (likely whatever `whoami` resolves to on your machine, unless you overrode the default).
3. Ensure you update your `.envrc` with those new keys and your other account settings.
4. Either run `source .envrc` (or `direnv allow` if you use the direnv tool).
5. Now when you run `rake azure:login tf:apply` you should be initialized with remote state. If you have an existing state file Terraform may prompt you to upload the state from your machine to the container in Azure.

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
