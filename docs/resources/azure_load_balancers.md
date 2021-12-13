---
title: About the azure_load_balancers Resource
platform: azure
---

# azure_load_balancers

Use the `azure_load_balancers` InSpec audit resource to test properties and configuration of Azure Load Balancers.

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

An `azure_load_balancers` resource block returns all Azure Load Balancers, either within a Resource Group (if provided), or within an entire Subscription.
```ruby
describe azure_load_balancers do
  #...
end
```
or
```ruby
describe azure_load_balancers(resource_group: 'my-rg') do
  #...
end
```
## Parameters

`resource_group` _(optional)_

The name of the resource group.

## Properties

|Property       | Description                                                                          | Filter Criteria<superscript>*</superscript> |
|---------------|--------------------------------------------------------------------------------------|-----------------|
| ids           | A list of the unique resource ids.                                                   | `id`            |
| locations     | A list of locations for all the resources being interrogated.                        | `location`      |
| names         | A list of names of all the resources being interrogated.                             | `name`          |
| tags          | A list of `tag:value` pairs defined on the resources being interrogated.             | `tags`          |
| types         | A list of the types of resources being interrogated.                                 | `type`          |
| properties    | A list of properties for all the resources being interrogated.                       | `properties`    |
| skus          | A list of the SKUs of the resources being interrogated.                              | `sku`           |

<superscript>*</superscript> For information on how to use filter criteria on plural resources refer to [FilterTable usage](https://github.com/inspec/inspec/blob/master/dev-docs/filtertable-usage.md).

## Examples

### Check Load balancers are Present
````ruby
describe azure_load_balancers do
    it            { should exist }
    its('names')  { should include 'my-lb' }
end
````
### Filter the Results to Include Only those with Names Match the Given String Value
```ruby
describe azure_load_balancers.where{ name.eql?('production-lb') } do
  it { should exist }
end
```
### Filter the Results to Include Only those with Location Match the Given String Value
```ruby
describe azure_load_balancers.where{ location.eql?('eastus-2') } do
  it { should exist }
end
```
## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](https://www.inspec.io/docs/reference/matchers/).

### exists

The control will pass if the filter returns at least one result. Use `should_not` if you expect zero matches.
```ruby
# If we expect 'ExampleGroup' Resource Group to have Load Balancers
describe azure_load_balancers(resource_group: 'ExampleGroup') do
  it { should exist }
end

# If we expect 'EmptyExampleGroup' Resource Group to not have Load Balancers
describe azure_load_balancers(resource_group: 'ExampleGroup') do
  it { should_not exist }
end
```
## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be setup with a `contributor` role on the subscription you wish to test.
