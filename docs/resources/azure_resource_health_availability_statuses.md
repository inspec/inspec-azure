---
title: About the azure_resource_health_availability_statuses Resource
platform: azure
---

# azure_resource_health_availability_statuses

Use the `azure_resource_health_availability_statuses` InSpec audit resource to test properties related to all Azure Availability Statuses for the subscription.

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

An `azure_resource_health_availability_statuses` resource block returns all Azure Availability Statuses within a Subscription.
```ruby
describe azure_resource_health_availability_statuses do
  #...
end
```

## Parameters

This resource does not expect any parameters.

## Properties

|Property            | Description                                                              | Filter Criteria<superscript>*</superscript> |
|--------------------|--------------------------------------------------------------------------|-----------------|
| ids                | A list of the Azure Resource Manager Identity for the availabilityStatuses resources.| `id`            |
| names              | current.                                                                 | `name`          |
| types              | Microsoft.ResourceHealth/AvailabilityStatuses.                           | `type`          |
| properties         | A list of Properties of availability state.                              | `properties`    |
| locations          | A list of Azure Resource Manager geo locations of the resource.          | `location`      |

<superscript>*</superscript> For information on how to use filter criteria on plural resources refer to [FilterTable usage](https://github.com/inspec/inspec/blob/master/dev-docs/filtertable-usage.md).

## Examples

### Loop through availability statuses by resource ID

```ruby
azure_resource_health_availability_statuses.ids.each do |id|
  describe azure_resource_health_availability_status(resource_id: id) do
    it { should exist }
  end
end
```

### Test that there are availability statuses that have an `Available` availability state

```ruby
describe azure_resource_health_availability_statuses.where{ properties.select{|prop| prop.availabilityState == 'Available' } } do
  it { should exist }
end
```

## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](https://www.inspec.io/docs/reference/matchers/).

### exists
```ruby
# Should not exist if no availability statuses are present in the subscription
describe azure_resource_health_availability_statuses do
  it { should_not exist }
end

# Should exist if the filter returns at least one availability status in the subscription
describe azure_resource_health_availability_statuses do
  it { should exist }
end
```
## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be setup with a `contributor` role on the subscription you wish to test.