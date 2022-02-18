# InSpec for Azure

* **Project State: Maintained**

For more information on project states and SLAs, see [this documentation](https://github.com/chef/chef-oss-practices/blob/master/repo-management/repo-states.md).

[![Build Status](https://travis-ci.org/inspec/inspec-azure.svg?branch=master)](https://travis-ci.org/inspec/inspec-azure)

This InSpec resource pack uses the Azure REST API and provides the required resources to write tests for resources in Azure.

## Table of Contents

- [InSpec for Azure](#inspec-for-azure)
  - [Table of Contents](#table-of-contents)
  - [Prerequisites](#prerequisites)
    - [Service Principal](#service-principal)
    - [Use the Resources](#use-the-resources)
      - [Create a new profile](#create-a-new-profile)
  - [Resource Documentation](#resource-documentation)
  - [Examples](#examples)
    - [Interrogate All Resources that Have `project_A` in Their Names within Your Subscription Regardless of Their Type and Resource Group](#interrogate-all-resources-that-have-project_a-in-their-names-within-your-subscription-regardless-of-their-type-and-resource-group)
    - [Interrogate All Resources that Have a Tag Defined with the Name `project_A` Regardless of its Value](#interrogate-all-resources-that-have-a-tag-defined-with-the-name-project_a-regardless-of-its-value)
    - [Verify Properties of an Azure Virtual Machine](#verify-properties-of-an-azure-virtual-machine)
    - [Verify Properties of a Network Security Group](#verify-properties-of-a-network-security-group)
  - [Parameters Applicable To All Resources](#parameters-applicable-to-all-resources)
    - [`api_version`](#api_version)
    - [User Provided Api Version](#user-provided-api-version)
    - [Pre-defined Default Api Version](#pre-defined-default-api-version)
    - [Latest Api Version](#latest-api-version)
    - [`endpoint`](#endpoint)
    - [http_client parameters](#http_client-parameters)
  - [Development](#development)
    - [Developing a Static Resource](#developing-a-static-resource)
      - [Singular Resources](#singular-resources)
      - [Plural Resources](#plural-resources)
    - [Setting the Environment Variables](#setting-the-environment-variables)
    - [Starting an Environment](#starting-an-environment)
    - [Direnv](#direnv)
    - [Rake Commands](#rake-commands)
    - [Optional Components](#optional-components)

## Prerequisites

* Ruby
* Bundler installed
* Azure Service Principal Account

### Service Principal

Your Azure Service Principal Account must have a minimum of `reader` role of the [Azure roles](https://docs.microsoft.com/en-us/azure/role-based-access-control/rbac-and-directory-admin-roles#azure-roles) to any subscription that you'd like to use this resource pack against. 

You should have the following pieces of information:

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
7. Click on `Certificates & secrets`.
8. Click on `New client secret`.
9. Create a new password. This value is your `client_secret` above.
10. Go to your subscription (click on `All Services` then subscriptions). Choose your subscription from that list.
11. Note your Subscription ID can be found here.
12. Click `Access control (IAM)`.
13. Click **Add**.
14. Select the `reader` role.
15. Select the application you just created and save.

These must be stored in a environment variables prefaced with `AZURE_`.  If you use Dotenv, then you may save these values in your own `.envrc` file. Either source it or run `direnv allow`. If you don't use Dotenv, then you may just create environment variables in the way that your prefer.

### Use the Resources

Since this is an InSpec resource pack, it only defines InSpec resources. To use these resources in your own controls you should create your own profile:

#### Create a new profile

```
$ inspec init profile --platform azure my-profile
```

Example `inspec.yml`:

```yaml
name: my-profile
title: My own Azure profile
version: 0.1.0
inspec_version: '>= 4.23.15'
depends:
  - name: inspec-azure
    url: https://github.com/inspec/inspec-azure/archive/x.tar.gz
supports:
  - platform: azure
```

(For available inspec-azure versions, see this list of [inspec-azure versions](https://github.com/inspec/inspec-azure/releases).)

## Resource Documentation

The following is a list of generic resources.

- [azure_generic_resource](https://docs.chef.io/inspec/resources/azure_generic_resource/)
- [azure_generic_resources](https://docs.chef.io/inspec/resources/azure_generic_resources/)
- [azure_graph_generic_resource](https://docs.chef.io/inspec/resources/azure_graph_generic_resource/)
- [azure_graph_generic_resources](https://docs.chef.io/inspec/resources/azure_graph_generic_resources/)
 
With the generic resources:

- Azure cloud resources that this resource pack does not include a static InSpec resource for can be tested.
- Azure resources from different resource providers and resource groups can be tested at the same time.
- Server side filtering can be used for more efficient tests.
 
The following is a list of static resources. 

- [azure_active_directory_domain_service](https://docs.chef.io/inspec/resources/azure_active_directory_domain_service/)
- [azure_active_directory_domain_services](https://docs.chef.io/inspec/resources/azure_active_directory_domain_services/)
- [azure_aks_cluster](https://docs.chef.io/inspec/resources/azure_aks_cluster/)
- [azure_aks_clusters](https://docs.chef.io/inspec/resources/azure_aks_clusters/)
- [azure_api_management](https://docs.chef.io/inspec/resources/azure_api_management/)
- [azure_api_managements](https://docs.chef.io/inspec/resources/azure_api_managements/)
- [azure_application_gateway](https://docs.chef.io/inspec/resources/azure_application_gateway/)
- [azure_application_gateways](https://docs.chef.io/inspec/resources/azure_application_gateways/)
- [azure_bastion_hosts_resource](https://docs.chef.io/inspec/resources/azure_bastion_hosts_resource/)
- [azure_bastion_hosts_resources](https://docs.chef.io/inspec/resources/azure_bastion_hosts_resources/)
- [azure_container_group](https://docs.chef.io/inspec/resources/azure_container_group/)
- [azure_container_groups](https://docs.chef.io/inspec/resources/azure_container_groups/)
- [azure_container_registries](https://docs.chef.io/inspec/resources/azure_container_registries/)
- [azure_container_registry](https://docs.chef.io/inspec/resources/azure_container_registry/)
- [azure_cosmosdb_database_account](https://docs.chef.io/inspec/resources/azure_cosmosdb_database_account/)
- [azure_data_factories](https://docs.chef.io/inspec/resources/azure_data_factories/)
- [azure_data_factory](https://docs.chef.io/inspec/resources/azure_data_factory/)
- [azure_data_factory_linked_service](https://docs.chef.io/inspec/resources/azure_data_factory_linked_service/)
- [azure_data_factory_linked_services](https://docs.chef.io/inspec/resources/azure_data_factory_linked_services/)
- [azure_data_factory_pipeline_run_resource](https://docs.chef.io/inspec/resources/azure_data_factory_pipeline_run_resource/)
- [azure_data_factory_pipeline_run_resources](https://docs.chef.io/inspec/resources/azure_data_factory_pipeline_run_resources/)
- [azure_db_migration_service](https://docs.chef.io/inspec/resources/azure_db_migration_service/)
- [azure_db_migration_services](https://docs.chef.io/inspec/resources/azure_db_migration_services/)
- [azure_ddos_protection_resource](https://docs.chef.io/inspec/resources/azure_ddos_protection_resource/)
- [azure_ddos_protection_resources](https://docs.chef.io/inspec/resources/azure_ddos_protection_resources/)
- [azure_dns_zones_resource](https://docs.chef.io/inspec/resources/azure_dns_zones_resource/)
- [azure_dns_zones_resources](https://docs.chef.io/inspec/resources/azure_dns_zones_resources/)
- [azure_event_hub_authorization_rule](https://docs.chef.io/inspec/resources/azure_event_hub_authorization_rule/)
- [azure_event_hub_event_hub](https://docs.chef.io/inspec/resources/azure_event_hub_event_hub/)
- [azure_event_hub_namespace](https://docs.chef.io/inspec/resources/azure_event_hub_namespace/)
- [azure_express_route_providers](https://docs.chef.io/inspec/resources/azure_express_route_providers/)
- [azure_express_route_circuit](https://docs.chef.io/inspec/resources/azure_express_route_circuit/)
- [azure_express_route_circuits](https://docs.chef.io/inspec/resources/azure_express_route_circuits/)
- [azure_generic_resource](https://docs.chef.io/inspec/resources/azure_generic_resource/)
- [azure_generic_resources](https://docs.chef.io/inspec/resources/azure_generic_resources/)
- [azure_graph_generic_resource](https://docs.chef.io/inspec/resources/azure_graph_generic_resource/)
- [azure_graph_generic_resources](https://docs.chef.io/inspec/resources/azure_graph_generic_resources/)
- [azure_graph_user](https://docs.chef.io/inspec/resources/azure_graph_user/)
- [azure_graph_users](https://docs.chef.io/inspec/resources/azure_graph_users/)
- [azure_hdinsight_cluster](https://docs.chef.io/inspec/resources/azure_hdinsight_cluster/)
- [azure_iothub](https://docs.chef.io/inspec/resources/azure_iothub/)
- [azure_iothub_event_hub_consumer_group](https://docs.chef.io/inspec/resources/azure_iothub_event_hub_consumer_group/)
- [azure_iothub_event_hub_consumer_groups](https://docs.chef.io/inspec/resources/azure_iothub_event_hub_consumer_groups/)
- [azure_key_vault](https://docs.chef.io/inspec/resources/azure_key_vault/)
- [azure_key_vaults](https://docs.chef.io/inspec/resources/azure_key_vaults/)
- [azure_key_vault_key](https://docs.chef.io/inspec/resources/azure_key_vault_key/)
- [azure_key_vault_keys](https://docs.chef.io/inspec/resources/azure_key_vault_keys/)
- [azure_key_vault_secret](https://docs.chef.io/inspec/resources/azure_key_vault_secret/)
- [azure_key_vault_secrets](https://docs.chef.io/inspec/resources/azure_key_vault_secrets/)
- [azure_load_balancer](https://docs.chef.io/inspec/resources/azure_load_balancer/)
- [azure_load_balancers](https://docs.chef.io/inspec/resources/azure_load_balancers/)
- [azure_lock](https://docs.chef.io/inspec/resources/azure_lock/)
- [azure_locks](https://docs.chef.io/inspec/resources/azure_locks/)
- [azure_management_group](https://docs.chef.io/inspec/resources/azure_management_group/)
- [azure_management_groups](https://docs.chef.io/inspec/resources/azure_management_groups/)
- [azure_mariadb_server](https://docs.chef.io/inspec/resources/azure_mariadb_server/)
- [azure_mariadb_servers](https://docs.chef.io/inspec/resources/azure_mariadb_servers/)
- [azure_migrate_assessment](https://docs.chef.io/inspec/resources/azure_migrate_assessment/)
- [azure_migrate_assessments](https://docs.chef.io/inspec/resources/azure_migrate_assessments/)
- [azure_migrate_assessment_project](https://docs.chef.io/inspec/resources/azure_migrate_assessment_project/)
- [azure_migrate_assessment_projects](https://docs.chef.io/inspec/resources/azure_migrate_assessment_projects/)
- [azure_migrate_assessment_group](https://docs.chef.io/inspec/resources/azure_migrate_assessment_group/)
- [azure_migrate_assessment_groups](https://docs.chef.io/inspec/resources/azure_migrate_assessment_groups/)
- [azure_migrate_project_database](https://docs.chef.io/inspec/resources/azure_migrate_project_database/)
- [azure_migrate_project_databases](https://docs.chef.io/inspec/resources/azure_migrate_project_databases/)
- [azure_migrate_project_event](https://docs.chef.io/inspec/resources/azure_migrate_project_event/)
- [azure_migrate_project_events](https://docs.chef.io/inspec/resources/azure_migrate_project_events/)
- [azure_migrate_project_machine](https://docs.chef.io/inspec/resources/azure_migrate_project_machine/)
- [azure_migrate_project_machines](https://docs.chef.io/inspec/resources/azure_migrate_project_machines/)
- [azure_migrate_project_solution](https://docs.chef.io/inspec/resources/azure_migrate_project_solution/)
- [azure_migrate_project_solutions](https://docs.chef.io/inspec/resources/azure_migrate_project_solutions/)
- [azure_monitor_activity_log_alert](https://docs.chef.io/inspec/resources/azure_monitor_activity_log_alert/)
- [azure_monitor_activity_log_alerts](https://docs.chef.io/inspec/resources/azure_monitor_activity_log_alerts/)
- [azure_monitor_log_profile](https://docs.chef.io/inspec/resources/azure_monitor_log_profile/)
- [azure_monitor_log_profiles](https://docs.chef.io/inspec/resources/azure_monitor_log_profiles/)
- [azure_mysql_database](https://docs.chef.io/inspec/resources/azure_mysql_database/)
- [azure_mysql_databases](https://docs.chef.io/inspec/resources/azure_mysql_databases/)
- [azure_mysql_server](https://docs.chef.io/inspec/resources/azure_mysql_server/)
- [azure_mysql_servers](https://docs.chef.io/inspec/resources/azure_mysql_servers/)
- [azure_network_interface](https://docs.chef.io/inspec/resources/azure_network_interface/)
- [azure_network_interfaces](https://docs.chef.io/inspec/resources/azure_network_interfaces/)
- [azure_network_security_group](https://docs.chef.io/inspec/resources/azure_network_security_group/)
- [azure_network_security_groups](https://docs.chef.io/inspec/resources/azure_network_security_groups/)
- [azure_network_watcher](https://docs.chef.io/inspec/resources/azure_network_watcher/)
- [azure_network_watchers](https://docs.chef.io/inspec/resources/azure_network_watchers/)
- [azure_policy_assignments](https://docs.chef.io/inspec/resources/azure_policy_assignments/)
- [azure_policy_definition](https://docs.chef.io/inspec/resources/azure_policy_definition/)
- [azure_policy_definitions](https://docs.chef.io/inspec/resources/azure_policy_definitions/)
- [azure_policy_exemption](https://docs.chef.io/inspec/resources/azure_policy_exemption/)
- [azure_policy_exemptions](https://docs.chef.io/inspec/resources/azure_policy_exemptions/)
- [azure_policy_insights_query_result](https://docs.chef.io/inspec/resources/azure_policy_insights_query_result/)
- [azure_policy_insights_query_results](https://docs.chef.io/inspec/resources/azure_policy_insights_query_results/)
- [azure_postgresql_database](https://docs.chef.io/inspec/resources/azure_postgresql_database/)
- [azure_postgresql_databases](https://docs.chef.io/inspec/resources/azure_postgresql_databases/)
- [azure_postgresql_server](https://docs.chef.io/inspec/resources/azure_postgresql_server/)
- [azure_postgresql_servers](https://docs.chef.io/inspec/resources/azure_postgresql_servers/)
- [azure_power_bi_app](https://docs.chef.io/inspec/resources/azure_power_bi_app/)
- [azure_power_bi_apps](https://docs.chef.io/inspec/resources/azure_power_bi_apps/)
- [azure_public_ip](https://docs.chef.io/inspec/resources/azure_public_ip/)
- [azure_redis_cache](https://docs.chef.io/inspec/resources/azure_redis_cache/)
- [azure_redis_caches](https://docs.chef.io/inspec/resources/azure_redis_caches/)
- [azure_resource_group](https://docs.chef.io/inspec/resources/azure_resource_group/)
- [azure_resource_groups](https://docs.chef.io/inspec/resources/azure_resource_groups/)
- [azure_resource_health_availability_status](https://docs.chef.io/inspec/resources/azure_resource_health_availability_status/)
- [azure_resource_health_availability_statuses](https://docs.chef.io/inspec/resources/azure_resource_health_availability_statuses/)
- [azure_resource_health_emerging_issue](https://docs.chef.io/inspec/resources/azure_resource_health_emerging_issue/)
- [azure_resource_health_emerging_issues](https://docs.chef.io/inspec/resources/azure_resource_health_emerging_issues/)
- [azure_resource_health_events](https://docs.chef.io/inspec/resources/azure_resource_health_events/)
- [azure_role_definition](https://docs.chef.io/inspec/resources/azure_role_definition/)
- [azure_role_definitions](https://docs.chef.io/inspec/resources/azure_role_definitions/)
- [azure_security_center_policy](https://docs.chef.io/inspec/resources/azure_security_center_policy/)
- [azure_security_center_policies](https://docs.chef.io/inspec/resources/azure_security_center_policies/)
- [azure_sentinel_alert_rule_template](https://docs.chef.io/inspec/resources/azure_sentinel_alert_rule_template/)
- [azure_sentinel_alert_rule_templates](https://docs.chef.io/inspec/resources/azure_sentinel_alert_rule_templates/)
- [azure_sql_database](https://docs.chef.io/inspec/resources/azure_sql_database/)
- [azure_sql_databases](https://docs.chef.io/inspec/resources/azure_sql_databases/)
- [azure_sql_server](https://docs.chef.io/inspec/resources/azure_sql_server/)
- [azure_sql_servers](https://docs.chef.io/inspec/resources/azure_sql_servers/)
- [azure_storage_account](https://docs.chef.io/inspec/resources/azure_storage_account/)
- [azure_storage_accounts](https://docs.chef.io/inspec/resources/azure_storage_accounts/)
- [azure_storage_account_blob_container](https://docs.chef.io/inspec/resources/azure_storage_account_blob_container/)
- [azure_storage_account_blob_containers](https://docs.chef.io/inspec/resources/azure_storage_account_blob_containers/)
- [azure_streaming_analytics_function](https://docs.chef.io/inspec/resources/azure_streaming_analytics_function/)
- [azure_streaming_analytics_functions](https://docs.chef.io/inspec/resources/azure_streaming_analytics_functions/)
- [azure_subnet](https://docs.chef.io/inspec/resources/azure_subnet/)
- [azure_subnets](https://docs.chef.io/inspec/resources/azure_subnets/)
- [azure_subscription](https://docs.chef.io/inspec/resources/azure_subscription/)
- [azure_subscriptions](https://docs.chef.io/inspec/resources/azure_subscriptions/)
- [azure_synapse_notebook](https://docs.chef.io/inspec/resources/azure_synapse_notebook/)
- [azure_synapse_notebooks](https://docs.chef.io/inspec/resources/azure_synapse_notebooks/)
- [azure_virtual_machine](https://docs.chef.io/inspec/resources/azure_virtual_machine/)
- [azure_virtual_machines](https://docs.chef.io/inspec/resources/azure_virtual_machines/)
- [azure_virtual_machine_disk](https://docs.chef.io/inspec/resources/azure_virtual_machine_disk/)
- [azure_virtual_machine_disks](https://docs.chef.io/inspec/resources/azure_virtual_machine_disks/)
- [azure_virtual_network](https://docs.chef.io/inspec/resources/azure_virtual_network/)
- [azure_virtual_network_gateway](https://docs.chef.io/inspec/resources/azure_virtual_network_gateway/)
- [azure_virtual_network_gateways](https://docs.chef.io/inspec/resources/azure_virtual_network_gateways/)
- [azure_virtual_network_gateway_connection](https://docs.chef.io/inspec/resources/azure_virtual_network_gateway_connection/)
- [azure_virtual_network_gateway_connections](https://docs.chef.io/inspec/resources/azure_virtual_network_gateway_connections/)
- [azure_virtual_network_peering](https://docs.chef.io/inspec/resources/azure_virtual_network_peering/)
- [azure_virtual_network_peerings](https://docs.chef.io/inspec/resources/azure_virtual_network_peerings/)
- [azure_virtual_networks](https://docs.chef.io/inspec/resources/azure_virtual_networks/)
- [azure_virtual_wan](https://docs.chef.io/inspec/resources/azure_virtual_wan/)
- [azure_virtual_wans](https://docs.chef.io/inspec/resources/azure_virtual_wans/)
- [azure_web_app_function](https://docs.chef.io/inspec/resources/azure_web_app_function/)
- [azure_web_app_functions](https://docs.chef.io/inspec/resources/azure_web_app_functions/)
- [azure_webapp](https://docs.chef.io/inspec/resources/azure_webapp/)
- [azure_webapps](https://docs.chef.io/inspec/resources/azure_webapps/)

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
InSpec Azure resources can be forced to use a specific version of the API to eliminate the behavioural changes between the tests using different API versions. The latest version will be used unless a specific version is provided.

### User Provided Api Version

```ruby
describe azure_virtual_machine(resource_group: 'my_group', name: 'my_VM', api_version: '2020-01-01') do
  its('api_version_used_for_query_state') { should eq 'user_provided' }
  its('api_version_used_for_query') { should eq '2020-01-01' }
end
```

### Pre-defined Default Api Version

`default` api version can be used if it is supported by the resource provider.

```ruby
describe azure_generic_resource(resource_provider: 'Microsoft.Compute/virtualMachines', name: 'my_VM', api_version: 'default') do
  its('api_version_used_for_query_state') { should eq 'default' }
end
```

### Latest Api Version
`latest` version will be determined by this resource pack within the supported api versions. If the latest version is a `preview` than an older but a stable version might be used. Explicitly forcing to use the `latest` version.

```ruby
describe azure_virtual_networks(api_version: 'latest') do
  its('api_version_used_for_query_state') { should eq 'latest' }
end
```

`latest` version will be used unless provided (Implicit).

```ruby
describe azure_network_security_groups(resource_group: 'my_group') do
  its('api_version_used_for_query_state') { should eq 'latest' }
end
```

`latest` version will be used if the provided is invalid.

```ruby
describe azure_network_security_groups(resource_group: 'my_group', api_version: 'invalid_api_version') do
  its('api_version_used_for_query_state') { should eq 'latest' }
end
```

### `endpoint`

Microsoft Azure cloud services are available through a global and three national network of datacenter as described [here](https://docs.microsoft.com/en-us/graph/deployments). The preferred data center can be defined via `endpoint` parameter. Azure Global Cloud will be used if not provided.

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

The predefined environment variables for each cloud deployments can be found [here](libraries/backend/helpers.rb).

### http_client parameters

The behavior of the http client can be defined with the following parameters:

- `azure_retry_limit`: Maximum number of retries (default - `2`, Integer).
- `azure_retry_backoff`: Pause in seconds between retries (default - `0`, Integer).
- `azure_retry_backoff_factor`: The amount to multiply each successive retries interval amount by (default - `1`, Integer).

They can be defined as environment variables or resource parameters (has priority).

<hr>

> <b>WARNING</b> The following resources are using their `azure_` counterparts under the hood and they will be deprecated in the InSpec Azure version **2**.
> Their api versions are fixed (see below) for full backward compatibility.
> It is strongly advised to start using the resources with `azure_` prefix for an up-to-date testing experience.

| Legacy Resource Name              | Fixed [api version](#api_version) | Replaced by                   |
|------------------------------------------|----------------------------|-------------------------------|
| azurerm_ad_user, azurerm_ad_users | `v1.0` | [azure_graph_user](https://docs.chef.io/inspec/resources/azure_graph_user/), [azure_graph_users](https://docs.chef.io/inspec/resources/azure_graph_users/) |
| azurerm_aks_cluster, azurerm_aks_clusters | `2018-03-31` | [azure_aks_cluster](https://docs.chef.io/inspec/resources/azure_aks_cluster/), [azure_aks_cluster](https://docs.chef.io/inspec/resources/azure_aks_cluster/) |
| azurerm_api_management, azurerm_api_managements | `2019-12-01` | [azure_api_management](https://docs.chef.io/inspec/resources/azure_api_management/), [azure_api_managements](https://docs.chef.io/inspec/resources/azure_api_managements/) |
| azurerm_application_gateway, azurerm_application_gateways | `2019-12-01` | [azure_application_gateway](https://docs.chef.io/inspec/resources/azure_application_gateway/), [azure_application_gateways](https://docs.chef.io/inspec/resources/azure_application_gateways/) |
| azurerm_cosmosdb_database_account | `2015-04-08` | [azure_cosmosdb_database_account](https://docs.chef.io/inspec/resources/azure_cosmosdb_database_account/) |
| azurerm_event_hub_authorization_rule | `2017-04-01` | [azure_event_hub_authorization_rule](https://docs.chef.io/inspec/resources/azure_event_hub_authorization_rule/) |
| azurerm_event_hub_event_hub | `2017-04-01` | [azure_event_hub_event_hub](https://docs.chef.io/inspec/resources/azure_event_hub_event_hub/) |
| azurerm_event_hub_namespace | `2017-04-01` | [azure_event_hub_namespace](https://docs.chef.io/inspec/resources/azure_event_hub_namespace/) |
| azurerm_hdinsight_cluster | `2015-03-01-preview` | [azure_hdinsight_cluster](https://docs.chef.io/inspec/resources/azure_hdinsight_cluster/) |
| azurerm_iothub | `2018-04-01` | [azure_iothub](https://docs.chef.io/inspec/resources/azure_iothub/) |
| azurerm_iothub_event_hub_consumer_group, azurerm_iothub_event_hub_consumer_groups |`2018-04-01` | [azure_iothub_event_hub_consumer_group](https://docs.chef.io/inspec/resources/azure_iothub_event_hub_consumer_group/), [azure_iothub_event_hub_consumer_groups](https://docs.chef.io/inspec/resources/azure_iothub_event_hub_consumer_groups/) |
| azurerm_key_vault, azurerm_key_vaults | `2016-10-01` | [azure_key_vault](https://docs.chef.io/inspec/resources/azure_key_vault/), [azure_key_vaults](https://docs.chef.io/inspec/resources/azure_key_vaults/) |
| azurerm_key_vault_key, azurerm_key_vault_keys | `2016-10-01` | [azure_key_vault_key](https://docs.chef.io/inspec/resources/azure_key_vault_key/), [azure_key_vault_keys](https://docs.chef.io/inspec/resources/azure_key_vault_keys/) |
| azurerm_key_vault_secret, azurerm_key_vault_secrets | `2016-10-01` | [azure_key_vault_secret](https://docs.chef.io/inspec/resources/azure_key_vault_secret/), [azure_key_vault_secrets](https://docs.chef.io/inspec/resources/azure_key_vault_secrets/) |
| azurerm_load_balancer, azurerm_load_balancers | `2018-11-01` | [azure_load_balancer](https://docs.chef.io/inspec/resources/azure_load_balancer/), [azure_load_balancers](https://docs.chef.io/inspec/resources/azure_load_balancers/) |
| azurerm_locks | `2016-09-01` | [azure_locks](https://docs.chef.io/inspec/resources/azure_locks/) |
| azurerm_management_group, azurerm_management_groups | `2018-03-01-preview` | [azure_management_group](https://docs.chef.io/inspec/resources/azure_management_group/), [azure_management_groups](https://docs.chef.io/inspec/resources/azure_management_groups/) |
| azurerm_mariadb_server, azurerm_mariadb_servers | `2018-06-01-preview` | [azure_mariadb_server](https://docs.chef.io/inspec/resources/azure_mariadb_server/), [azure_mariadb_servers](https://docs.chef.io/inspec/resources/azure_mariadb_servers/) |
| azurerm_monitor_activity_log_alert, azurerm_monitor_activity_log_alerts | `2017-04-01` | [azure_monitor_activity_log_alert](https://docs.chef.io/inspec/resources/azure_monitor_activity_log_alert/), [azure_monitor_activity_log_alerts](https://docs.chef.io/inspec/resources/azure_monitor_activity_log_alerts/) |
| azurerm_monitor_log_profile, azurerm_monitor_log_profiles | `2016-03-01` | [azure_monitor_log_profile](https://docs.chef.io/inspec/resources/azure_monitor_log_profile/), [azure_monitor_log_profiles](https://docs.chef.io/inspec/resources/azure_monitor_log_profiles/) |
| azurerm_mysql_database, azurerm_mysql_databases | `2017-12-01` | [azure_mysql_database](https://docs.chef.io/inspec/resources/azure_mysql_database/), [azure_mysql_databases](https://docs.chef.io/inspec/resources/azure_mysql_databases/) |
| azurerm_mysql_server, azurerm_mysql_servers | `2017-12-01` | [azure_mysql_server](https://docs.chef.io/inspec/resources/azure_mysql_server/), [azure_mysql_servers](https://docs.chef.io/inspec/resources/azure_mysql_servers/) |
| azurerm_network_interface, azurerm_network_interfaces | `2018-11-01` | [azure_network_interface](https://docs.chef.io/inspec/resources/azure_network_interface/), [azure_network_interfaces](https://docs.chef.io/inspec/resources/azure_network_interfaces/) |
| azurerm_network_security_group, azurerm_network_security_groups | `2018-02-01` | [azure_network_security_group](https://docs.chef.io/inspec/resources/azure_network_security_group/), [azure_network_security_groups](https://docs.chef.io/inspec/resources/azure_network_security_groups/) |
| azurerm_network_watcher, azurerm_network_watchers | `2018-02-01` | [azure_network_watcher](https://docs.chef.io/inspec/resources/azure_network_watcher/), [azure_network_watchers](https://docs.chef.io/inspec/resources/azure_network_watchers/) |
| azurerm_postgresql_database, azurerm_postgresql_databases | `2017-12-01` | [azure_postgresql_database](https://docs.chef.io/inspec/resources/azure_postgresql_database/), [azure_postgresql_databases](https://docs.chef.io/inspec/resources/azure_postgresql_databases/) |
| azurerm_postgresql_server, azurerm_postgresql_servers | `2017-12-01` | [azure_postgresql_server](https://docs.chef.io/inspec/resources/azure_postgresql_server/), [azure_postgresql_servers](https://docs.chef.io/inspec/resources/azure_postgresql_servers/) |
| azurerm_public_ip | `2020-05-01` | [azure_public_ip](https://docs.chef.io/inspec/resources/azure_public_ip/) |
| azurerm_resource_groups | `2018-02-01` | [azure_resource_groups](https://docs.chef.io/inspec/resources/azure_resource_groups/) |
| azurerm_role_definition, azurerm_role_definitions | `2015-07-01` | [azure_role_definition](https://docs.chef.io/inspec/resources/azure_role_definition/), [azure_role_definitions](https://docs.chef.io/inspec/resources/azure_role_definitions/) |
| azurerm_security_center_policy, azurerm_security_center_policies | `2015-06-01-Preview` | [azure_security_center_policy](https://docs.chef.io/inspec/resources/azure_security_center_policy/), [azure_security_center_policies](https://docs.chef.io/inspec/resources/azure_security_center_policies/) |
| azurerm_sql_database, azurerm_sql_databases | `2017-10-01-preview` | [azure_sql_database](https://docs.chef.io/inspec/resources/azure_sql_database/), [azure_sql_databases](https://docs.chef.io/inspec/resources/azure_sql_databases/) |
| azurerm_sql_server, azurerm_sql_servers | `2018-06-01-preview` | [azure_sql_server](https://docs.chef.io/inspec/resources/azure_sql_server/), [azure_sql_servers](https://docs.chef.io/inspec/resources/azure_sql_servers/) |
| azurerm_storage_account, azurerm_storage_accounts  | `2017-06-01` | [azure_storage_account](https://docs.chef.io/inspec/resources/azure_storage_account/), [azure_storage_accounts](https://docs.chef.io/inspec/resources/azure_storage_accounts/) | 
| azurerm_storage_account_blob_container, azurerm_storage_account_blob_containers  | `2018-07-01` | [azure_storage_account_blob_container](https://docs.chef.io/inspec/resources/azure_storage_account_blob_container/), [azure_storage_account_blob_containers](https://docs.chef.io/inspec/resources/azure_storage_account_blob_containers/) | 
| azurerm_subnet, azurerm_subnets | `2018-02-01` | [azure_subnet](https://docs.chef.io/inspec/resources/azure_subnet/), [azure_subnets](https://docs.chef.io/inspec/resources/azure_subnets/) |
| azurerm_subscription | `2019-10-01` | [azure_subscription](https://docs.chef.io/inspec/resources/azure_subscription/) |
| azurerm_virtual_machine, azurerm_virtual_machines | `2017-12-01` | [azure_virtual_machine](https://docs.chef.io/inspec/resources/azure_virtual_machine/), [azure_virtual_machines](https://docs.chef.io/inspec/resources/azure_virtual_machines/) |
| azurerm_virtual_machine_disk, azurerm_virtual_machine_disks | `2017-03-30` | [azure_virtual_machine_disk](https://docs.chef.io/inspec/resources/azure_virtual_machine_disk/), [azure_virtual_machine_disks](https://docs.chef.io/inspec/resources/azure_virtual_machine_disks/) |
| azurerm_virtual_network, azurerm_virtual_networks | `2018-02-01` | [azure_virtual_network](https://docs.chef.io/inspec/resources/azure_virtual_network/), [azure_virtual_networks](https://docs.chef.io/inspec/resources/azure_virtual_networks/) |
| azurerm_webapp, azurerm_webapps | `2016-08-01` | [azure_webapp](https://docs.chef.io/inspec/resources/azure_webapp/), [azure_webapps](https://docs.chef.io/inspec/resources/azure_webapps/) |

## Development

If you'd like to contribute to this project please see [Contributing Rules](CONTRIBUTING.md). 

For a detailed walk-through of resource creation, see the [Resource Creation Guide](dev-docs/resource_creation_guide.md).

### Developing a Static Resource

The static resource is an InSpec Azure resource that is used to interrogate a specific Azure resource, such as, `azure_virtual_machine`, `azure_key_vaults`. As opposed to the generic resources, they might have some static properties created by processing the dynamic properties of a resource, such as, `azure_virtual_machine.admin_username`.

The easiest way to start is checking the existing static resources. They have detailed information on how to leverage the backend class within their comments.

The common parameters are:

- `resource_provider`: Such as `Microsoft.Compute/virtualMachines`. It has to be hardcoded in the code by the resource author via the `specific_resource_constraint` method, and it should be the first parameter defined in the resource. This method includes user-supplied input validation.  
- `display_name`: A generic one will be created unless defined.
- `required_parameters`: Define mandatory parameters. The `resource_group` and resource `name` in the singular resources are default mandatory in the base class.
- `allowed_parameters`: Define optional parameters. The `resource_group` is optional in plural resources, but this can be made mandatory in the static resource. 
- `resource_uri`: Azure REST API URI of a resource. This parameter should be used when a resource does not reside in a resource group. It requires `add_subscription_id` to be set to either `true` or `false`. See [azure_policy_definition](libraries/azure_policy_definition.rb) and [azure_policy_definitions](libraries/azure_policy_definitions.rb).
- `add_subscription_id`: It indicates whether the subscription ID should be included in the `resource_uri` or not.

#### Singular Resources

The singular resource is used to test a specific resource of a specific type and should include all of the properties available, such as, `azure_virtual_machine`.

- In most cases `resource_group` and resource `name` should be required from the users and a single API call would be enough for creating methods on the resource. See [azure_virtual_machine](libraries/azure_virtual_machine.rb) for a standard singular resource and how to create static methods from resource properties.
- If it is beneficial to accept the resource name with a more specific keyword, such as `server_name`, see [azure_mysql_server](libraries/azure_mysql_server.rb).
- If a resource exists in another resource, such as a subnet on a virtual network, see [azure_subnet](libraries/azure_subnet.rb).
- If it is necessary to make an additional API call within a static method, the `create_additional_properties` should be used. See [azure_key_vault](libraries/azure_key_vault.rb). 

#### Plural Resources

A plural resource is used to test the collection of resources of a specific type, such as, `azure_virtual_machines`. This allows for tests to be written based on the group of resources.

- A standard plural resource does not require a parameter, except optional `resource_group`. See [azure_mysql_servers](libraries/azure_mysql_servers.rb).
- All plural resources use [FilterTable](https://github.com/inspec/inspec/blob/master/docs/dev/filtertable-usage.md) to be able to provide filtering within returned resources. The filter criteria must be defined `table_schema` Hash variable.
- If the properties of the resource are to be manipulated before populating the FilterTable, a `populate_table` method has to be defined. See [azure_virtual_machines](libraries/azure_virtual_machines.rb).
- If the resources exist in another resource, such as subnets of a virtual network, a `resource_path` has to be created. For that, the identifiers of the parent resource, `resource_group` and virtual network name `vnet`, must be required from the users. See [azure_subnets](libraries/azure_subnets.rb).

### Setting the Environment Variables

The following instructions will help you get your development environment setup to run integration tests.

Copy `.envrc-example` to `.envrc` and fill in the fields with the values from your account.

```bash
export AZURE_SUBSCRIPTION_ID=<subscription id>
export AZURE_CLIENT_ID=<client id>
export AZURE_TENANT_ID=<tenant id>
export AZURE_CLIENT_SECRET=<client secret>
```

For PowerShell, set the following environment variables

```shell
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

First ensure your system has [Terraform](https://www.terraform.io/intro/getting-started/install.html) installed.

This environment may be used to run your profile against or to run integration tests on it. We are using [Terraform workspaces](https://www.terraform.io/docs/state/workspaces.html) to allow for teams to have completely unique environments without affecting each other.

### Direnv

[Direnv](https://direnv.net/) is used to initialize an environment variable `WORKSPACE` to your username. We recommend using `direnv` and allowing it to run in your environment. However, if you prefer to not use `direnv` you may also `source .envrc`.

### Rake Commands

Creating a new environment:

```shell
rake azure:login
rake tf:apply
```

Updating a running environment (e.g. when you change the .tf file):

```shell
rake tf:apply
```

Checking if your state has diverged from your plan:

```shell
rake tf:plan
```

Destroying your environment:

```shell
rake tf:destroy
```

To run Rubocop and Syntax check for Ruby and InSpec:

```shell
rake test:lint
```

To run unit tests:

```shell
rake test:unit
```

To run integration tests:

```shell
rake test:integration
```

Please note that Graph API resource requires specific privileges granted to your service principal.
Please refer to the [Microsoft Documentation](https://docs.microsoft.com/en-us/azure/active-directory/develop/active-directory-integrating-applications#updating-an-application) for information on how to grant these permissions to your application.

To run a control called `azure_virtual_machine` only:

```shell
rake test:integration[azurerm_virtual_machine]
```

Note that in zsh you need to escape the `[`, `]` characters.

You may run selected multiple controls only:

```shell
rake test:integration[azure_aks_cluster,azure_virtual_machine]
```

To run lint and unit tests:

```shell
rake
```

### Optional Components

The creation of the following resources can be skipped if there is any resource constraints.

- Network Watcher

```shell
rake tf:apply[network_watcher]
```

- HDinsight Interactive Query Cluster

```shell
rake tf:apply[hdinsight_cluster]
```

- Public IP

```shell
rake tf:apply[public_ip]
```

- API Management

```shell
rake tf:apply[api_management]
```

- Management Group

```shell
rake tf:apply[management_group]
```

A combination of the above can be provided.

```shell
rake tf:apply[management_group,public_ip,network_watcher]
```
