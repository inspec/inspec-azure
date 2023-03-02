# InSpec for Azure

- **Project State: Maintained**

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
    - [Ensure that all resources have specified names within the subscription regardless of type and resource Group](#ensure-that-all-resources-have-specified-names-within-the-subscription-regardless-of-type-and-resource-group)
    - [Ensure all resources has a specified tag defined regardless of the value](#ensure-all-resources-has-a-specified-tag-defined-regardless-of-the-value)
    - [Verify Properties of an Azure Virtual Machine](#verify-properties-of-an-azure-virtual-machine)
    - [Verify Properties of a Network Security Group](#verify-properties-of-a-network-security-group)
  - [Parameters Applicable To All Resources](#parameters-applicable-to-all-resources)
    - [`api_version`](#api_version)
    - [User-Provided API Version](#user-provided-api-version)
    - [Pre-defined Default Api Version](#pre-defined-default-api-version)
    - [Latest API Version](#latest-api-version)
    - [endpoint](#endpoint)
    - [http_client parameters](#http_client-parameters)
  - [Development](#development)
    - [Developing a Static Resource](#developing-a-static-resource)
      - [Singular Resources](#singular-resources)
      - [Plural Resources](#plural-resources)
    - [Setting the Environment Variables](#setting-the-environment-variables)
  - [Setup Azure CLI](#setup-azure-cli)
    - [Starting an Environment](#starting-an-environment)
    - [Direnv](#direnv)
    - [Rake Commands](#rake-commands)
    - [Optional Components](#optional-components)

## Prerequisites

- Ruby
- Bundler installed
- Azure Service Principal Account

### Configuration
### Configuration

For the driver to interact with the Microsoft Azure Resource Management REST API, you need to configure a Service Principal with Contributor rights for a specific subscription. Using an Organizational (AAD) account and related password is no longer supported. To create a Service Principal and apply the correct permissions, see the [create an Azure service principal with the Azure CLI](https://docs.microsoft.com/en-us/cli/azure/create-an-azure-service-principal-azure-cli?view=azure-cli-latest#create-a-service-principal) and the [Azure CLI](https://azure.microsoft.com/en-us/documentation/articles/xplat-cli-install/) documentation. Make sure you stay within the section titled 'Password-based authentication'.

If the above is TLDR then try this after `az login` using your target subscription ID and the desired SP name:

```bash
# Create a Service Principal using the desired subscription id from the command above
az ad sp create-for-rbac --name="kitchen-azurerm" --role="Contributor" --scopes="/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

#Output
#
#{
#  "appId": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",    <- Also known as the Client ID
#  "displayName": "azure-cli-2018-12-12-14-15-39",
#  "name": "http://azure-cli-2018-12-12-14-15-39",
#  "password": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
#  "tenant": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
#}
```

NOTE: Don't forget to save the values from the output -- most importantly the `password`.

You will also need to ensure you have an active Azure subscription (you can get started [for free](https://azure.microsoft.com/en-us/free/) or use your [MSDN Subscription](https://azure.microsoft.com/en-us/pricing/member-offers/msdn-benefits/)).

You are now ready to configure kitchen-azurerm to use the credentials from the service principal you created above. You will use four elements from the output:

1. **Subscription ID**: available from the Azure portal
2. **Client ID**: the appId value from the output.
3. **Client Secret/Password**: the password from the output.
4. **Tenant ID**: the tenant from the output.

Using a text editor, open or create the file ```~/.azure/credentials``` and add the following section, noting there is one section per Subscription ID. **Make sure you save the file with UTF-8 encoding**

```ruby
[ADD-YOUR-AZURE-SUBSCRIPTION-ID-HERE-IN-SQUARE-BRACKET]
client_id = "your-azure-client-id-here"
client_secret = "your-client-secret-here"
tenant_id = "your-azure-tenant-id-here"
```

If preferred, you may also set the following environment variables, however this would be incompatible with supporting multiple Azure subscriptions.

```ruby
AZURE_CLIENT_ID="your-azure-client-id-here"
AZURE_CLIENT_SECRET="your-client-secret-here"
AZURE_TENANT_ID="your-azure-tenant-id-here"
```

Note that the environment variables, if set, take preference over the values in a configuration file.

### Service Principal

Your Azure Service Principal Account must have a minimum of `reader` role of the [Azure roles](https://docs.microsoft.com/en-us/azure/role-based-access-control/rbac-and-directory-admin-roles#azure-roles) to any subscription that you'd like to use this resource pack.

You must have the following pieces of information:

- TENANT_ID
- CLIENT_ID
- CLIENT_SECRET
- SUBSCRIPTION_ID

To create your account Service Principal Account:

1. Log in to the **Azure portal**.
1. Click **Azure Active Directory**.
1. Click **APP registrations**.
1. Click **New application registration**.
1. Enter name and select **Web** from the **Application Type** drop-down.
1. Save your application.
1. Note your Application ID. This is your **client_id**.
1. Click **Certificates & secrets**.
1. Click **New client secret**.
1. Create a new password. This value is your **client_secret** above.
1. Go to your subscription (click **All Services** then subscriptions).
1. Choose your subscription from that list.
1. Note your **Subscription ID**.
1. Click **Access control (IAM)**.
1. Click **Add**.
1. Select the **reader** role.
1. Select the application you created and click **save**.

These must be stored in an environment variables prefaced with `AZURE_`.  If you use Dotenv, then you can save these values in your own `.envrc` file. Either source it or run `direnv allow`. If you do not use `Dotenv`, then you can create environment variables in the way that you prefer.

### Use the Resources

Since this is an InSpec resource pack, it only defines InSpec resources. To use these resources in your controls, you should create your profile:

#### Create a new profile

```ruby
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

#### List of generic resources:

- [azure_generic_resource](https://docs.chef.io/inspec/resources/azure_generic_resource/)
- [azure_generic_resources](https://docs.chef.io/inspec/resources/azure_generic_resources/)
- [azure_graph_generic_resource](https://docs.chef.io/inspec/resources/azure_graph_generic_resource/)
- [azure_graph_generic_resources](https://docs.chef.io/inspec/resources/azure_graph_generic_resources/)

With the generic resources:

- Azure cloud resources pack, which does not include a static InSpec resource and can be tested.
- Azure resources from different resource providers and resource groups can be tested at the same time.
- Server-side filtering can be used for more efficient tests.

#### List of static resources

| Singular Resource                                                                                                                                       | Plural Resource                                                                                                                                           |
|---------------------------------------------------------------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------|
| [azure_active_directory_domain_service](https://docs.chef.io/inspec/resources/azure_active_directory_domain_service/)                                   | [azure_active_directory_domain_services](https://docs.chef.io/inspec/resources/azure_active_directory_domain_services/)                                   |
| [azure_active_directory_object](https://docs.chef.io/inspec/resources/azure_active_directory_object/)                                                   | [azure_active_directory_objects](https://docs.chef.io/inspec/resources/azure_active_directory_objects/)                                                   |
| [azure_aks_cluster](https://docs.chef.io/inspec/resources/azure_aks_cluster/)                                                                           | [azure_aks_clusters](https://docs.chef.io/inspec/resources/azure_aks_clusters/)                                                                           |
| [azure_api_management](https://docs.chef.io/inspec/resources/azure_api_management/)                                                                     | [azure_api_management](https://docs.chef.io/inspec/resources/azure_api_managements/)                                                                      |
| [azure_application_gateway](https://docs.chef.io/inspec/resources/azure_application_gateway/)                                                           | [azure_application_gateways](https://docs.chef.io/inspec/resources/azure_application_gateways/)                                                           |
| [azure_bastion_hosts_resource](https://docs.chef.io/inspec/resources/azure_bastion_hosts_resource/)                                                     | [azure_bastion_hosts_resources](https://docs.chef.io/inspec/resources/azure_bastion_hosts_resources/)                                                     |
| [azure_blob_service](https://docs.chef.io/inspec/resources/azure_blob_service/)                                                                         | [azure_blob_services](https://docs.chef.io/inspec/resources/azure_blob_services/)                                                                         |
| [azure_cdn_profile](https://docs.chef.io/inspec/resources/azure_cdn_profile/)                                                                           | [azure_cdn_profiles](https://docs.chef.io/inspec/resources/azure_cdn_profiles/)                                                                           |
| [azure_container_group](https://docs.chef.io/inspec/resources/azure_container_group/)                                                                   | [azure_container_groups](https://docs.chef.io/inspec/resources/azure_container_groups/)                                                                   |
| [azure_container_registry](https://docs.chef.io/inspec/resources/azure_container_registry/)                                                             | [azure_container_registries](https://docs.chef.io/inspec/resources/azure_container_registries/)                                                           |
| [azure_cosmosdb_database_account](https://docs.chef.io/inspec/resources/azure_cosmosdb_database_account/)                                               | No Plural Resource                                                                                                                                        |
| [azure_data_factory](https://docs.chef.io/inspec/resources/azure_data_factory/)                                                                         | [azure_data_factories](https://docs.chef.io/inspec/resources/azure_data_factories/)                                                                       |
| [azure_data_factory_dataset](https://docs.chef.io/inspec/resources/azure_data_factory_dataset/)                                                         | [azure_data_factory_datasets](https://docs.chef.io/inspec/resources/azure_data_factory_datasets/)                                                         |
| [azure_data_factory_linked_service](https://docs.chef.io/inspec/resources/azure_data_factory_linked_service/)                                           | [azure_data_factory_linked_services](https://docs.chef.io/inspec/resources/azure_data_factory_linked_services/)                                           |
| [azure_data_factory_pipeline](https://docs.chef.io/inspec/resources/azure_data_factory_pipeline/)                                                       | [azure_data_factory_pipelines](https://docs.chef.io/inspec/resources/azure_data_factory_pipelines/)                                                       |
| [azure_data_factory_pipeline_run_resource](https://docs.chef.io/inspec/resources/azure_data_factory_pipeline_run_resource/)                             | [azure_data_factory_pipeline_run_resources](https://docs.chef.io/inspec/resources/azure_data_factory_pipeline_run_resources/)                             |
| [azure_data_lake_storage_gen2_filesystem](https://docs.chef.io/inspec/resources/azure_data_lake_storage_gen2_filesystem/)                               | [azure_data_lake_storage_gen2_filesystems](https://docs.chef.io/inspec/resources/azure_data_lake_storage_gen2_filesystems/)                               |
| [azure_data_lake_storage_gen2_path](https://docs.chef.io/inspec/resources/azure_data_lake_storage_gen2_path/)                                           | [azure_data_lake_storage_gen2_paths](https://docs.chef.io/inspec/resources/azure_data_lake_storage_gen2_paths/)                                           |
| [azure_db_migration_service](https://docs.chef.io/inspec/resources/azure_db_migration_service/)                                                         | [azure_db_migration_services](https://docs.chef.io/inspec/resources/azure_db_migration_services/)                                                         |
| [azure_ddos_protection_resource](https://docs.chef.io/inspec/resources/azure_ddos_protection_resource/)                                                 | [azure_ddos_protection_resources](https://docs.chef.io/inspec/resources/azure_ddos_protection_resources/)                                                 |
| [azure_dns_zones_resource](https://docs.chef.io/inspec/resources/azure_dns_zones_resource/)                                                             | [azure_dns_zones_resources](https://docs.chef.io/inspec/resources/azure_dns_zones_resources/)                                                             |
| [azure_event_hub_authorization_rule](https://docs.chef.io/inspec/resources/azure_event_hub_authorization_rule/)                                         | No Plural Resource                                                                                                                                        |
| [azure_event_hub_event_hub](https://docs.chef.io/inspec/resources/azure_event_hub_event_hub/)                                                           | No Plural Resource                                                                                                                                        |
| [azure_event_hub_namespace](https://docs.chef.io/inspec/resources/azure_event_hub_namespace/)                                                           | No Plural Resource                                                                                                                                        |
| [azure_express_route_circuit](https://docs.chef.io/inspec/resources/azure_express_route_circuit/)                                                       | [azure_express_route_circuits](https://docs.chef.io/inspec/resources/azure_express_route_circuits/)                                                       |
| No Singular Resource                                                                                                                                    | [azure_express_route_providers](https://docs.chef.io/inspec/resources/azure_express_route_providers/)                                                     |
| [azure_graph_user](https://docs.chef.io/inspec/resources/azure_graph_user/)                                                                             | [azure_graph_users](https://docs.chef.io/inspec/resources/azure_graph_users/)                                                                             |
| [azure_hdinsight_cluster](https://docs.chef.io/inspec/resources/azure_hdinsight_cluster/)                                                               | No Plural Resource                                                                                                                                        |
| [azure_hpc_asc_operation](https://docs.chef.io/inspec/resources/azure_hpc_asc_operation/)                                                               | No Plural Resource                                                                                                                                        |
| [azure_hpc_cache](https://docs.chef.io/inspec/resources/azure_hpc_cache/)                                                                               | [azure_hpc_caches](https://docs.chef.io/inspec/resources/azure_hpc_caches/)                                                                               |
| [azure_hpc_storage_target](https://docs.chef.io/inspec/resources/azure_hpc_storage_target/)                                                             | [azure_hpc_storage_targets](https://docs.chef.io/inspec/resources/azure_hpc_storage_targets/)                                                             |
| [azure_iothub](https://docs.chef.io/inspec/resources/azure_iothub/)                                                                                     | No Plural Resource                                                                                                                                        |
| [azure_iothub_event_hub_consumer_group](https://docs.chef.io/inspec/resources/azure_iothub_event_hub_consumer_group/)                                   | [azure_iothub_event_hub_consumer_groups](https://docs.chef.io/inspec/resources/azure_iothub_event_hub_consumer_groups/)                                   |
| [azure_key_vault](https://docs.chef.io/inspec/resources/azure_key_vault/)                                                                               | [azure_key_vaults](https://docs.chef.io/inspec/resources/azure_key_vaults/)                                                                               |
| [azure_key_vault_key](https://docs.chef.io/inspec/resources/azure_key_vault_key/)                                                                       | [azure_key_vault_keys](https://docs.chef.io/inspec/resources/azure_key_vault_keys/)                                                                       |
| [azure_key_vault_secret](https://docs.chef.io/inspec/resources/azure_key_vault_secret/)                                                                 | [azure_key_vault_secrets](https://docs.chef.io/inspec/resources/azure_key_vault_secrets/)                                                                 |
| [azure_load_balancer](https://docs.chef.io/inspec/resources/azure_load_balancer/)                                                                       | [azure_load_balancers](https://docs.chef.io/inspec/resources/azure_load_balancers/)                                                                       |
| [azure_lock](https://docs.chef.io/inspec/resources/azure_lock/)                                                                                         | [azure_locks](https://docs.chef.io/inspec/resources/azure_locks/)                                                                                         |
| [azure_managed_application](https://docs.chef.io/inspec/resources/azure_managed_application/)                                                           | [azure_managed_applications](https://docs.chef.io/inspec/resources/azure_managed_applications/)                                                           |
| [azure_management_group](https://docs.chef.io/inspec/resources/azure_management_group/)                                                                 | [azure_management_groups](https://docs.chef.io/inspec/resources/azure_management_groups/)                                                                 |
| [azure_mariadb_server](https://docs.chef.io/inspec/resources/azure_mariadb_server/)                                                                     | [azure_mariadb_servers](https://docs.chef.io/inspec/resources/azure_mariadb_servers/)                                                                     |
| [azure_microsoft_defender_pricing](https://docs.chef.io/inspec/resources/azure_microsoft_defender_pricing/)                                             | [azure_microsoft_defender_pricings](https://docs.chef.io/inspec/resources/azure_microsoft_defender_pricings/)                                             |
| [azure_microsoft_defender_security_contact](https://docs.chef.io/inspec/resources/azure_microsoft_defender_security_contact/)                           | No Plural Resource                                                                                                                                        |
| [azure_microsoft_defender_setting](https://docs.chef.io/inspec/resources/azure_microsoft_defender_setting/)                                             | [azure_microsoft_defender_settings](https://docs.chef.io/inspec/resources/azure_microsoft_defender_settings/)                                             |
| [azure_migrate_assessment](https://docs.chef.io/inspec/resources/azure_migrate_assessment/)                                                             | [azure_migrate_assessments](https://docs.chef.io/inspec/resources/azure_migrate_assessments/)                                                             |
| [azure_migrate_assessment_group](https://docs.chef.io/inspec/resources/azure_migrate_assessment_group/)                                                 | [azure_migrate_assessment_groups](https://docs.chef.io/inspec/resources/azure_migrate_assessment_groups/)                                                 |
| [azure_migrate_project](https://docs.chef.io/inspec/resources/azure_migrate_project/)                                                                   | No Plural Resource                                                                                                                                        |
| [azure_migrate_project_database](https://docs.chef.io/inspec/resources/azure_migrate_project_database/)                                                 | [azure_migrate_project_databases](https://docs.chef.io/inspec/resources/azure_migrate_project_databases/)                                                 |
| [azure_migrate_project_database_instance](https://docs.chef.io/inspec/resources/azure_migrate_project_database_instance/)                               | [azure_migrate_project_database_instances](https://docs.chef.io/inspec/resources/azure_migrate_project_database_instances/)                               |
| [azure_migrate_project_event](https://docs.chef.io/inspec/resources/azure_migrate_project_event/)                                                       | [azure_migrate_project_events](https://docs.chef.io/inspec/resources/azure_migrate_project_events/)                                                       |
| [azure_migrate_project_machine](https://docs.chef.io/inspec/resources/azure_migrate_project_machine/)                                                   | [azure_migrate_project_machines](https://docs.chef.io/inspec/resources/azure_migrate_project_machines/)                                                   |
| [azure_migrate_assessment_project](https://docs.chef.io/inspec/resources/azure_migrate_assessment_project/)                                             | [azure_migrate_assessment_projects](https://docs.chef.io/inspec/resources/azure_migrate_assessment_projects/)                                             |
| [azure_migrate_project_solution](https://docs.chef.io/inspec/resources/azure_migrate_project_solution/)                                                 | [azure_migrate_project_solutions](https://docs.chef.io/inspec/resources/azure_migrate_project_solutions/)                                                 |
| [azure_monitor_activity_log_alert](https://docs.chef.io/inspec/resources/azure_monitor_activity_log_alert/)                                             | [azure_monitor_activity_log_alerts](https://docs.chef.io/inspec/resources/azure_monitor_activity_log_alerts/)                                             |
| [azure_monitor_log_profile](https://docs.chef.io/inspec/resources/azure_monitor_log_profile/)                                                           | [azure_monitor_log_profiles](https://docs.chef.io/inspec/resources/azure_monitor_log_profiles/)                                                           |
| [azure_mysql_database](https://docs.chef.io/inspec/resources/azure_mysql_database/)                                                                     | [azure_mysql_databases](https://docs.chef.io/inspec/resources/azure_mysql_databases/)                                                                     |
| [azure_mysql_server](https://docs.chef.io/inspec/resources/azure_mysql_server/)                                                                         | [azure_mysql_servers](https://docs.chef.io/inspec/resources/azure_mysql_servers/)                                                                         |
| [azure_mysql_server_configuration](https://docs.chef.io/inspec/resources/azure_mysql_server_configuration/)                                             | [azure_mysql_server_configurations](https://docs.chef.io/inspec/resources/azure_mysql_server_configurations/)                                             |
| [azure_network_interface](https://docs.chef.io/inspec/resources/azure_network_interface/)                                                               | [azure_network_interfaces](https://docs.chef.io/inspec/resources/azure_network_interfaces/)                                                               |
| [azure_network_security_group](https://docs.chef.io/inspec/resources/azure_network_security_group/)                                                     | [azure_network_security_groups](https://docs.chef.io/inspec/resources/azure_network_security_groups/)                                                     |
| [azure_network_watcher](https://docs.chef.io/inspec/resources/azure_network_watcher/)                                                                   | [azure_network_watchers](https://docs.chef.io/inspec/resources/azure_network_watchers/)                                                                   |
| No Singular Resource                                                                                                                                    | [azure_policy_assignments](https://docs.chef.io/inspec/resources/azure_policy_assignments/)                                                               |
| [azure_policy_definition](https://docs.chef.io/inspec/resources/azure_policy_definition/)                                                               | [azure_policy_definitions](https://docs.chef.io/inspec/resources/azure_policy_definitions/)                                                               |
| [azure_policy_exemption](https://docs.chef.io/inspec/resources/azure_policy_exemption/)                                                                 | [azure_policy_exemptions](https://docs.chef.io/inspec/resources/azure_policy_exemptions/)                                                                 |
| [azure_policy_insights_query_result](https://docs.chef.io/inspec/resources/azure_policy_insights_query_result/)                                         | [azure_policy_insights_query_results](https://docs.chef.io/inspec/resources/azure_policy_insights_query_results/)                                         |
| [azure_postgresql_database](https://docs.chef.io/inspec/resources/azure_postgresql_database/)                                                           | [azure_postgresql_databases](https://docs.chef.io/inspec/resources/azure_postgresql_databases/)                                                           |
| [azure_postgresql_server](https://docs.chef.io/inspec/resources/azure_postgresql_server/)                                                               | [azure_postgresql_servers](https://docs.chef.io/inspec/resources/azure_postgresql_servers/)                                                               |
| [azure_power_bi_app](https://docs.chef.io/inspec/resources/azure_power_bi_app/)                                                                         | [azure_power_bi_apps](https://docs.chef.io/inspec/resources/azure_power_bi_apps/)                                                                         |
| [azure_power_bi_app_dashboard](https://docs.chef.io/inspec/resources/azure_power_bi_app_dashboard/)                                                     | [azure_power_bi_app_dashboards](https://docs.chef.io/inspec/resources/azure_power_bi_app_dashboard/)                                                      |
| [azure_power_bi_app_dashboard_tile](https://docs.chef.io/inspec/resources/azure_power_bi_app_dashboard_tile/)                                           | [azure_power_bi_app_dashboard_tiles](https://docs.chef.io/inspec/resources/azure_power_bi_app_dashboard_tiles/)                                           |
| [azure_power_bi_app_report](https://docs.chef.io/inspec/resources/azure_power_bi_app_report/)                                                           | [azure_power_bi_app_reports](https://docs.chef.io/inspec/resources/azure_power_bi_app_reports/)                                                           |
| No Singular Resource                                                                                                                                    | [azure_power_bi_capacities](https://docs.chef.io/inspec/resources/azure_power_bi_capacities/)                                                             |
| [azure_power_bi_capacity_refreshable](https://docs.chef.io/inspec/resources/azure_power_bi_capacity_refreshable/)                                       | [azure_power_bi_capacity_refreshables](https://docs.chef.io/inspec/resources/azure_power_bi_capacity_refreshables/)                                       |
| [azure_power_bi_capacity_workload](https://docs.chef.io/inspec/resources/azure_power_bi_capacity_workload/)                                             | [azure_power_bi_capacity_workloads](https://docs.chef.io/inspec/resources/azure_power_bi_capacity_workloads/)                                             |
| [azure_power_bi_dataflow](https://docs.chef.io/inspec/resources/azure_power_bi_dataflow/)                                                               | [azure_power_bi_dataflows](https://docs.chef.io/inspec/resources/azure_power_bi_dataflows/)                                                               |
| No Singular Resource                                                                                                                                    | [azure_power_bi_dataflow_storage_accounts](https://docs.chef.io/inspec/resources/azure_power_bi_dataflow_storage_accounts/)                               |
| [azure_power_bi_dataset](https://docs.chef.io/inspec/resources/azure_power_bi_dataset/)                                                                 | [azure_power_bi_datasets](https://docs.chef.io/inspec/resources/azure_power_bi_datasets/)                                                                 |
| No Singular Resource                                                                                                                                    | [azure_power_bi_dataset_datasources](https://docs.chef.io/inspec/resources/azure_power_bi_dataset_datasources/)                                           |
| [azure_power_bi_embedded_capacity](https://docs.chef.io/inspec/resources/azure_power_bi_embedded_capacity/)                                             | [azure_power_bi_embedded_capacities](https://docs.chef.io/inspec/resources/azure_power_bi_embedded_capacities/)                                           |
| [azure_power_bi_gateway](https://docs.chef.io/inspec/resources/azure_power_bi_gateway/)                                                                 | [azure_power_bi_gateways](https://docs.chef.io/inspec/resources/azure_power_bi_gateways/)                                                                 |
| No Singular Resource                                                                                                                                    | [azure_power_bi_generic_resources](https://docs.chef.io/inspec/resources/azure_power_bi_generic_resources/)                                               |
| [azure_public_ip](https://docs.chef.io/inspec/resources/azure_public_ip/)                                                                               | No Plural Resource                                                                                                                                        |
| [azure_redis_cache](https://docs.chef.io/inspec/resources/azure_redis_cache/)                                                                           | [azure_redis_caches](https://docs.chef.io/inspec/resources/azure_redis_caches/)                                                                           |
| [azure_resource_group](https://docs.chef.io/inspec/resources/azure_resource_group/)                                                                     | [azure_resource_groups](https://docs.chef.io/inspec/resources/azure_resource_groups/)                                                                     |
| [azure_resource_health_availability_status](https://docs.chef.io/inspec/resources/azure_resource_health_availability_status/)                           | [azure_resource_health_availability_statuses](https://docs.chef.io/inspec/resources/azure_resource_health_availability_statuses/)                         |
| [azure_resource_health_emerging_issue](https://docs.chef.io/inspec/resources/azure_resource_health_emerging_issue/)                                     | [azure_resource_health_emerging_issues](https://docs.chef.io/inspec/resources/azure_resource_health_emerging_issues/)                                     |
| No Singular Resource                                                                                                                                    | [azure_resource_health_events](https://docs.chef.io/inspec/resources/azure_resource_health_events/)                                                       |
| [azure_role_definition](https://docs.chef.io/inspec/resources/azure_role_definition/)                                                                   | [azure_role_definitions](https://docs.chef.io/inspec/resources/azure_role_definitions/)                                                                   |
| [azure_security_center_policy](https://docs.chef.io/inspec/resources/azure_security_center_policy/)                                                     | [azure_security_center_policies](https://docs.chef.io/inspec/resources/azure_security_center_policies/)                                                   |
| [azure_service_bus_namespace](https://docs.chef.io/inspec/resources/azure_service_bus_namespace/)                                                       | [azure_service_bus_namespaces](https://docs.chef.io/inspec/resources/azure_service_bus_namespaces/)                                                       |
| No Singular Resource                                                                                                                                    | [azure_service_bus_regions](https://docs.chef.io/inspec/resources/azure_service_bus_regions/)                                                             |
| [azure_service_bus_subscription](https://docs.chef.io/inspec/resources/azure_service_bus_subscription/)                                                 | [azure_service_bus_subscriptions](https://docs.chef.io/inspec/resources/azure_service_bus_subscriptions/)                                                 |
| [azure_service_bus_subscription_rule](https://docs.chef.io/inspec/resources/azure_service_bus_subscription_rule/)                                       | [azure_service_bus_subscription_rules](https://docs.chef.io/inspec/resources/azure_service_bus_subscription_rules/)                                       |
| [azure_service_bus_topic](https://docs.chef.io/inspec/resources/azure_service_bus_topic/)                                                               | [azure_service_bus_topics](https://docs.chef.io/inspec/resources/azure_service_bus_topics/)                                                               |
| [azure_service_fabric_mesh_application](https://docs.chef.io/inspec/resources/azure_service_fabric_mesh_application/)                                   | [azure_service_fabric_mesh_applications](https://docs.chef.io/inspec/resources/azure_service_fabric_mesh_applications/)                                   |
| [azure_service_fabric_mesh_network](https://docs.chef.io/inspec/resources/azure_service_fabric_mesh_network/)                                           | [azure_service_fabric_mesh_networks](https://docs.chef.io/inspec/resources/azure_service_fabric_mesh_networks/)                                           |
| [azure_service_fabric_mesh_replica](https://docs.chef.io/inspec/resources/azure_service_fabric_mesh_replica/)                                           | [azure_service_fabric_mesh_replicas](https://docs.chef.io/inspec/resources/azure_service_fabric_mesh_replicas/)                                           |
| [azure_service_fabric_mesh_service](https://docs.chef.io/inspec/resources/azure_service_fabric_mesh_service/)                                           | [azure_service_fabric_mesh_services](https://docs.chef.io/inspec/resources/azure_service_fabric_mesh_services/)                                           |
| [azure_service_fabric_mesh_volume](https://docs.chef.io/inspec/resources/azure_service_fabric_mesh_volume/)                                             | [azure_service_fabric_mesh_volumes](https://docs.chef.io/inspec/resources/azure_service_fabric_mesh_volumes/)                                             |
| [azure_snapshot](https://docs.chef.io/inspec/resources/azure_snapshot/)                                                                                 | [azure_snapshots](https://docs.chef.io/inspec/resources/azure_snapshots/)                                                                                 |
| [azure_sql_database](https://docs.chef.io/inspec/resources/azure_sql_database/)                                                                         | [azure_sql_databases](https://docs.chef.io/inspec/resources/azure_sql_databases/)                                                                         |
| [azure_sql_database_server_vulnerability_assessment](https://docs.chef.io/inspec/resources/azure_sql_database_server_vulnerability_assessment/)         | [azure_sql_database_server_vulnerability_assessments](https://docs.chef.io/inspec/resources/azure_sql_database_server_vulnerability_assessments/)         |
| [azure_sql_managed_instance](https://docs.chef.io/inspec/resources/azure_sql_managed_instance/)                                                         | [azure_sql_managed_instances](https://docs.chef.io/inspec/resources/azure_sql_managed_instances/)                                                         |
| [azure_sql_server](https://docs.chef.io/inspec/resources/azure_sql_server/)                                                                             | [azure_sql_servers](https://docs.chef.io/inspec/resources/azure_sql_servers/)                                                                             |
| [azure_sql_virtual_machine](https://docs.chef.io/inspec/resources/azure_sql_virtual_machine.md)                                                         | [azure_sql_virtual_machines](https://docs.chef.io/inspec/resources/azure_sql_virtual_machines.md)                                                         |
| [azure_sql_virtual_machine_group](https://docs.chef.io/inspec/resources/azure_sql_virtual_machine_group.md)                                             | [azure_sql_virtual_machine_groups](https://docs.chef.io/inspec/resources/azure_sql_virtual_machine_groups.md)                                             |
| [azure_sql_virtual_machine_group_availability_listener](https://docs.chef.io/inspec/resources/azure_sql_virtual_machine_group_availability_listener.md) | [azure_sql_virtual_machine_group_availability_listeners](https://docs.chef.io/inspec/resources/azure_sql_virtual_machine_group_availability_listeners.md) |
| [azure_storage_account_blob_container](https://docs.chef.io/inspec/resources/azure_storage_account_blob_container/)                                     | [azure_storage_account_blob_containers](https://docs.chef.io/inspec/resources/azure_storage_account_blob_containers/)                                     |
| [azure_storage_account](https://docs.chef.io/inspec/resources/azure_storage_account/)                                                                   | [azure_storage_accounts](https://docs.chef.io/inspec/resources/azure_storage_accounts/)                                                                   |
| [azure_streaming_analytics_function](https://docs.chef.io/inspec/resources/azure_streaming_analytics_function/)                                         | [azure_streaming_analytics_functions](https://docs.chef.io/inspec/resources/azure_streaming_analytics_functions/)                                         |
| [azure_subnet](https://docs.chef.io/inspec/resources/azure_subnet/)                                                                                     | [azure_subnets](https://docs.chef.io/inspec/resources/azure_subnets/)                                                                                     |
| [azure_subscription](https://docs.chef.io/inspec/resources/azure_subscription/)                                                                         | [azure_subscriptions](https://docs.chef.io/inspec/resources/azure_subscriptions/)                                                                         |
| [azure_synapse_notebook](https://docs.chef.io/inspec/resources/azure_synapse_notebook/)                                                                 | [azure_synapse_notebooks](https://docs.chef.io/inspec/resources/azure_synapse_notebooks/)                                                                 |
| [azure_synapse_workspace](https://docs.chef.io/inspec/resources/azure_synapse_workspace/)                                                               | [azure_synapse_workspaces](https://docs.chef.io/inspec/resources/azure_synapse_workspaces/)                                                               |
| [azure_virtual_machine](https://docs.chef.io/inspec/resources/azure_virtual_machine/)                                                                   | [azure_virtual_machines](https://docs.chef.io/inspec/resources/azure_virtual_machines/)                                                                   |
| [azure_virtual_machine_disk](https://docs.chef.io/inspec/resources/azure_virtual_machine_disk/)                                                         | [azure_virtual_machine_disks](https://docs.chef.io/inspec/resources/azure_virtual_machine_disks/)                                                         |
| [azure_virtual_network](https://docs.chef.io/inspec/resources/azure_virtual_network/)                                                                   | [azure_virtual_networks](https://docs.chef.io/inspec/resources/azure_virtual_networks/)                                                                   |
| [azure_virtual_network_gateway](https://docs.chef.io/inspec/resources/azure_virtual_network_gateway/)                                                   | [azure_virtual_network_gateways](https://docs.chef.io/inspec/resources/azure_virtual_network_gateways/)                                                   |
| [azure_virtual_network_gateway_connection](https://docs.chef.io/inspec/resources/azure_virtual_network_gateway_connection/)                             | [azure_virtual_network_gateway_connections](https://docs.chef.io/inspec/resources/azure_virtual_network_gateway_connections/)                             |
| [azure_virtual_network_peering](https://docs.chef.io/inspec/resources/azure_virtual_network_peering/)                                                   | [azure_virtual_network_peerings](https://docs.chef.io/inspec/resources/azure_virtual_network_peerings/)                                                   |
| [azure_virtual_wan](https://docs.chef.io/inspec/resources/azure_virtual_wan/)                                                                           | [azure_virtual_wans](https://docs.chef.io/inspec/resources/azure_virtual_wans/)                                                                           |
| [azure_web_app_function](https://docs.chef.io/inspec/resources/azure_web_app_function/)                                                                 | [azure_web_app_functions](https://docs.chef.io/inspec/resources/azure_web_app_functions/)                                                                 |
| [azure_webapp](https://docs.chef.io/inspec/resources/azure_webapp/)                                                                                     | [azure_webapps](https://docs.chef.io/inspec/resources/azure_webapps/)                                                                                     |


Please refer to the specific resource pages for more details and different use cases.

## Examples

### Ensure that all resources have specified names within the subscription regardless of type and resource Group

```ruby
azure_generic_resources(substring_of_name: 'NAME').ids.each do |id|
  describe azure_generic_resource(resource_id: id) do
    its('location') { should eq 'eastus' }
  end
end
```

### Ensure all resources has a specified tag defined regardless of the value

```ruby
azure_generic_resources(tag_name: 'NAME').ids.each do |id|
  describe azure_generic_resource(resource_id: id) do
    its('location') { should eq 'eastus' }
  end
end
```

### Verify Properties of an Azure Virtual Machine

```ruby
describe azure_virtual_machine(resource_group: 'RESOURCE_GROUP', name: 'NAME-WEB-01') do
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
describe azure_network_security_group(resource_group: 'RESOURCE_GROUP', name: 'NAME-SERVER') do
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

The generic resources and their derivations support the following parameters unless stated otherwise on their specific resource page.

### `api_version`

As an Azure resource provider enables new features, it releases a new version of the REST API. They are generally in the format of `2020-01-01`. InSpec Azure resources can be forced to use a specific version of the API to eliminate the behavioral changes between the tests using different API versions. The latest version is used unless a specific version is provided.

### User-Provided API Version

```ruby
describe azure_virtual_machine(resource_group: 'RESOURCE_GROUP', name: 'NAME', api_version: '2020-01-01') do
  its('api_version_used_for_query_state') { should eq 'user_provided' }
  its('api_version_used_for_query') { should eq '2020-01-01' }
end
```

### Pre-defined Default Api Version

`DEFAULT` api version can be used, if it is supported by the resource provider.

```ruby
describe azure_generic_resource(resource_provider: 'Microsoft.Compute/virtualMachines', name: 'NAME', api_version: 'DEFAULT') do
  its('api_version_used_for_query_state') { should eq 'DEFAULT' }
end
```

### Latest API Version

`LATEST` version is determined by this resource pack within the supported API versions. If the latest version is a `preview`, than an older, but a stable version might be used. Explicitly forcing to use the `LATEST` version.

```ruby
describe azure_virtual_networks(api_version: 'LATEST') do
  its('api_version_used_for_query_state') { should eq 'LATEST' }
end
```

`LATEST` version is used unless provided (Implicit).

```ruby
describe azure_network_security_groups(resource_group: 'RESOURCE_GROUP') do
  its('api_version_used_for_query_state') { should eq 'LATEST' }
end
```

`LATEST` version is used if the provided is invalid.

```ruby
describe azure_network_security_groups(resource_group: 'RESOURCE_GROUP', api_version: 'invalid_api_version') do
  its('api_version_used_for_query_state') { should eq 'LATEST' }
end
```

### endpoint

Microsoft Azure cloud services are available through a global and three national networks of the datacenter as described [here](https://docs.microsoft.com/en-us/graph/deployments). The preferred data center can be defined via `endpoint` parameter. Azure Global Cloud is used if not provided.

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

The pre-defined environment variables for each cloud deployment can be found [here](libraries/backend/helpers.rb).

### http_client parameters

The behavior of the HTTP client can be defined with the following parameters:

- `azure_retry_limit`: Maximum number of retries (default - `2`, Integer).
- `azure_retry_backoff`: Pause in seconds between retries (default - `0`, Integer).
- `azure_retry_backoff_factor`: The amount to multiply each successive retries interval amount by (default - `1`, Integer).

They can be defined as environment variables or resource parameters (has priority).

<hr>

> <b>WARNING</b> The following resources are using their `azure_` counterparts under the hood, and they will be deprecated in the InSpec Azure version **2**.
> Their API versions are fixed (see below) for full backward compatibility.
> It is strongly advised to start using the resources with `azure_` prefix for an up-to-date testing experience.

| Legacy Resource Name                                                              | Fixed [API version](#api_version)   | Replaced by                                                                                                                                                                                                                                    |
|-----------------------------------------------------------------------------------|-------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| azurerm_ad_user, azurerm_ad_users                                                 | `v1.0`                              | [azure_graph_user](https://docs.chef.io/inspec/resources/azure_graph_user/), [azure_graph_users](https://docs.chef.io/inspec/resources/azure_graph_users/)                                                                                     |
| azurerm_aks_cluster, azurerm_aks_clusters                                         | `2018-03-31`                        | [azure_aks_cluster](https://docs.chef.io/inspec/resources/azure_aks_cluster/), [azure_aks_cluster](https://docs.chef.io/inspec/resources/azure_aks_cluster/)                                                                                   |
| azurerm_api_management, azurerm_api_managements                                   | `2019-12-01`                        | [azure_api_management](https://docs.chef.io/inspec/resources/azure_api_management/), [azure_api_managements](https://docs.chef.io/inspec/resources/azure_api_managements/)                                                                     |
| azurerm_application_gateway, azurerm_application_gateways                         | `2019-12-01`                        | [azure_application_gateway](https://docs.chef.io/inspec/resources/azure_application_gateway/), [azure_application_gateways](https://docs.chef.io/inspec/resources/azure_application_gateways/)                                                 |
| azurerm_cosmosdb_database_account                                                 | `2015-04-08`                        | [azure_cosmosdb_database_account](https://docs.chef.io/inspec/resources/azure_cosmosdb_database_account/)                                                                                                                                      |
| azurerm_event_hub_authorization_rule                                              | `2017-04-01`                        | [azure_event_hub_authorization_rule](https://docs.chef.io/inspec/resources/azure_event_hub_authorization_rule/)                                                                                                                                |
| azurerm_event_hub_event_hub                                                       | `2017-04-01`                        | [azure_event_hub_event_hub](https://docs.chef.io/inspec/resources/azure_event_hub_event_hub/)                                                                                                                                                  |
| azurerm_event_hub_namespace                                                       | `2017-04-01`                        | [azure_event_hub_namespace](https://docs.chef.io/inspec/resources/azure_event_hub_namespace/)                                                                                                                                                  |
| azurerm_hdinsight_cluster                                                         | `2015-03-01-preview`                | [azure_hdinsight_cluster](https://docs.chef.io/inspec/resources/azure_hdinsight_cluster/)                                                                                                                                                      |
| azurerm_iothub                                                                    | `2018-04-01`                        | [azure_iothub](https://docs.chef.io/inspec/resources/azure_iothub/)                                                                                                                                                                            |
| azurerm_iothub_event_hub_consumer_group, azurerm_iothub_event_hub_consumer_groups | `2018-04-01`                        | [azure_iothub_event_hub_consumer_group](https://docs.chef.io/inspec/resources/azure_iothub_event_hub_consumer_group/), [azure_iothub_event_hub_consumer_groups](https://docs.chef.io/inspec/resources/azure_iothub_event_hub_consumer_groups/) |
| azurerm_key_vault, azurerm_key_vaults                                             | `2016-10-01`                        | [azure_key_vault](https://docs.chef.io/inspec/resources/azure_key_vault/), [azure_key_vaults](https://docs.chef.io/inspec/resources/azure_key_vaults/)                                                                                         |
| azurerm_key_vault_key, azurerm_key_vault_keys                                     | `2016-10-01`                        | [azure_key_vault_key](https://docs.chef.io/inspec/resources/azure_key_vault_key/), [azure_key_vault_keys](https://docs.chef.io/inspec/resources/azure_key_vault_keys/)                                                                         |
| azurerm_key_vault_secret, azurerm_key_vault_secrets                               | `2016-10-01`                        | [azure_key_vault_secret](https://docs.chef.io/inspec/resources/azure_key_vault_secret/), [azure_key_vault_secrets](https://docs.chef.io/inspec/resources/azure_key_vault_secrets/)                                                             |
| azurerm_load_balancer, azurerm_load_balancers                                     | `2018-11-01`                        | [azure_load_balancer](https://docs.chef.io/inspec/resources/azure_load_balancer/), [azure_load_balancers](https://docs.chef.io/inspec/resources/azure_load_balancers/)                                                                         |
| azurerm_locks                                                                     | `2016-09-01`                        | [azure_locks](https://docs.chef.io/inspec/resources/azure_locks/)                                                                                                                                                                              |
| azurerm_management_group, azurerm_management_groups                               | `2018-03-01-preview`                | [azure_management_group](https://docs.chef.io/inspec/resources/azure_management_group/), [azure_management_groups](https://docs.chef.io/inspec/resources/azure_management_groups/)                                                             |
| azurerm_mariadb_server, azurerm_mariadb_servers                                   | `2018-06-01-preview`                | [azure_mariadb_server](https://docs.chef.io/inspec/resources/azure_mariadb_server/), [azure_mariadb_servers](https://docs.chef.io/inspec/resources/azure_mariadb_servers/)                                                                     |
| azurerm_monitor_activity_log_alert, azurerm_monitor_activity_log_alerts           | `2017-04-01`                        | [azure_monitor_activity_log_alert](https://docs.chef.io/inspec/resources/azure_monitor_activity_log_alert/), [azure_monitor_activity_log_alerts](https://docs.chef.io/inspec/resources/azure_monitor_activity_log_alerts/)                     |
| azurerm_monitor_log_profile, azurerm_monitor_log_profiles                         | `2016-03-01`                        | [azure_monitor_log_profile](https://docs.chef.io/inspec/resources/azure_monitor_log_profile/), [azure_monitor_log_profiles](https://docs.chef.io/inspec/resources/azure_monitor_log_profiles/)                                                 |
| azurerm_mysql_database, azurerm_mysql_databases                                   | `2017-12-01`                        | [azure_mysql_database](https://docs.chef.io/inspec/resources/azure_mysql_database/), [azure_mysql_databases](https://docs.chef.io/inspec/resources/azure_mysql_databases/)                                                                     |
| azurerm_mysql_server, azurerm_mysql_servers                                       | `2017-12-01`                        | [azure_mysql_server](https://docs.chef.io/inspec/resources/azure_mysql_server/), [azure_mysql_servers](https://docs.chef.io/inspec/resources/azure_mysql_servers/)                                                                             |
| azurerm_network_interface, azurerm_network_interfaces                             | `2018-11-01`                        | [azure_network_interface](https://docs.chef.io/inspec/resources/azure_network_interface/), [azure_network_interfaces](https://docs.chef.io/inspec/resources/azure_network_interfaces/)                                                         |
| azurerm_network_security_group, azurerm_network_security_groups                   | `2018-02-01`                        | [azure_network_security_group](https://docs.chef.io/inspec/resources/azure_network_security_group/), [azure_network_security_groups](https://docs.chef.io/inspec/resources/azure_network_security_groups/)                                     |
| azurerm_network_watcher, azurerm_network_watchers                                 | `2018-02-01`                        | [azure_network_watcher](https://docs.chef.io/inspec/resources/azure_network_watcher/), [azure_network_watchers](https://docs.chef.io/inspec/resources/azure_network_watchers/)                                                                 |
| azurerm_postgresql_database, azurerm_postgresql_databases                         | `2017-12-01`                        | [azure_postgresql_database](https://docs.chef.io/inspec/resources/azure_postgresql_database/), [azure_postgresql_databases](https://docs.chef.io/inspec/resources/azure_postgresql_databases/)                                                 |
| azurerm_postgresql_server, azurerm_postgresql_servers                             | `2017-12-01`                        | [azure_postgresql_server](https://docs.chef.io/inspec/resources/azure_postgresql_server/), [azure_postgresql_servers](https://docs.chef.io/inspec/resources/azure_postgresql_servers/)                                                         |
| azurerm_public_ip                                                                 | `2020-05-01`                        | [azure_public_ip](https://docs.chef.io/inspec/resources/azure_public_ip/)                                                                                                                                                                      |
| azurerm_resource_groups                                                           | `2018-02-01`                        | [azure_resource_groups](https://docs.chef.io/inspec/resources/azure_resource_groups/)                                                                                                                                                          |
| azurerm_role_definition, azurerm_role_definitions                                 | `2015-07-01`                        | [azure_role_definition](https://docs.chef.io/inspec/resources/azure_role_definition/), [azure_role_definitions](https://docs.chef.io/inspec/resources/azure_role_definitions/)                                                                 |
| azurerm_security_center_policy, azurerm_security_center_policies                  | `2015-06-01-Preview`                | [azure_security_center_policy](https://docs.chef.io/inspec/resources/azure_security_center_policy/), [azure_security_center_policies](https://docs.chef.io/inspec/resources/azure_security_center_policies/)                                   |
| azurerm_sql_database, azurerm_sql_databases                                       | `2017-10-01-preview`                | [azure_sql_database](https://docs.chef.io/inspec/resources/azure_sql_database/), [azure_sql_databases](https://docs.chef.io/inspec/resources/azure_sql_databases/)                                                                             |
| azurerm_sql_server, azurerm_sql_servers                                           | `2018-06-01-preview`                | [azure_sql_server](https://docs.chef.io/inspec/resources/azure_sql_server/), [azure_sql_servers](https://docs.chef.io/inspec/resources/azure_sql_servers/)                                                                                     |
| azurerm_storage_account, azurerm_storage_accounts                                 | `2017-06-01`                        | [azure_storage_account](https://docs.chef.io/inspec/resources/azure_storage_account/), [azure_storage_accounts](https://docs.chef.io/inspec/resources/azure_storage_accounts/)                                                                 |
| azurerm_storage_account_blob_container, azurerm_storage_account_blob_containers   | `2018-07-01`                        | [azure_storage_account_blob_container](https://docs.chef.io/inspec/resources/azure_storage_account_blob_container/), [azure_storage_account_blob_containers](https://docs.chef.io/inspec/resources/azure_storage_account_blob_containers/)     |
| azurerm_subnet, azurerm_subnets                                                   | `2018-02-01`                        | [azure_subnet](https://docs.chef.io/inspec/resources/azure_subnet/), [azure_subnets](https://docs.chef.io/inspec/resources/azure_subnets/)                                                                                                     |
| azurerm_subscription                                                              | `2019-10-01`                        | [azure_subscription](https://docs.chef.io/inspec/resources/azure_subscription/)                                                                                                                                                                |
| azurerm_virtual_machine, azurerm_virtual_machines                                 | `2017-12-01`                        | [azure_virtual_machine](https://docs.chef.io/inspec/resources/azure_virtual_machine/), [azure_virtual_machines](https://docs.chef.io/inspec/resources/azure_virtual_machines/)                                                                 |
| azurerm_virtual_machine_disk, azurerm_virtual_machine_disks                       | `2017-03-30`                        | [azure_virtual_machine_disk](https://docs.chef.io/inspec/resources/azure_virtual_machine_disk/), [azure_virtual_machine_disks](https://docs.chef.io/inspec/resources/azure_virtual_machine_disks/)                                             |
| azurerm_virtual_network, azurerm_virtual_networks                                 | `2018-02-01`                        | [azure_virtual_network](https://docs.chef.io/inspec/resources/azure_virtual_network/), [azure_virtual_networks](https://docs.chef.io/inspec/resources/azure_virtual_networks/)                                                                 |
| azurerm_webapp, azurerm_webapps                                                   | `2016-08-01`                        | [azure_webapp](https://docs.chef.io/inspec/resources/azure_webapp/), [azure_webapps](https://docs.chef.io/inspec/resources/azure_webapps/)                                                                                                     |

## Development

If you would like to contribute to this project, please see [Contributing Rules](CONTRIBUTING.md).

For a detailed walk-through of resource creation, see the [Resource Creation Guide](dev-docs/resource_creation_guide.md).

### Developing a Static Resource

The static resource is an InSpec Azure resource that is used to interrogate a specific Azure resource, such as, `azure_virtual_machine`, `azure_key_vaults`. As opposed to the generic resources, they might have some static properties created by processing the dynamic properties of a resource, such as `azure_virtual_machine.admin_username`.

The easiest way to start by checking the existing static resources. They have detailed information on leveraging the backend class within their comments.

The common parameters are:

- `resource_provider`: Such as `Microsoft.Compute/virtualMachines`. It has to be hardcoded in the code by the resource author via the `specific_resource_constraint` method, and it should be the first parameter defined in the resource. This method includes user-supplied input validation.
- `display_name`: A generic one will be created unless defined.
- `required_parameters`: Define mandatory parameters. The `resource_group` and resource `name` in the singular resources are default mandatory in the base class.
- `allowed_parameters`: Define optional parameters. The `resource_group` is optional in plural resources, but this can be made mandatory in the static resource.
- `resource_uri`: Azure REST API URI of a resource. This parameter should be used when a resource does not reside in a resource group. It requires `add_subscription_id` to be set to either `true` or `false`. See [azure_policy_definition](libraries/azure_policy_definition.rb) and [azure_policy_definitions](libraries/azure_policy_definitions.rb).
- `add_subscription_id`: It indicates whether the subscription ID should be included in the `resource_uri` or not.

#### Singular Resources

The singular resource is used to test a specific resource of a specific type and should include all of the properties available, such as `azure_virtual_machine`.

- In most cases, `resource_group` and resource `name` should be required from the users, and a single API call would be enough for creating methods on the resource. See [azure_virtual_machine](libraries/azure_virtual_machine.rb) for a standard singular resource and how to create static methods from resource properties.
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

The following instructions helps you get your development environment setup to run integration tests.

Copy `.envrc-example` to `.envrc` and fill in the fields with the values from your account.

```bash
export AZURE_SUBSCRIPTION_ID=<subscription id>
export AZURE_CLIENT_ID=<client id>
export AZURE_TENANT_ID=<tenant id>
export AZURE_CLIENT_SECRET=<client secret>
```

For PowerShell, set the following environment variables.

```shell
$env:AZURE_SUBSCRIPTION_ID="<subscription id>"
$env:AZURE_CLIENT_ID="<client id>"
$env:AZURE_CLIENT_SECRET="<client secret>"
$env:AZURE_TENANT_ID="<tenant id>"
```

in order to run tests along with mock train URI

```bash
export RAKE_ENV=test
```

## Setup Azure CLI

- Follow the instructions for your platform [here](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
  - macOS: `brew update && brew install azure-cli`
- Login with the azure-cli
  - `rake azure:login`
- Verify azure-cli is logged in:
  - `az account show`

### Starting an Environment

First, ensure your system has [Terraform](https://www.terraform.io/intro/getting-started/install.html) installed.

This environment may be used to run your profile against or to run integration tests on it. We are using [Terraform workspaces](https://www.terraform.io/docs/state/workspaces.html) to allow teams to have unique environments without affecting each other.

### Direnv

[Direnv](https://direnv.net/) is used to initialize an environment variable `WORKSPACE` to your username. We recommend using `direnv` and allowing it to run in your environment. However, if you prefer to not use `direnv` you may also `source .envrc`.

### Rake Commands

Creating a new environment:

```shell
rake azure:login
rake tf:apply
```

Updating a running environment (For example, when you change the .tf file):

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

To run Rubocop and Syntax, check for Ruby and InSpec:

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

Note that in `zsh` you need to escape the `[`, `]` characters.

You may run selected multiple controls only:

```shell
rake test:integration[azure_aks_cluster,azure_virtual_machine]
```

To run lint and unit tests:

```shell
rake
```

### Optional Components

The creation of the following resources can be skipped if there are any resource constraints.

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
