---
title: About the azure_mysql_database Resource
platform: azure
---

# azure_mysql_database

Use the `azure_mysql_database` InSpec audit resource to test properties and configuration of an Azure MySQL Database on a MySQL Server.

## Azure REST API version, endpoint and http client parameters

This resource interacts with api versions supported by the resource provider.
The `api_version` can be defined as a resource parameter.
If not provided, the latest version will be used.
For more information, refer to [`azure_generic_resource`](azure_generic_resource.md).

Unless defined, `azure_cloud` global endpoint, and default values for the http client will be used.
For more information, refer to the resource pack [README](../../README.md). 

## Availability

### Installation

This resource is available in the [InSpec Azure resource pack](https://github.com/inspec/inspec-azure). 
For an example `inspec.yml` file and how to set up your Azure credentials, refer to resource pack [README](../../README.md#Service-Principal).

## Syntax

`resource_group`, `server_name` and `name` or the `resource_id` must be given as a parameter.
```ruby
describe azure_mysql_database(resource_group: 'inspec-rg', server_name: 'customer_server', name: 'order-db') do
  it { should exist }
end
```
```ruby
describe azure_mysql_database(resource_id: '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DBforMySQL/servers/{serverName}/databases/{databaseName}') do
  it { should exist }
end
```
## Parameters

| Name                           | Description                                                                       |
|--------------------------------|-----------------------------------------------------------------------------------|
| resource_group                 | Azure resource group that the targeted resource resides in. `MyResourceGroup`     |
| server_name                    | The name of the server on which the database resides. `serverName`                |
| name                           | The unique name of the database. `databaseName`                                   |
| database_name                  | Alias for the `name` parameter.                                                   |
| resource_id                    | The unique resource ID. `/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DBforMySQL/servers/{serverName}/databases/{databaseName}` |

Either one of the parameter sets can be provided for a valid query:
- `resource_id`
- `resource_group`, `server_name`, and `name`
- `resource_group`, `server_name`, and `database_name`

## Properties

| Property             | Description |
|----------------------|-------------|
| properties.charset   | The charset of the database. |

For properties applicable to all resources, such as `type`, `tags`, `id`, `properties`, refer to [`azure_generic_resource`](azure_generic_resource.md#properties).

Also, refer to [Azure documentation](https://docs.microsoft.com/en-us/rest/api/mysql/databases/get#database) for other properties available. 
Any attribute in the response may be accessed with the key names separated by dots (`.`).

## Examples

### Test the Name of a Resource
```ruby
describe azure_mysql_database(resource_group: 'inspec-rg', server_name: 'customer_server', name: 'order-db') do
  its('name')   { should be 'order-db' }
end
```
```ruby
describe azure_mysql_database(resource_id: '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DBforMySQL/servers/{serverName}/databases/order-db') do
  its('name')   { should be 'order-db' }
end
```
## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](https://docs.chef.io/inspec/matchers/).

### exists
```ruby
# If we expect the resource to always exist
describe azure_mysql_database(resource_group: 'inspec-rg', server_name: 'customer_server', name: 'order-db') do
  it { should exist }
end

# If we expect the resource to never exist
describe azure_mysql_database(resource_group: 'inspec-rg', server_name: 'customer_server', name: 'order-db') do
  it { should_not exist }
end
```
## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be setup with a `contributor` role on the subscription you wish to test.
