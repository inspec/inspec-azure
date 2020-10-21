# InSpec for Azure

* **Project State: Maintained**

For more information on project states and SLAs, see [this documentation](https://github.com/chef/chef-oss-practices/blob/master/repo-management/repo-states.md).

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
5. Fill in a name and select `Web` from the `Application Type` drop down. Save your application.
6. Note your Application ID. This is your `client_id` above.
7. Click on `Certificates & secrets`
8. Click on `New client secret`
9. Create a new password. This value is your `client_secret` above.
10. Go to your subscription (click on `All Services` then subscriptions). Choose your subscription from that list.
11. Note your Subscription ID can be found here.
12. Click `Access control (IAM)`
13. Click Add
14. Select the `contributor` role.
15. Select the application you just created and save.

These must be stored in a environment variables prefaced with `AZURE_`.  If you use Dotenv then you may save these values in your own `.envrc` file. 
Either source it or run `direnv allow`. If you don't use Dotenv then you may just create environment variables in the way that your prefer.

### Use the Resources

Since this is an InSpec resource pack, it only defines InSpec resources. To use these resources in your own controls you should create your own profile:

#### Create a new profile

```
$ inspec init profile --platform azure my-profile
```

Example inspec.yml:

```yaml
name: my-profile
title: My own Azure profile
version: 0.1.0
inspec_version: '>= 4.6.9'
depends:
  - name: inspec-azure
    url: https://github.com/inspec/inspec-azure/archive/x.tar.gz
supports:
  - platform: azure
```

(For available inspec-azure versions, see this list of [inspec-azure versions](https://github.com/inspec/inspec-azure/releases).)

## Resource Documentation

The following is a list of generic resources.

- [azure_generic_resource](docs/resources/azure_generic_resource.md)
- [azure_generic_resources](docs/resources/azure_generic_resources.md)
- [azure_graph_generic_resource](docs/resources/azure_graph_generic_resource.md)
- [azure_graph_generic_resources](docs/resources/azure_graph_generic_resources.md)
 
With the generic resources:

- Azure cloud resources that this resource pack does not include a static InSpec resource for can be tested.
- Azure resources from different resource providers and resource groups can be tested at the same time.
- Server side filtering can be used for more efficient tests.
 
The following is a list of static resources. 
The static resources derived from the generic resources prepended with `azure_` are fully backward compatible with their `azurerm_` counterparts. 

- [azure_aks_cluster](docs/resources/azure_aks_cluster.md)
- [azure_aks_clusters](docs/resources/azure_aks_clusters.md)
- [azure_api_management](docs/resources/azure_api_management.md)
- [azure_api_managements](docs/resources/azure_api_managements.md)
- [azure_application_gateway](docs/resources/azure_application_gateway.md)
- [azure_application_gateways](docs/resources/azure_application_gateways.md)
- [azure_cosmosdb_database_account](docs/resources/azure_cosmosdb_database_account.md)
- [azure_event_hub_authorization_rule](docs/resources/azure_event_hub_authorization_rule.md)
- [azure_event_hub_event_hub](docs/resources/azure_event_hub_event_hub.md)
- [azure_event_hub_namespace](docs/resources/azure_event_hub_namespace.md)
- [azure_hdinsight_cluster](docs/resources/azure_hdinsight_cluster.md)
- [azure_iothub](docs/resources/azure_iothub.md)
- [azure_iothub_event_hub_consumer_group](docs/resources/azure_iothub_event_hub_consumer_group.md)
- [azure_iothub_event_hub_consumer_groups](docs/resources/azure_iothub_event_hub_consumer_groups.md)
- [azure_graph_user](docs/resources/azure_graph_user.md)
- [azure_graph_users](docs/resources/azure_graph_users.md)
- [azure_key_vault](docs/resources/azure_key_vault.md)
- [azure_key_vaults](docs/resources/azure_key_vaults.md)
- [azure_load_balancer](docs/resources/azure_load_balancer.md)
- [azure_load_balancers](docs/resources/azure_load_balancers.md)
- [azure_lock](docs/resources/azure_lock.md)
- [azure_locks](docs/resources/azure_locks.md)
- [azure_mariadb_server](docs/resources/azure_mariadb_server.md)
- [azure_mariadb_servers](docs/resources/azure_mariadb_servers.md)
- [azure_monitor_activity_log_alert](docs/resources/azure_monitor_activity_log_alert.md)
- [azure_monitor_activity_log_alerts](docs/resources/azure_monitor_activity_log_alerts.md)
- [azure_monitor_log_profile](docs/resources/azure_monitor_log_profile.md)
- [azure_monitor_log_profiles](docs/resources/azure_monitor_log_profiles.md)
- [azure_mysql_database](docs/resources/azure_mysql_database.md)
- [azure_mysql_databases](docs/resources/azure_mysql_databases.md)
- [azure_mysql_server](docs/resources/azure_mysql_server.md)
- [azure_mysql_servers](docs/resources/azure_mysql_servers.md)
- [azure_network_interface](docs/resources/azure_network_interface.md)
- [azure_network_interfaces](docs/resources/azure_network_interfaces.md)
- [azure_network_security_group](docs/resources/azure_network_security_group.md)
- [azure_network_security_groups](docs/resources/azure_network_security_groups.md)
- [azure_policy_definition](docs/resources/azure_policy_definition.md)
- [azure_policy_definitions](docs/resources/azure_policy_definitions.md)
- [azure_postgresql_database](docs/resources/azure_postgresql_database.md)
- [azure_postgresql_databases](docs/resources/azure_postgresql_databases.md)
- [azure_postgresql_server](docs/resources/azure_postgresql_server.md)
- [azure_postgresql_servers](docs/resources/azure_postgresql_servers.md)
- [azure_public_ip](docs/resources/azure_public_ip.md)
- [azure_resource_group](docs/resources/azure_resource_group.md)
- [azure_resource_groups](docs/resources/azure_resource_groups.md)
- [azure_role_definition](docs/resources/azure_role_definition.md)
- [azure_role_definitions](docs/resources/azure_role_definitions.md)
- [azure_security_center_policies](docs/resources/azure_security_center_policies.md)
- [azure_security_center_policy](docs/resources/azure_security_center_policy.md)
- [azure_sql_database](docs/resources/azure_sql_database.md)
- [azure_sql_databases](docs/resources/azure_sql_databases.md)
- [azure_sql_server](docs/resources/azure_sql_server.md)
- [azure_sql_servers](docs/resources/azure_sql_servers.md)
- [azure_storage_account_blob_container](docs/resources/azure_storage_account_blob_container.md)
- [azure_storage_account_blob_containers](docs/resources/azure_storage_account_blob_containers.md)
- [azure_subnet](docs/resources/azure_subnet.md)
- [azure_subnets](docs/resources/azure_subnets.md)
- [azure_subscription](docs/resources/azure_subscription.md)
- [azure_subscriptions](docs/resources/azure_subscriptions.md)
- [azure_virtual_machine](docs/resources/azure_virtual_machine.md)
- [azure_virtual_machines](docs/resources/azure_virtual_machines.md)
- [azure_virtual_machine_disk](docs/resources/azure_virtual_machine_disk.md)
- [azure_virtual_machine_disks](docs/resources/azure_virtual_machine_disks.md)
- [azure_virtual_network](docs/resources/azure_virtual_network.md)
- [azure_virtual_networks](docs/resources/azure_virtual_networks.md)


    
For more details and different use cases, please refer to the specific resource pages.

## Examples

### Interrogate All Resources that Have `project_A` in Their Names within Your Subscription Regardless of Their Type and Resource Group  
  
```ruby
azure_generic_resources(substring_of_name: 'project_A').ids.each do |id|
  describe azure_generic_resource(resource_id: id) do
    its('location') { should eq 'eastus' }
  end
end
``` 

### Interrogate All Resources that Have a Tag Defined with the Name `project_A` Regardless of its Value
    
```ruby
azure_generic_resources(tag_name: 'project_A').ids.each do |id|
  describe azure_generic_resource(resource_id: id) do
    its('location') { should eq 'eastus' }
  end
end
``` 

### Verify Properties of an Azure Virtual Machine

```ruby
describe azure_virtual_machine(resource_group: 'MyResourceGroup', name: 'prod-web-01') do
  it { should exist }
  it { should have_monitoring_agent_installed }
  it { should_not have_endpoint_protection_installed([]) }
  it { should have_only_approved_extensions(['MicrosoftMonitoringAgent']) }
  its('type') { should eq 'Microsoft.Compute/virtualMachines' }
  its('installed_extensions_types') { should include('MicrosoftMonitoringAgent') }
  its('installed_extensions_names') { should include('LogAnalytics') }
end
```

### Verify Properties of a Network Security Group

```ruby
describe azure_network_security_group(resource_group: 'ProductionResourceGroup', name: 'ProdServers') do
  it { should exist }
  its('type') { should eq 'Microsoft.Network/networkSecurityGroups' }
  its('security_rules') { should_not be_empty }
  its('default_security_rules') { should_not be_empty }
  it { should_not allow_rdp_from_internet }
  it { should_not allow_ssh_from_internet }
  it { should allow(source_ip_range: '0.0.0.0', destination_port: '22', direction: 'inbound') }
  it { should allow_in(service_tag: 'Internet', port: %w{1433-1434 1521 4300-4350 5000-6000}) } 
end
```

## Parameters Applicable To All Resources 

The generic resources and their derivations support following parameters unless stated otherwise in their specific resource page.

### `api_version`

As an Azure resource provider enables new features, it releases a new version of the REST API. They are generally in the format of `2020-01-01`.
InSpec Azure resources can be forced to use a specific version of the API to eliminate the behavioural changes between the tests using different API versions.
The latest version will be used unless a specific version is provided.

```ruby
describe azure_virtual_machine(resource_group: 'my_group', name: 'my_VM', api_version: '2020-01-01') do
  its('api_version_used_for_query_state') { should eq 'user_provided' }
  its('api_version_used_for_query') { should eq '2020-01-01' }
end

# `default` api version can be used if it is supported by the resource provider.
describe azure_generic_resource(resource_provider: 'Microsoft.Compute/virtualMachines', name: 'my_VM', api_version: 'default') do
  its('api_version_used_for_query_state') { should eq 'default' }
end

# `latest` version will be used if it is not provided
describe azure_virtual_networks do
  its('api_version_used_for_query_state') { should eq 'latest' }
end

# `latest` version will be used if the provided is invalid
describe azure_network_security_groups(resource_group: 'my_group', api_version: 'invalid_api_version') do
  its('api_version_used_for_query_state') { should eq 'latest' }
end
```

### `endpoint`

Microsoft Azure cloud services are available through a global and three national network of datacenter as described [here](https://docs.microsoft.com/en-us/graph/deployments).
The preferred data center can be defined via `endpoint` parameter.
Azure Global Cloud will be used if not provided.

- `azure_cloud` (default)
- `azure_china_cloud`
- `azure_us_government_L4`
- `azure_us_government_L5`
- `azure_german_cloud`

```ruby
describe azure_virtual_machines(endpoint: 'azure_german_cloud') do
  it { should exist }
end
```

It can be defined as an environment variable or a resource parameter (has priority).

The predefined environment variables for each cloud deployments can be found [here](libraries/backend/helpers.rb#L64).

### http_client parameters

The behavior of the http client can be defined with the following parameters:

- `azure_retry_limit`: Maximum number of retries (default - `2`, Integer).
- `azure_retry_backoff`: Pause in seconds between retries (default - `0`, Integer).
- `azure_retry_backoff_factor`: The amount to multiply each successive retry's interval amount by (default - `1`, Integer).

They can be defined as environment variables or resource parameters (has priority).

<hr>

> <b>WARNING</b> The following resources do not support **api_version**, **endpoint** and **http_client** parameters and they will be deprecated in the InSpec Azure version **2**. 

- [azurerm_ad_user](docs/resources/azurerm_ad_user.md)
- [azurerm_ad_users](docs/resources/azurerm_ad_users.md)
- [azurerm_aks_cluster](docs/resources/azurerm_aks_cluster.md)
- [azurerm_aks_clusters](docs/resources/azurerm_aks_clusters.md)
- [azurerm_api_management](docs/resources/azurerm_api_management.md)
- [azurerm_api_managements](docs/resources/azurerm_api_managements.md)
- [azurerm_application_gateway](docs/resources/azurerm_application_gateway.md)
- [azurerm_application_gateways](docs/resources/azurerm_application_gateways.md)
- [azurerm_cosmosdb_database_account](docs/resources/azurerm_cosmosdb_database_account.md)
- [azurerm_event_hub_authorization_rule](docs/resources/azurerm_event_hub_authorization_rule.md)
- [azurerm_event_hub_event_hub](docs/resources/azurerm_event_hub_event_hub.md)
- [azurerm_event_hub_namespace](docs/resources/azurerm_event_hub_namespace.md)
- [azurerm_hdinsight_cluster](docs/resources/azurerm_hdinsight_cluster.md)
- [azurerm_iothub](docs/resources/azurerm_iothub.md)
- [azurerm_iothub_event_hub_consumer_group](docs/resources/azurerm_iothub_event_hub_consumer_group.md)
- [azurerm_iothub_event_hub_consumer_groups](docs/resources/azurerm_iothub_event_hub_consumer_groups.md)
- [azurerm_key_vault](docs/resources/azurerm_key_vault.md)
- [azurerm_key_vault_key](docs/resources/azurerm_key_vault_key.md)
- [azurerm_key_vault_keys](docs/resources/azurerm_key_vault_keys.md)
- [azurerm_key_vault_secret](docs/resources/azurerm_key_vault_secret.md)
- [azurerm_key_vault_secrets](docs/resources/azurerm_key_vault_secrets.md)
- [azurerm_key_vaults](docs/resources/azurerm_key_vaults.md)
- [azurerm_load_balancer](docs/resources/azurerm_load_balancer.md)
- [azurerm_load_balancers](docs/resources/azurerm_load_balancers.md)
- [azurerm_locks](docs/resources/azurerm_locks.md)
- [azurerm_management_group](docs/resources/azurerm_management_group.md)
- [azurerm_management_groups](docs/resources/azurerm_management_groups.md)
- [azurerm_mariadb_server](docs/resources/azurerm_mariadb_server.md)
- [azurerm_mariadb_servers](docs/resources/azurerm_mariadb_servers.md)
- [azurerm_monitor_activity_log_alert](docs/resources/azurerm_monitor_activity_log_alert.md)
- [azurerm_monitor_activity_log_alerts](docs/resources/azurerm_monitor_activity_log_alerts.md)
- [azurerm_monitor_log_profile](docs/resources/azurerm_monitor_log_profile.md)
- [azurerm_monitor_log_profiles](docs/resources/azurerm_monitor_log_profiles.md)
- [azurerm_mysql_database](docs/resources/azurerm_mysql_database.md)
- [azurerm_mysql_databases](docs/resources/azurerm_mysql_databases.md)
- [azurerm_mysql_server](docs/resources/azurerm_mysql_server.md)
- [azurerm_mysql_servers](docs/resources/azurerm_mysql_servers.md)
- [azurerm_network_interface](docs/resources/azurerm_network_interface.md)
- [azurerm_network_interfaces](docs/resources/azurerm_network_interfaces.md)
- [azurerm_network_security_group](docs/resources/azurerm_network_security_group.md)
- [azurerm_network_security_groups](docs/resources/azurerm_network_security_groups.md)
- [azurerm_network_watcher](docs/resources/azurerm_network_watcher.md)
- [azurerm_network_watchers](docs/resources/azurerm_network_watchers.md)
- [azurerm_postgresql_database](docs/resources/azurerm_postgresql_database.md)
- [azurerm_postgresql_databases](docs/resources/azurerm_postgresql_databases.md)
- [azurerm_postgresql_server](docs/resources/azurerm_postgresql_server.md)
- [azurerm_postgresql_servers](docs/resources/azurerm_postgresql_servers.md)
- [azurerm_public_ip](docs/resources/azurerm_public_ip.md)
- [azurerm_resource_groups](docs/resources/azurerm_resource_groups.md)
- [azurerm_role_definition](docs/resources/azurerm_role_definition.md)
- [azurerm_role_definitions](docs/resources/azurerm_role_definitions.md)
- [azurerm_security_center_policies](docs/resources/azurerm_security_center_policies.md)
- [azurerm_security_center_policy](docs/resources/azurerm_security_center_policy.md)
- [azurerm_sql_database](docs/resources/azurerm_sql_database.md)
- [azurerm_sql_databases](docs/resources/azurerm_sql_databases.md)
- [azurerm_sql_server](docs/resources/azurerm_sql_server.md)
- [azurerm_sql_servers](docs/resources/azurerm_sql_servers.md)
- [azurerm_storage_account_blob_container](docs/resources/azurerm_storage_account_blob_container.md)
- [azurerm_storage_account_blob_containers](docs/resources/azurerm_storage_account_blob_containers.md)
- [azurerm_subnet](docs/resources/azurerm_subnet.md)
- [azurerm_subnets](docs/resources/azurerm_subnets.md)
- [azurerm_subscription](docs/resources/azurerm_subscription.md)
- [azurerm_virtual_machine](docs/resources/azurerm_virtual_machine.md)
- [azurerm_virtual_machine_disk](docs/resources/azurerm_virtual_machine_disk.md)
- [azurerm_virtual_machine_disks](docs/resources/azurerm_virtual_machine_disks.md)
- [azurerm_virtual_machines](docs/resources/azurerm_virtual_machines.md)
- [azurerm_virtual_network](docs/resources/azurerm_virtual_network.md)
- [azurerm_virtual_networks](docs/resources/azurerm_virtual_networks.md)
- [azurerm_webapp](docs/resources/azurerm_webapp.md)
- [azurerm_webapps](docs/resources/azurerm_webapps.md)

## Connectors

See [Connectors](docs/reference/connectors.md) for more information on the different connection strategies we support.

## Development

If you'd like to contribute to this project please see [Contributing Rules](CONTRIBUTING.md). 

### Developing a Static Resource

The easiest way to start is checking the existing static resources. They have detailed information on how to leverage the backend class within their comments.

The common parameters are:
- `resource_provider`: Such as `Microsoft.Compute/virtualMachines`. It has to be hardcoded in the code by the resource author via the `specific_resource_constraint` method, and it should be the first parameter defined in the resource. This method includes user-supplied input validation.  
- `display_name`: A generic one will be created unless defined.
- `required_parameters`: Define mandatory parameters. The `resource_group` and resource `name` in the singular resources are default mandatory in the base class.
- `allowed_parameters`: Define optional parameters. The `resource_group` is default optional in plural resources, but this can be made mandatory in the static resource. 
- `resource_uri`: Azure REST API URI of a resource. This parameter should be used when a resource does not reside in a resource group. It requires `add_subscription_id` to be set to either `true` or `false`. See [azure_policy_definition](libraries/azure_policy_definition.rb) and [azure_policy_definitions](libraries/azure_policy_definitions.rb).
- `add_subscription_id`: It indicates whether the subscription ID should be included in the `resource_uri` or not.

For a detailed walk-through of resource creation, see the [Resource Creation Guide](docs/resource_creation_guide.md).

### Singular Resources

- In most cases `resource_group` and resource `name` should be required from the users and a single API call would be enough for creating methods on the resource. See [azure_virtual_machine](libraries/azure_virtual_machine.rb) for a standard singular resource and how to create static methods from resource properties.
- If it is beneficial to accept the resource name with a more specific keyword, such as `server_name`, see [azure_mysql_server](libraries/azure_mysql_server.rb).
- If a resource exists in another resource, such as a subnet on a virtual network, see [azure_subnet](libraries/azure_subnet.rb).
- If it is necessary to make an additional API call within a static method, the `create_additional_properties` should be used. See [azure_key_vault](libraries/azure_key_vault.rb). 

### Plural Resources

- A standard plural resource does not require a parameter, except optional `resource_group`. See [azure_mysql_servers](libraries/azure_mysql_servers.rb).
- All plural resources use [FilterTable](https://github.com/inspec/inspec/blob/master/docs/dev/filtertable-usage.md) to be able to provide filtering within returned resources. The filter criteria must be defined `table_schema` Hash variable.
- If the properties of the resource are to be manipulated before populating the FilterTable, a `populate_table` method has to be defined. See [azure_virtual_machines](libraries/azure_virtual_machines.rb).
- If the resources exist in another resource, such as subnets of a virtual network, a `resource_path` has to be created. For that, the identifiers of the parent resource, `resource_group` and virtual network name `vnet`, must be required from the users. See [azure_subnets](libraries/azure_subnets.rb).

The following instructions will help you get your development environment setup to run integration tests.

### Setting the Environment Variables

Copy `.envrc-example` to `.envrc` and fill in the fields with the values from your account.

```bash
export AZURE_SUBSCRIPTION_ID=<subscription id>
export AZURE_CLIENT_ID=<client id>
export AZURE_TENANT_ID=<tenant id>
export AZURE_CLIENT_SECRET=<client secret>
```

For PowerShell, set the following environment variables

```
$env:AZURE_SUBSCRIPTION_ID="<subscription id>"
$env:AZURE_CLIENT_ID="<client id>"
$env:AZURE_CLIENT_SECRET="<client secret>"
$env:AZURE_TENANT_ID="<tenant id>"
```

**Setup Azure CLI**

- Follow the instructions for your platform [here](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
  * macOS: `brew update && brew install azure-cli`
- Login with the azure-cli
  * `rake azure:login`
- Verify azure-cli is logged in:
  * `az account show`

### Starting an Environment

First ensure your system has [Terraform](https://www.terraform.io/intro/getting-started/install.html) (Version 0.12.0) installed.

This environment may be used to run your profile against or to run integration tests on it. We are using [Terraform workspaces](https://www.terraform.io/docs/state/workspaces.html) to allow for teams to have completely unique environments without affecting each other.

### Direnv

[Direnv](https://direnv.net/) is used to initialize an environment variable `WORKSPACE` to your username. We recommend using `direnv` and allowing it to run in your environment. However, if you prefer to not use `direnv` you may also `source .envrc`.

### Remote State

Remote state has been removed. The first time you run Terraform after having remote state removed you will be presented with a message like:

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
To run Rubocop and Syntax check for Ruby and InSpec:
```
rake test:lint
```
To run unit tests:
```
rake test:unit
```
To run integration tests:
```
rake test:integration
```
To run lint and unit tests:
```
rake
```
To run integration tests including a Network Watcher:
```
rake network_watcher test:integration
```
### Optional Components

By default, rake tasks will only use core components. Optional components have associated integrations that will be skipped unless you enable these. We have the following optional pieces that may be managed with Terraform.

#### Network Watcher

Network Watcher may be enabled to run integration tests related to the Network Watcher. We recommend leaving this disabled unless you are specifically working on related resources. You may only have one Network Watcher enabled per an Azure subscription at a time. To enable Network Watcher:

```
rake options[network_watcher]
direnv allow # or source .envrc
rake tf:apply
```

#### Graph API

Graph API support may be enabled to test with `azure_graph` related resources.
Each resource requires specific privileges granted to your service principal.
Please refer to the [Microsoft Documentation](https://docs.microsoft.com/en-us/azure/active-directory/develop/active-directory-integrating-applications#updating-an-application) for information on how to grant these permissions to your application.
If your account does not have access, leave this disabled.

Note: An Azure Administrator must grant your application these permissions.

```
rake options[graph]
direnv allow # or source .envrc
rake tf:apply
```

#### Managed Service Identity

Managed Service Identity (MSI) is another way to connect to the Azure APIs.
This option starts an additional virtual machine with MSI enabled and a public ip address. You will need to put a hole in your firewall to connect to the virtual machine. You will also need to grant the `contributor` role to this identity for your subscription.

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
