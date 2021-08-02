---
title: About the azure_resource_health_events Resource
platform: azure
---

# azure_resource_health_events

Use the `azure_resource_health_events` InSpec audit resource to test properties related to all Azure Resource Health events for the subscription.

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

An `azure_resource_health_events` resource block returns all Azure Resource Health events within a subscription or for a particular resource.

```ruby
describe azure_resource_health_events do
  #...
end
```

```ruby
describe azure_resource_health_events(resource_group: 'rhctestenv', resource_type: 'Microsoft.Compute/virtualMachines', resource_id: 'rhctestenvV1PI') do
  #...
end
```

## Parameters

**Note**

To list all service health events in a subscription, do not provide any parameters.
To list events for a particular resource, pass in all three parameters listed below.
If one or more parameters are missing then all events in a subscription will be returned.

| Name                           | Description                                                                          |
|--------------------------------|--------------------------------------------------------------------------------------|
| resource_group                 | Azure resource group that the targeted resource resides in.                          |
| resource_type                  | The name of the resource type.                                                       |
| resource_id                    | The unique identifier of the resource.                                               |

## Properties

|Property            | Description                                        | Filter Criteria<superscript>*</superscript> |
|--------------------|----------------------------------------------------|-----------------|
| ids                | A list of the unique resource IDs.                 | `id`            |
| names              | A list of names for all the resources.             | `name`          |
| types              | A list of types for all the resources.             | `type`          |
| properties         | A list of properties for all the resources.        | `properties`    |


<superscript>*</superscript> For information on how to use filter criteria on plural resources refer to [FilterTable usage](https://github.com/inspec/inspec/blob/master/dev-docs/filtertable-usage.md).

See the [Azure documentation](https://docs.microsoft.com/en-us/rest/api/resourcehealth/events/list-by-single-resource) for other available properties.

## Examples

### Test that there are health events that have a service issue

```ruby
describe azure_resource_health_events.where{ properties.select{|prop| prop.eventType == 'ServiceIssue' } } do
  it { should exist }
end
```

## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](https://www.inspec.io/docs/reference/matchers/).

### exists

```ruby
# Should not exist if no service health events are present in the subscription
describe azure_resource_health_events do
  it { should_not exist }
end

# Should exist if the filter returns at least one service health events in the subscription
describe azure_resource_health_events do
  it { should exist }
end
```

## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be setup with a `contributor` role on the subscription you wish to test.