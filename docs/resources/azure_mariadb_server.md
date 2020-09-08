---
title: About the azure_mariadb_server Resource
platform: azure
---

# azure_mariadb_server

Use the `azure_mariadb_server` InSpec audit resource to test properties and configuration of an Azure MariaDB Server.

## Azure REST API version, endpoint and http client parameters

This resource interacts with api versions supported by the resource provider.
The `api_version` can be defined as a resource parameter.
If not provided, the latest version will be used.
For more information, refer to [`azure_generic_resource`](azure_generic_resource.md).

Unless defined, `azure_cloud` global endpoint, and default values for the http client will be used .
For more information, refer to the resource pack [README](../../README.md). 

## Availability

### Installation

This resource is available in the [InSpec Azure resource pack](https://github.com/inspec/inspec-azure). 
For an example `inspec.yml` file and how to set up your Azure credentials, refer to resource pack [README](../../README.md#Service-Principal).

## Syntax

`resource_group` and `name` or the `resource_id` must be given as a parameter.
```ruby
describe azure_mariadb_server(resource_group: 'inspec-resource-group-9', name: 'example_server') do
  it { should exist }
end
```
```ruby
describe azure_mariadb_server(resource_id: '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.DBforMariaDB/servers/{serverName}') do
  it { should exist }
end
```
## Parameters

| Name                           | Description                                                                       |
|--------------------------------|-----------------------------------------------------------------------------------|
| resource_group                 | Azure resource group that the targeted resource resides in. `MyResourceGroup`     |
| name                           | Name of the MariaDB server to test. `MyServer`                                    |
| server_name                    | Alias for the `name` parameter.                                                   |
| resource_id                    | The unique resource ID. `/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.DBforMariaDB/servers/{serverName}` |

Either one of the parameter sets can be provided for a valid query:
- `resource_id`
- `resource_group` and `name`
- `resource_group` and `server_name`

## Properties

| Property          | Description |
|-------------------|-------------|
| firewall_rules    | A list of all firewall rules in the targeted server. |
| sku               | The SKU (pricing tier) of the server.                |

For properties applicable to all resources, such as `type`, `name`, `id`, `properties`, refer to [`azure_generic_resource`](azure_generic_resource.md#properties).

Also, refer to [Azure documentation](https://docs.microsoft.com/en-us/rest/api/mariadb/servers/get#server) for other properties available. 
Any attribute in the response may be accessed with the key names separated by dots (`.`).

## Examples

### Test If a MariaDB Server is Referenced with a Valid Name
```ruby
describe azure_mariadb_server(resource_group: 'my-rg', name: 'sql-server-1') do
  it { should exist }
end
```
### Test If a MariaDB Server is Referenced with an Invalid Name
```ruby
describe azure_mariadb_server(resource_group: 'my-rg', name: 'i-dont-exist') do
  it { should_not exist }
end
```    
### Test If a MariaDB Server Has Firewall Rules Set
```ruby
describe azure_mariadb_server(resource_group: 'my-rg', name: 'my-server') do
  its('firewall_rules') { should_not be_empty }
end
```        
### Test a MariaDB Server's Location and Maximum Replica Capacity
```ruby
describe azure_mariadb_server(resource_id: '/subscriptions/.../my-server') do
  its('properties.replicaCapacity') { should cmp 2 }
  its('location') { should cmp 'westeurope' }
end
```
## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](/inspec/matchers/).

### exists
```ruby
# If we expect a resource to always exist
describe azure_mariadb_server(resource_group: 'my-rg', server_name: 'server-name-1') do
  it { should exist }
end
# If we expect a resource to never exist
describe azure_mariadb_server(resource_group: 'my-rg', server_name: 'server-name-1') do
  it { should_not exist }
end
```
## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be setup with a `contributor` role on the subscription you wish to test.
