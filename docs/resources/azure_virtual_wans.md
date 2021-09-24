---
title: About the azure_virtual_wans Resource
platform: azure
---

# azure_virtual_wans

Use the `azure_virtual_wans` InSpec audit resource to test the properties related to all Azure Virtual WANs in a subscription.

## Azure REST API version, Endpoint, and HTTP Client Parameters

This resource interacts with API versions supported by the resource provider. You can define the `api_version` as a resource parameter. If not provided, the latest version is used. For more information, refer to [`azure_generic_resource`](azure_generic_resource.md).

Unless defined, `azure_cloud` global endpoint and default values for the HTTP client will be used. For more information, refer to the resource pack [README](../../README.md).

## Availability

### Installation

This resource is available in the [InSpec Azure resource pack](https://github.com/inspec/inspec-azure). For an example, `inspec.yml` file and how to set up your Azure credentials, refer to resource pack [README](../../README.md#Service-Principal).

## Syntax

An `azure_virtual_wans` resource block returns all Azure Virtual WANs in a subscription.

```ruby
describe azure_virtual_wans do
  #...
end
```

## Properties

|Property            | Description                                        | Filter Criteria<superscript>*</superscript> |
|--------------------|----------------------------------------------------|-----------------|
| ids                | A list of the unique resource ids.                 | `id`            |
| names              | A list of names for all the Resources.             | `name`          |
| etags              | A list of etag for all the Resources.              | `etag`          |
| types              | A list of types for all the resources.             | `type`          |
| locations          | A list of locations for all the resources.         | `location`      |
| properties         | A list of Properties all the resources.            | `properties`    |

<superscript>*</superscript> For information on how to use filter criteria on plural resources refer to [FilterTable usage](https://github.com/inspec/inspec/blob/master/dev-docs/filtertable-usage.md).

## Examples

### Test that the Virtual WAN type is Standard

```ruby
describe azure_virtual_wans.where{ properties.select{|prop| prop.type == 'Standard' } } do
  it { should exist }
end
```

## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](https://www.inspec.io/docs/reference/matchers/).

### exists

```ruby
# Should not exist if no virtual WANs are present
describe azure_virtual_wans do
  it { should_not exist }
end

# Should exist if the filter returns at least one virtual WAN
describe azure_virtual_wans do
  it { should exist }
end
```

## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be setup with a `contributor` role on the subscription you wish to test.
