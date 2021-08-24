---
title: About the azure_subscriptions Resource
platform: azure
---

# azure_subscriptions

Use the `azure_subscriptions` InSpec audit resource to test properties and configuration of all Azure subscriptions for a tenant.

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

An `azure_subscriptions` resource block returns all subscription for a tenant.
```ruby
describe azure_subscriptions do
  it { should exist }
end
```
## Parameters

- This resource does not require any parameters.

## Properties

|Property       | Description                                                 | Filter Criteria<superscript>*</superscript> |
|---------------|-------------------------------------------------------------|-----------------|
| ids           | A list of the subscription ids.                             | `id`            |
| names         | A list of display names of all the subscriptions.           | `name`          |
| tags          | A list of `tag:value` pairs defined on the subscriptions.   | `tags`          |
| tenant_ids    | A list of tenant ids of all the subscriptions.              | `tenant_id`     |

<superscript>*</superscript> For information on how to use filter criteria on plural resources refer to [FilterTable usage](https://github.com/inspec/inspec/blob/master/dev-docs/filtertable-usage.md).

## Examples

### Check a Specific Subscription is Present
```ruby
describe azure_subscriptions do
  its('names')  { should include 'my-subscription' }
end
``` 
## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](https://www.inspec.io/docs/reference/matchers/).

### exists

The control will pass if the filter returns at least one result. Use `should_not` if you expect zero matches.
```ruby
describe azure_subscriptions do
  it { should exist }
end
```
## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be setup with a `contributor` role on the subscription you wish to test.
