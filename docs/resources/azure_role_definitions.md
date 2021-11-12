---
title: About the azure_role_definitions Resource
platform: azure
---

# azure_role_definitions

Use the `azure_role_definitions` InSpec audit resource to test properties and configuration of multiple Azure role definitions.

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

An `azure_role_definitions` resource block returns all role definitions within a subscription.
```ruby
describe azure_role_definitions do
  it { should exist }
end
```
## Parameters

- This resource does not require any parameters.

## Properties

|Property       | Description                                                                          | Filter Criteria<superscript>*</superscript> |
|---------------|--------------------------------------------------------------------------------------|-----------------|
| ids           | A list of the unique resource ids.                                                   | `id`            |
| names         | A list of names of all the resources being interrogated.                             | `name`          |
| role_names    | A list of role names of all the role definitions being interrogated.                 | `role_name`     |
| types         | A list of role type of all the role definitions being interrogated.                  | `type`          |
| properties    | A list of properties for all the resources being interrogated.                       | `properties`    |

<superscript>*</superscript> For information on how to use filter criteria on plural resources refer to [FilterTable usage](https://github.com/inspec/inspec/blob/master/dev-docs/filtertable-usage.md).

## Examples

### Check a Specific Role Definition is Present
```ruby
describe azure_role_definitions do
  its('names')  { should include 'my-role' }
end
```
### Filter the Results to Include Only Those Role Definitions which Include the Given Name
```ruby
describe azure_role_definitions.where{ name.include?('my-role') } do
  it { should exist }
end
```
## Filter the Results to Include Only The Built-in Role Definitions
```ruby
describe azure_role_definitions.where{ type == "BuiltInRole" } do
  it { should exist }
  its('count') { should be 15 }
end
``` 
## Filter the Results to Include Only the Role Definitions that Contain `Kubernetes` in the Role Name
```ruby
describe azure_role_definitions.where{ role_name.include?('Kubernetes') } do
  it { should exist }
  its('count') { should be 15 }
end
```    
## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](https://www.inspec.io/docs/reference/matchers/).

### exists

The control will pass if the filter returns at least one result. Use `should_not` if you expect zero matches.
```ruby
describe azure_role_definitions do
  it { should exist }
end
```
## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be setup with a `contributor` role on the subscription you wish to test.
