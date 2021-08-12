---
title: About the azure_resource_health_emerging_issues Resource
platform: azure
---

# azure_resource_health_emerging_issues

Use the `azure_resource_health_emerging_issues` InSpec audit resource to test properties related to all Azure Resource Health Emerging Issues.

## Azure REST API version, endpoint, and HTTP client parameters

This resource interacts with api versions supported by the resource provider.
The `api_version` can be defined as a resource parameter.
If not provided, the latest version will be used.
For more information, refer to [`azure_generic_resource`](azure_generic_resource.md).

Unless defined, `azure_cloud` global endpoint, and default values for the HTTP client will be used.
For more information, refer to the resource pack [README](../../README.md).

## Availability

### Installation

This resource is available in the [InSpec Azure resource pack](https://github.com/inspec/inspec-azure).
For an example `inspec.yml` file and how to set up your Azure credentials, refer to resource pack [README](../../README.md#Service-Principal).

## Syntax

An `azure_resource_health_emerging_issues` resource block returns all Azure Resource Health Emerging Issues.

```ruby
describe azure_resource_health_emerging_issues do
  #...
end
```

## Parameters

This resource does not require any parameters.

## Properties

|Property            | Description                                        | Filter Criteria<superscript>*</superscript> |
|--------------------|----------------------------------------------------|-----------------|
| ids                | A list of the unique resource IDs.                 | `id`            |
| names              | A list of names for all the resources.             | `name`          |
| types              | A list of types for all the resources.             | `type`          |
| properties         | A list of Properties all the resources.            | `properties`    |


<superscript>*</superscript> For information on how to use filter criteria on plural resources refer to [FilterTable usage](https://github.com/inspec/inspec/blob/master/dev-docs/filtertable-usage.md).

See [Azure's documentation](https://docs.microsoft.com/en-us/rest/api/resourcehealth/emerging-issues/get) for other available properties.

## Examples

### Test that there are emerging health issues that are of lower severity

```ruby
describe azure_resource_health_emerging_issues.where{ properties.select{|prop| prop.statusActiveEvents.select{ |event| event.severity == 'Warning' } } } do
  it { should exist }
end
```

## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](https://www.inspec.io/docs/reference/matchers/).

### exists

```ruby
# Should not exist if no service health emerging issues are present
describe azure_resource_health_emerging_issues do
  it { should_not exist }
end
# Should exist if the filter returns at least one service health emerging issues
describe azure_resource_health_emerging_issues do
  it { should exist }
end
```

## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be setup with a `contributor` role on the subscription you wish to test.