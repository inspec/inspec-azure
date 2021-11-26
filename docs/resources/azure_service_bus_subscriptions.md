---
title: About the azure_service_bus_subscriptions Resource
platform: azure
---

# azure_service_bus_subscriptions

Use the `azure_service_bus_subscriptions` InSpec audit resource to test properties related to all Azure Service Bus Subscriptions.

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

An `azure_service_bus_subscriptions` resource block returns all Azure Service Bus Subscriptions.

`resource_group`, `namespace_name` and `topic_name` are required parameters.

```ruby
describe azure_service_bus_subscriptions(resource_group: 'RESOURCE_GROUP', namespace_name: 'NAMESPACE_NAME', topic_name: 'TOPIC_NAME') do
  #...
end
```

## Parameters
| Name           | Description                                                                      |
|----------------|----------------------------------------------------------------------------------|
| namespace_name | The namespace name.                                                              |
| topic_name     | The topic name.                                                                  |
| resource_group | Azure resource group that the targeted resource resides in. `MyResourceGroup`    |

The parameter set optionally be provided for a valid query:
- `resource_group`, `namespace_name` and `topic_name`

## Properties

|Property                        | Description                                                            | Filter Criteria<superscript>*</superscript> |
|--------------------------------|------------------------------------------------------------------------|------------------|
| ids                            | A list of resource IDs.                                                | `id`             |
| names                          | A list of resource Names.                                              | `name`           |
| types                          | A list of the resource types.                                          | `type`           |
| properties                     | A list of Properties for all the Service Bus Subscriptions.            | `properties`     |
| lockDurations                  | A list of the lock duration timespans.                                 | `lockDuration`     |
| statuses                       | A list of statuses of a messaging entity.                              | `status`      |

<superscript>*</superscript> For information on how to use filter criteria on plural resources refer to [FilterTable usage](https://github.com/inspec/inspec/blob/master/dev-docs/filtertable-usage.md).

## Examples

### Test that there are Service Bus Subscriptions that are Active.

```ruby
describe azure_service_bus_subscriptions(resource_group: 'RESOURCE_GROUP', namespace_name: 'NAMESPACE_NAME', topic_name: 'TOPIC_NAME').where(status: 'Active') do
  it { should exist }
end
```

## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](https://www.inspec.io/docs/reference/matchers/).

### exists

```ruby
# Should not exist if no Service Bus Subscriptions are present
describe azure_service_bus_subscriptions(resource_group: 'RESOURCE_GROUP', namespace_name: 'NAMESPACE_NAME', topic_name: 'TOPIC_NAME') do
  it { should_not exist }
end
# Should exist if the filter returns at least one Service Bus Subscriptions
describe azure_service_bus_subscriptions(resource_group: 'RESOURCE_GROUP', namespace_name: 'NAMESPACE_NAME', topic_name: 'TOPIC_NAME') do
  it { should exist }
end
```
## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be setup with a `reader` role on the subscription you wish to test.