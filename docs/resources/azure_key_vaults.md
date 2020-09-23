---
title: About the azure_key_vaults Resource
platform: azure
---

# azure_key_vaults

Use the `azure_key_vaults` InSpec audit resource to test properties related to key vaults for a resource group or the entire subscription.

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

An `azure_key_vaults` resource block returns all Azure key vaults, either within a Resource Group (if provided), or within an entire Subscription.
```ruby
describe azure_key_vaults do
  #...
end
```
or
```ruby
describe azure_key_vaults(resource_group: 'my-rg') do
  #...
end
```
## Parameters

- `resource_group` (Optional)

## Properties

|Property       | Description                                                                          | Filter Criteria<superscript>*</superscript> |
|---------------|--------------------------------------------------------------------------------------|-----------------|
| ids           | A list of the unique resource ids.                                                   | `id`            |
| names         | A list of all the key vault names.                                                   | `name`          |
| tags          | A list of `tag:value` pairs defined on the resources.                                | `tags`          |
| types         | A list of types of all the key vaults.                                               | `type`          |
| locations     | A list of locations for all the key vaults.                                          | `location`      |
| properties    | A list of properties for all the key vaults.                                         | `properties`    |

<superscript>*</superscript> For information on how to use filter criteria on plural resources refer to [FilterTable usage](https://github.com/inspec/inspec/blob/master/dev-docs/filtertable-usage.md).
  
## Examples

### Loop through Key Vaults by Their Ids  
```ruby
azure_key_vaults.ids.each do |id|
  describe azure_key_vault(resource_id: id) do
    it { should exist }
  end
end  
```     
### Test that There are Key Vaults that Includes a Certain String in their Names (Client Side Filtering)   
```ruby
describe azure_key_vaults.where { name.include?('deployment') } do
  it { should exist }
end
```    
### Test that There are Key Vaults that Includes a Certain String in their Names (Server Side Filtering via Generic Resource - Recommended)   
```ruby
describe azure_generic_resources(resource_provider: 'Microsoft.KeyVault/vaults', substring_of_name: 'deployment') do
  it { should exist }
end
```
## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](https://www.inspec.io/docs/reference/matchers/).

### exists
```ruby
# Should not exist if no key vaults are in the resource group
describe azure_key_vaults(resource_group: 'MyResourceGroup') do
  it { should_not exist }
end

# Should exist if the filter returns at least one key vault
describe azure_key_vaults(resource_group: 'MyResourceGroup') do
  it { should exist }
end
```
## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be setup with a `contributor` role on the subscription you wish to test.
