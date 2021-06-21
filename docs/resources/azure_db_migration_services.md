---
title: About the azure_db_migration_services Resource
platform: azure
---

# azure_db_migration_services

Use the `azure_db_migration_services` InSpec audit resource to test properties related to Azure DB Migration Service for a resource group or the entire subscription.

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

An `azure_db_migration_services` resource block returns all Azure DB Migration Services within a Resource Group.
```ruby
describe azure_db_migration_services(resource_group: 'my-rg') do
  #...
end
```
or
```ruby
describe azure_db_migration_services(resource_group: 'my-rg') do
  #...
end
```
## Parameters

- `resource_group`

## Properties

|Property            | Description                                        | Filter Criteria<superscript>*</superscript> |
|--------------------|----------------------------------------------------|-----------------|
| ids                | A list of the unique resource ids.                 | `id`            |
| names              | A list of name for all the Resource names.         | `name`          |
| types              | A list of types for all the resources.             | `type`          |
| locations          | A list of locations for all the resources.         | `location`      |
| kinds              | A list of kinds for all the resources.             | `kind`          |
| etags              | A list of HTTP strong entity tag value.            | `etag`          |
| tags               | A list of resource tags.                           | `tags`          |
| sku_names          | A list of SKU names.                               | `sku_name`      |
| sku_sizes          | A list of SKU sizes.                               | `sku_sizes`     |
| sku_tiers          | A list of SKU tiers.                               | `sku_tiers`     |
| provisioning_states| A list of provisioning_states from the properties. | `provisioning_state` |
| virtual_nic_ids    | A list of virtual nic IDs from the properties.     | `virtual_nic_id` |
| virtual_subnet_ids | A list of vitual subnet IDs from the properties.   | `virtual_subnet_id` |

<superscript>*</superscript> For information on how to use filter criteria on plural resources refer to [FilterTable usage](https://github.com/inspec/inspec/blob/master/dev-docs/filtertable-usage.md).

## Examples

### Loop through DB Migration Services by Their Names
```ruby
azure_db_migration_services(resource_group: 'my-rg').names.each do |name|
  describe azure_db_migration_service(service_name: name) do
    it { should exist }
  end
end  
```     
### Test that There are DB migration services that Includes a Certain String in their Names (Client Side Filtering)
```ruby
describe azure_db_migration_services(resource_group: 'my-rg').where { name.include?('UAT') } do
  it { should exist }
end
```    

## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](https://www.inspec.io/docs/reference/matchers/).

### exists
```ruby
# Should not exist if no db migration service are in the resource group
describe azure_db_migration_services(resource_group: 'my-rg') do
  it { should_not exist }
end

# Should exist if the filter returns at least one db migration service
describe azure_db_migration_services(resource_group: 'my-rg') do
  it { should exist }
end
```
## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be setup with a `contributor` role on the subscription you wish to test.
