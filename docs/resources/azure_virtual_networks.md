---
title: About the azure_virtual_networks Resource
platform: azure
---

# azure_virtual_networks

Use the `azure_virtual_networks` InSpec audit resource to test properties related to virtual networks within your subscription.

## Azure REST API version, endpoint and http client parameters

This resource interacts with api versions supported by the resource provider.
The `api_version` can be defined as a resource parameter.
If not provided, the latest version will be used.
For more information, refer to [`azure_generic_resource`](azure_generic_resource.md).

Unless defined, `azure_cloud` global endpoint, and default values for the http client will be used .
For more information, refer to the resource pack [README](../../README.md). 

## Availability

### Installation

This resource is available in the `inspec-azure` [resource pack](/inspec/glossary/#resource-pack). 
For an example `inspec.yml` file and how to set up your Azure credentials, refer to resource pack [README](../../README.md#Service-Principal).

### Version

This resource first became available in X.Y.Z of the InSpec Azure resource pack.

## Syntax

An `azure_virtual_networks` resource block returns all Azure virtual networks, either within a Resource Group (if provided), or within an entire Subscription.
```ruby
describe azure_virtual_networks do
  #...
end
```
or
```ruby
describe azure_virtual_networks(resource_group: 'my-rg') do
  #...
end
```
## Parameters

- `resource_group` (Optional)

## Properties

|Property       | Description                                                                          | Filter Criteria<superscript>*</superscript> |
|---------------|--------------------------------------------------------------------------------------|-----------------|
| ids           | A list of the unique resource ids.                                                   | `id`            |
| locations     | A list of locations for all the virtual networks.                                    | `location`      |
| names         | A list of all the virtual network names.                                             | `name`          |
| tags          | A list of `tag:value` pairs defined on the resources.                                | `tags`          |
| etags         | A list of etags defined on the resources.                                            | `etag`          |

<superscript>*</superscript> For information on how to use filter criteria on plural resources refer to [FilterTable usage](https://github.com/inspec/inspec/blob/master/docs/dev/filtertable-usage.md#a-where-method-you-can-call-with-hash-params-with-loose-matching).

## Examples

### Exists If Any Virtual Networks Exist in the Resource Group
```ruby
describe azure_virtual_networks(resource_group: 'MyResourceGroup') do
  it { should exist }
end
```
### Filters the Results to Only Those that Match the Given Name (Client Side)
```ruby
# Insist that MyVnetName exists
describe azure_virtual_networks(resource_group: 'MyResourceGroup').where(name: 'MyVnetName') do
  it { should exist }
end
```
```ruby
# Insist that you have at least one virtual network that starts with 'prefix'
describe azure_virtual_networks(resource_group: 'MyResourceGroup').where { name.include?('project_A') } do
  it { should exist }
end
```
### Filters the Networks at Azure API to Only Those that Match the Given Name via Generic Resource (Recommended)
```ruby
# Fuzzy string matching
describe azure_generic_resources(resource_group: 'MyResourceGroup', resource_provider: 'Microsoft.Network/virtualNetworks', substring_of_name: 'project_A') do
  it { should exist }
end
```
```ruby
# Exact name matching
describe azure_generic_resources(resource_group: 'MyResourceGroup', resource_provider: 'Microsoft.Network/virtualNetworks', name: 'MyVnetName') do
  it { should exist }
end
```    
## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](https://www.inspec.io/docs/reference/matchers/).

### exists
```ruby
# Should not exist if no virtual networks are in the resource group
describe azure_virtual_networks(resource_group: 'MyResourceGroup') do
  it { should_not exist }
end
```
## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be setup with a `contributor` role on the subscription you wish to test.
