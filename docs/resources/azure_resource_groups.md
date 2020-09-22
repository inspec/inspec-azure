---
title: About the azure_resource_groups Resource
platform: azure
---

# azure_resource_groups

Use the `azure_resource_groups` InSpec audit resource to test properties and configuration of multiple Azure resource groups.

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

An `azure_resource_groups` resource block returns all resource groups within a subscription.
```ruby
describe azure_resource_groups do
  it { should exist }
end
```
## Parameters

- None required.

## Properties

|Property       | Description                                                 | Filter Criteria<superscript>*</superscript> |
|---------------|-------------------------------------------------------------|-----------------|
| ids           | A list of the unique resource group ids.                    | `id`            |
| names         | A list of names of all the resource groups.                 | `name`          |
| tags          | A list of `tag:value` pairs defined on the resource groups. | `tags`          |
| locations     | A list of locations of all the resource groups.             | `location`      |

<superscript>*</superscript> For information on how to use filter criteria on plural resources refer to [FilterTable usage](https://github.com/inspec/inspec/blob/master/dev-docs/filtertable-usage.md).

## Examples

### Check a Specific Resource Group is Present
```ruby
describe azure_resource_groups do
  its('names')  { should include 'my-resource-group' }
end
```
### Filters the Results to Include Only Those Resource Groups which Include the Given Name
```ruby
describe azure_resource_groups.where{ name.include?('my-resource-group') } do
  it { should exist }
end
```
## Filters the Results to Include Only The Resource Groups that Have Certain Tag
```ruby
describe azure_resource_groups.where{ tags.has_key?('owner') && tags['owner'] == "InSpec" } do
  it { should exist }
  its('count') { should be 15 }
end
```    
## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](https://www.inspec.io/docs/reference/matchers/).

### exists

The control will pass if the filter returns at least one result. Use `should_not` if you expect zero matches.
```ruby
describe azure_resource_groups do
  it { should exist }
end
```
## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be setup with a `contributor` role on the subscription you wish to test.
