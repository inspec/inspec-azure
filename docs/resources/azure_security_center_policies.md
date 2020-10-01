---
title: About the azure_security_center_policies Resource
platform: azure
---

# azure_security_center_policies

Use the `azure_security_center_policies` InSpec audit resource to test properties and configuration of multiple Azure Polices.

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

An `azure_subscriptions` resource block returns all security policies for a subscription.
```ruby
describe azure_security_center_policies do
  it { should exist }
end
```
## Parameters

- This resource does not require any parameters.

## Properties

|Property       | Description                                                                          | Filter Criteria<superscript>*</superscript> |
|---------------|--------------------------------------------------------------------------------------|-----------------|
| ids           | A list of the unique resource ids.                                                   | `id`            |
| policy_names  | A list of names of all the resources being interrogated.                             | `name`          |
| properties    | A list of properties for all the resources being interrogated.                       | `properties`    |

<superscript>*</superscript> For information on how to use filter criteria on plural resources refer to [FilterTable usage](https://github.com/inspec/inspec/blob/master/dev-docs/filtertable-usage.md).

## Examples

### Check If a Specific Policy is Present
```ruby
describe azure_security_center_policies do
  its('names')  { should include 'my-policy' }
end
```
### Filter the Results to Include Only Those Policies which Include a Given String in Their Names
```ruby
describe azure_security_center_policies.where{ name.include?('production') } do
  it { should exist }
end
```
## Filter the Results to Include Only Those Policies that the Log Collection is Enabled
```ruby
describe azure_security_center_policies.where{ properties[:logCollection] == 'On' } do
  it { should exist }
  its('count') { should eq 4 }
end
```    
## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](https://www.inspec.io/docs/reference/matchers/).

### exists

The control will pass if the filter returns at least one result. Use `should_not` if you expect zero matches.
```ruby
describe azure_security_center_policies do
  it { should exist }
end
```
## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be setup with a `contributor` role on the subscription you wish to test.
