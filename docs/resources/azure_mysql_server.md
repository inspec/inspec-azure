---
title: About the azure_mysql_server Resource
platform: azure
---

# azure_mysql_server

Use the `azure_mysql_server` InSpec audit resource to test properties and configuration of an Azure MySQL Server.

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
describe azure_mysql_server(resource_group: 'inspec-resource-group-9', name: 'example_server') do
  it { should exist }
end
```
```ruby
describe azure_mysql_server(resource_id: '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.DBforMySQL/servers/{serverName}') do
  it { should exist }
end
```
## Parameters

| Name                           | Description                                                                       |
|--------------------------------|-----------------------------------------------------------------------------------|
| resource_group                 | Azure resource group that the targeted resource resides in. `MyResourceGroup`     |
| name                           | Name of the MySql server to test. `MyServer`                                      |
| server_name                    | Name of the MySql server to test. `MyServer`. This is for backward compatibility, use `name` instead. |
| resource_id                    | The unique resource ID. `/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.DBforMySQL/servers/{serverName}` |
| firewall_rules_api_version     | The endpoint api version for the `firewall_rules` property. The latest version will be used unless provided. |

Either one of the parameter sets can be provided for a valid query:
- `resource_id`
- `resource_group` and `name`
- `resource_group` and `server_name`

## Properties

| Property          | Description |
|-------------------|-------------|
| firewall_rules    | A list of all firewall rules in the targeted server. |
| sku               | The SKU (pricing tier) of the server. |

For properties applicable to all resources, such as `type`, `name`, `id`, `properties`, refer to [`azure_generic_resource`](azure_generic_resource.md#properties).

Also, refer to [Azure documentation](https://docs.microsoft.com/en-us/rest/api/mysql/servers/get#server) for other properties available. 
Any attribute in the response may be accessed with the key names separated by dots (`.`).

## Examples

### Test If a MySQL Server is Referenced with a Valid Name
```ruby
describe azure_mysql_server(resource_group: 'my-rg', name: 'sql-server-1') do
  it { should exist }
end
```
### Test If a MySQL Server is Referenced with an Invalid Name
```ruby
describe azure_mysql_server(resource_group: 'my-rg', name: 'i-dont-exist') do
  it { should_not exist }
end
```    
### Test If a MySQL Server Has Firewall Rules Set
```ruby
describe azure_mysql_server(resource_group: 'my-rg', name: 'my-server') do
  its('firewall_rules') { should_not be_empty }
end
```        
### Test a MySQL Server's Fully Qualified Domain Name, Location and Public Network Access Status
```ruby
describe azure_mysql_server(resource_id: '/subscriptions/.../my-server') do
  its('properties.fullyQualifiedDomainName') { should eq 'my-server.mysql.database.azure.com' }
  its('properties.publicNetworkAccess') { should cmp 'Enabled' }
  its('location') { should cmp 'westeurope' }
end
```
## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](/inspec/matchers/).

### exists
```ruby
describe azure_mysql_server(resource_group: 'my-rg', server_name: 'server-name-1') do
  it { should exist }
end
```
## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be setup with a `contributor` role on the subscription you wish to test.
