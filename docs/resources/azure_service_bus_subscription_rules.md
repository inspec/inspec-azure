---
title: About the azure_service_bus_subscription_rules Resource
platform: azure
---

# azure_service_bus_subscription_rules

Use the `azure_service_bus_subscription_rules` InSpec audit resource to test properties related to all Azure Service Bus Subscription Rules.

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

An `azure_service_bus_subscription_rules` resource block returns all Azure Service Bus Subscription Rules.

`resource_group`, `namespace_name`, `subscription_name` and `topic_name` are required parameters.

```ruby
describe azure_service_bus_subscription_rules(resource_group: 'RESOURCE_GROUP', namespace_name: 'NAMESPACE_NAME', subscription_name: 'SUBSCRIPTION_NAME', topic_name: 'TOPIC_NAME') do
  #...
end
```

## Parameters
| Name           | Description                                                                      |
|----------------|----------------------------------------------------------------------------------|
| namespace_name | The namespace name.                                                              |
| subscription_name | The subscription name.                                                        |
| topic_name     | The topic name.                                                                  |
| resource_group | Azure resource group that the targeted resource resides in. `MyResourceGroup`    |

The parameter set optionally be provided for a valid query:
- `resource_group`, `namespace_name`, `subscription_name` and `topic_name`

## Properties

|Property                        | Description                                                            | Filter Criteria<superscript>*</superscript> |
|--------------------------------|------------------------------------------------------------------------|------------------|
| ids                            | A list of resource IDs.                                                | `id`             |
| names                          | A list of resource Names.                                              | `name`           |
| types                          | A list of the resource types.                                          | `type`           |
| properties                     | A list of Properties for all the Service Bus Subscription Rules.       | `properties`     |
| filterTypes                    | A list of the Filter types.                                            | `filterType`     |
| sqlFilter                      | A list of sqlFilters.                                                  | `sqlFilter`      |

<superscript>*</superscript> For information on how to use filter criteria on plural resources refer to [FilterTable usage](https://github.com/inspec/inspec/blob/master/dev-docs/filtertable-usage.md).

## Examples

### Test that there are Service Bus Subscription Rules that are of SQL Filter type.

```ruby
describe azure_service_bus_subscription_rules(resource_group: 'RESOURCE_GROUP', namespace_name: 'NAMESPACE_NAME', subscription_name: 'SUBSCRIPTION_NAME', topic_name: 'TOPIC_NAME').where(filterType: 'SqlFilter') do
  it { should exist }
end
```

## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](https://www.inspec.io/docs/reference/matchers/).

### exists

```ruby
# Should not exist if no Service Bus Subscription Rules are present
describe azure_service_bus_subscription_rules(resource_group: 'RESOURCE_GROUP', namespace_name: 'NAMESPACE_NAME', subscription_name: 'SUBSCRIPTION_NAME', topic_name: 'TOPIC_NAME') do
  it { should_not exist }
end
# Should exist if the filter returns at least one Service Bus Subscription Rules
describe azure_service_bus_subscription_rules(resource_group: 'RESOURCE_GROUP', namespace_name: 'NAMESPACE_NAME', subscription_name: 'SUBSCRIPTION_NAME', topic_name: 'TOPIC_NAME') do
  it { should exist }
end
```
## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be setup with a `reader` role on the subscription you wish to test.