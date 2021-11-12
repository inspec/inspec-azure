---
title: About the azure_sql_servers Resource
platform: azure
---

# azure_sql_servers

Use the `azure_sql_servers` InSpec audit resource to test properties and configuration of multiple Azure SQL Servers.

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

An `azure_sql_servers` resource block returns all Azure SQL Servers, either within a Resource Group (if provided), or within an entire Subscription.
```ruby
describe azure_sql_servers do
  it { should exist }
end
```
or
```ruby
describe azure_sql_servers(resource_group: 'my-rg') do
  it { should exist }
end
```
## Parameters

- `resource_group` (Optional)

## Properties

|Property       | Description                                                                          | Filter Criteria<superscript>*</superscript> |
|---------------|--------------------------------------------------------------------------------------|-----------------|
| ids           | A list of the unique resource ids.                                                   | `id`            |
| locations     | A list of locations for all the resources being interrogated.                        | `location`      |
| names         | A list of names of all the resources being interrogated.                             | `name`          |
| kinds         | A list of kinds of all the resources being interrogated.                             | `kind`          |
| tags          | A list of `tag:value` pairs defined on the resources.                                | `tags`          |
| skus          | A list of the SKUs (pricing tiers) of the servers.                                   | `sku`           |
| types         | A list of the types of resources being interrogated.                                 | `type`          |
| properties    | A list of properties for all the resources being interrogated.                       | `properties`    |

<superscript>*</superscript> For information on how to use filter criteria on plural resources refer to [FilterTable usage](https://github.com/inspec/inspec/blob/master/dev-docs/filtertable-usage.md).

## Examples

### Check a Specific SQL Server is Present
```ruby
describe azure_sql_servers do
  its('names')  { should include 'my-server-name' }
end
```
### Filters the Results to Include Only Those Servers which Include the Given Name (Client Side Filtering)
```ruby
describe azure_sql_servers.where{ name.include?('production') } do
  it { should exist }
end
```
## Filters the Results to Include Only Those Servers which Reside in a Given Location (Client Side Filtering)
```ruby
describe azure_sql_servers.where{ location.eql?('westeurope') } do
  it { should exist }
end
```    
## Filters the Results to Include Only Those Servers which Reside in a Given Location and Include the Given Name (Server Side Filtering - Recommended)
```ruby
describe azure_generic_resources(resource_provider: 'Microsoft.Sql/servers', substring_of_name: 'production', location: 'westeurope') do
  it {should exist}  
end
```
## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](https://www.inspec.io/docs/reference/matchers/).

### exists

The control will pass if the filter returns at least one result. Use `should_not` if you expect zero matches.
```ruby
describe azure_sql_servers do
  it { should exist }
end
```
## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be setup with a `contributor` role on the subscription you wish to test.
