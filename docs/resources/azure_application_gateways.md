---
title: About the azure_application_gateways Resource
platform: azure
---

# azure_application_gateways

Use the `azure_application_gateways` InSpec audit resource to test properties and configuration of Azure Application Gateways.

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

An `azure_application_gateways` resource block returns all Azure Application Gateways, either within a Resource Group (if provided), or within an entire Subscription.
```ruby
describe azure_application_gateways do
  #...
end
```
or
```ruby
describe azure_application_gateways(resource_group: 'my-rg') do
  #...
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
| tags          | A list of `tag:value` pairs defined on the resources being interrogated.             | `tags`          |
| types         | A list of the types of resources being interrogated.                                 | `type`          |
| properties    | A list of properties for all the resources being interrogated.                       | `properties`    |

<superscript>*</superscript> For information on how to use filter criteria on plural resources refer to [FilterTable usage](https://github.com/inspec/inspec/blob/master/dev-docs/filtertable-usage.md).

## Examples

### Check Application Gateways are Present
```ruby
describe azure_application_gateways do
  it            { should exist }
  its('names')  { should include 'my-appgw' }
end
```
### Filter the Results to Include Only those with Names Match the Given String Value
```ruby
describe azure_application_gateways.where{ name.eql?('production-appgw-01') } do
  it { should exist }
end
```
## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](https://www.inspec.io/docs/reference/matchers/).

### exists

The control will pass if the filter returns at least one result. Use `should_not` if you expect zero matches.
```ruby
# If we expect 'ExampleGroup' Resource Group to have Application Gateways
describe azure_application_gateways(resource_group: 'ExampleGroup') do
  it { should exist }
end

# If we expect 'EmptyExampleGroup' Resource Group to not have Application Gateways
describe azure_application_gateways(resource_group: 'EmptyExampleGroup') do
  it { should_not exist }
end
```
## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be setup with a `contributor` role on the subscription you wish to test.
