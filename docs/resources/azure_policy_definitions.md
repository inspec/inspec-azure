---
title: About the azure_policy_definitions Resource
platform: azure
---

# azure_policy_definitions

Use the `azure_policy_definitions` InSpec audit resource to test properties and configuration of multiple Azure policy definitions.

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

An `azure_policy_definitions` resource block returns all policy definitions, either built-in (if `built_in_only: true`), or within a subscription.
```ruby
describe azure_policy_definitions do
  it { should exist }
end
```

or

```ruby
describe azure_policy_definitions(built_in_only: true) do
  it { should exist }
end
```

## Parameters

`built_in_only` _(optional)_

Indicates whether the interrogated policy definitions are built-in only. Defaults to `false` if not supplied.

## Properties

|Property       | Description                                                                          | Filter Criteria<superscript>*</superscript> |
|---------------|--------------------------------------------------------------------------------------|-----------------|
| ids           | A list of the unique resource ids.                                                   | `id`            |
| names         | A list of names of all the resources being interrogated.                             | `name`          |
| policy_types  | A list of policy types of all the resources.                                         | `policy_type`   |
| modes         | A list of modes of all the resources.                                                | `mode`          |
| metadata_versions|  A list of metadata versions of the resources.                                    | `metadata_version` |
| metadata_categories| A list of metadata categories of the resources.                                 | `metadata_category` |
| parameters    | A list of parameters of the resources.                                               | `parameters`    |
| policy_rules  | A list of policy rules of the resources.                                             | `policy_rule`   |
| properties    | A list of properties for all the resources being interrogated.                       | `properties`    |

<superscript>*</superscript> For information on how to use filter criteria on plural resources refer to [FilterTable usage](https://github.com/inspec/inspec/blob/master/dev-docs/filtertable-usage.md).

## Examples

### Check a Specific Policy Definition is Present
```ruby
describe azure_policy_definitions do
  its('names')  { should include 'my-policy' }
end
```
### Filters the Results to Include Only Those Policy Definitions which Include the Given Name
```ruby
describe azure_policy_definitions.where{ name.include?('my-policy') } do
  it { should exist }
end
```
## Filters the Results to Include Only The Custom Policy Definitions
```ruby
describe azure_policy_definitions.where(policy_type: "Custom") do
  it { should exist }
  its('count') { should be 15 }
end
```    
## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](https://www.inspec.io/docs/reference/matchers/).

### exists

The control will pass if the filter returns at least one result. Use `should_not` if you expect zero matches.
```ruby
describe azure_policy_definitions do
  it { should exist }
end
```
## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be setup with a `contributor` role on the subscription you wish to test.
