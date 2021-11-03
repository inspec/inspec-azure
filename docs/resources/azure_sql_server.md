---
title: About the azure_sql_server Resource
platform: azure
---

# azure_sql_server

Use the `azure_sql_server` InSpec audit resource to test properties and configuration of an Azure SQL Server.

## Azure REST API Version, Endpoint, and HTTP Client Parameters

This resource interacts with API versions supported by the resource provider.
The `api_version` can be defined as a resource parameter.
If not provided, the latest version will be used.
For more information, refer to [`azure_generic_resource`](azure_generic_resource.md).

Unless defined, `azure_cloud` global endpoint and default values for the HTTP client will be used.
For more information, refer to the resource pack [README](../../README.md).

## Availability

### Installation

This resource is available in the [InSpec Azure resource pack](https://github.com/inspec/inspec-azure). 
For an example `inspec.yml` file and how to set up your Azure credentials, refer to resource pack [README](../../README.md#Service-Principal).

## Syntax

`resource_group` and `name` or the `resource_id` must be given as a parameter.
```ruby
describe azure_sql_server(resource_group: 'inspec-resource-group-9', name: 'example_server') do
  it { should exist }
end
```
```ruby
describe azure_sql_server(resource_id: '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.Sql/servers/{serverName}') do
  it { should exist }
end
```
## Parameters

| Name                                  | Description                                                                       |
|---------------------------------------|-----------------------------------------------------------------------------------|
| resource_group                        | Azure resource group that the targeted resource resides in. `MyResourceGroup`     |
| name                                  | Name of the SQL server to test. `MyServer`                                        |
| server_name                           | Alias for the `name` parameter.                                                   |
| resource_id                           | The unique resource ID. `/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.Sql/servers/{serverName}` |
| firewall_rules_api_version            | The endpoint api version for the `firewall_rules` property. The latest version will be used unless provided. |
| auditing_settings_api_version         | The endpoint api version for the `auditing_settings` property. The latest version will be used unless provided. |
| threat_detection_settings_api_version | The endpoint api version for the `threat_detection_settings` property. The latest version will be used unless provided. |
| administrators_api_version            | The endpoint api version for the `administrators` property. The latest version will be used unless provided. |
| encryption_protector_api_version      | The endpoint api version for the `encryption_protector` property. The latest version will be used unless provided. |

Either one of the parameter sets can be provided for a valid query:
- `resource_id`
- `resource_group` and `name`
- `resource_group` and `server_name`

## Properties

| Property          | Description |
|---------------------------|-------------|
| firewall_rules            | A list of all firewall rules in the targeted server with [these](https://docs.microsoft.com/en-us/rest/api/sql/firewallrules/listbyserver#firewallrulelistresult) properties. |
| administrators            | A list of all administrators for the targeted server with [these](https://docs.microsoft.com/en-us/rest/api/sql/serverazureadadministrators/listbyserver#serverazureadadministrator) properties. |
| encryption_protector      | A list of all encryption protectors for the targeted server with [these](https://docs.microsoft.com/en-us/rest/api/sql/encryptionprotectors/listbyserver#encryptionprotector) properties. |
| auditing_settings         | Auditing settings for the targeted server with [these](https://docs.microsoft.com/en-us/rest/api/sql/server%20auditing%20settings/listbyserver#serverblobauditingpolicylistresult) properties. |
| threat_detection_settings | Threat detection settings for the targeted server with [these](https://docs.microsoft.com/en-us/rest/api/sql/databasethreatdetectionpolicies/get#databasesecurityalertpolicy) properties. |
| sku                       | The SKU (pricing tier) of the server. |

For properties applicable to all resources, such as `type`, `name`, `id`, `properties`, refer to [`azure_generic_resource`](azure_generic_resource.md#properties).

Also, refer to [Azure documentation](https://docs.microsoft.com/en-us/rest/api/sql/servers/get#server) for other properties available. 
Any attribute in the response may be accessed with the key names separated by dots (`.`), eg. `properties.<attribute>`.

## Examples

### Test If a SQL Server is Referenced with a Valid Name
```ruby
describe azure_sql_server(resource_group: 'my-rg', name: 'sql-server-1') do
  it { should exist }
end
```
### Test If a SQL Server is Referenced with an Invalid Name
```ruby
describe azure_sql_server(resource_group: 'my-rg', name: 'i-dont-exist') do
  it { should_not exist }
end
```    
### Test If a SQL Server Has Firewall Rules Set
```ruby
describe azure_sql_server(resource_group: 'my-rg', name: 'my-server') do
  its('firewall_rules') { should_not be_empty }
end
```        
### Test a SQL Server's Location and Kind
```ruby
describe azure_sql_server(resource_id: '/subscriptions/.../my-server') do
  its('kind') { should cmp 'v12.0' }
  its('location') { should cmp 'westeurope' }
end
```
### Test a SQL Server's Auditing Settings
```ruby
describe azure_sql_server(resource_group: 'my-rg', name: 'my-server') do
  its('auditing_settings.properties.state') { should cmp 'Disabled' }
  its('auditing_settings.properties.retentionDays') { should be 0 }
  its('auditing_settings.properties.isStorageSecondaryKeyInUse') { should be false }
  its('auditing_settings.properties.isAzureMonitorTargetEnabled') { should be false }
end
```
## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](https://www.inspec.io/docs/reference/matchers/).

### exists
```ruby
# If we expect a resource to always exist
describe azure_sql_server(resource_group: 'my-rg', server_name: 'server-name-1') do
  it { should exist }
end
# If we expect a resource to never exist
describe azure_sql_server(resource_group: 'my-rg', server_name: 'server-name-1') do
  it { should_not exist }
end
```
## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be setup with a `contributor` role on the subscription you wish to test.
