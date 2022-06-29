+++
title = "azure_event_hub_namespace Resource"
platform = "azure"
draft = false
gh_repo = "inspec-azure"

[menu.inspec]
title = "azure_event_hub_namespace"
identifier = "inspec/resources/azure/azure_event_hub_namespace Resource"
parent = "inspec/resources/azure"
+++

Use the `azure_event_hub_namespace` InSpec audit resource to test the properties and configurations of an Azure Event Hub namespace within a resource group.

## Azure REST API Version, Endpoint, and HTTP Client Parameters

{{% inspec_azure_common_parameters %}}

## Installation

{{% inspec_azure_install %}}

## Syntax

`resource_group` and `name`, or the `resource_id` are required parameters.

```ruby
describe azure_event_hub_namespace(resource_group: 'RESOURCE_GROUP', name: 'EVENT_NAME') do
  it { should exist }
end
```

```ruby
describe azure_event_hub_namespace(resource_id: '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}') do
  it { should exist }
end
```

## Parameters

`resource_group`
: Azure resource group where the targeted resource resides.

`name`
: The unique name of the Event Hub namespace.

`namespace_name`
: Alias for the `name` parameter.

`resource_id`
: The unique resource ID. `/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}`.

Either one of the parameter sets can be provided for a valid query:

- `resource_id`
- `resource_group` and `name`
- `resource_group` and `namespace_name`.

## Properties

`properties.kafkaEnabled`
: Value that indicates whether Kafka is enabled for Event Hub namespace.

For parameters applicable to all resources, such as `type`, `name`, `id`, and `properties`, refer to [`azure_generic_resource`]({{< relref "azure_generic_resource.md#properties" >}}).

Also, refer to [Azure documentation](https://docs.microsoft.com/en-us/rest/api/eventhub/preview/namespaces/get) for other properties available. You can access any attribute in the response with the key names separated by dots (`.`).

## Examples

### Ensure to test if Kafka is enabled for an Event Hub namespace

```ruby
describe azure_event_hub_namespace(resource_group: 'RESOURCE_GROUP', namespace_name: 'EVENT_NAME') do
  its('properties.kafkaEnabled') { should be true }
end
```

```ruby
describe azure_event_hub_namespace(resource_id: '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}') do
  its('properties.kafkaEnabled') { should be true }
end
```

## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](https://docs.chef.io/inspec/matchers/).

### Exists

```ruby
# If we expect the resource always to exist

describe azure_event_hub_namespace(resource_group: 'RESOURCE_GROUP', namespace_name: 'EVENT_NAME') do
  it { should exist }
end
```

### Not Exists

```ruby
# If we expect the resource not to exist

describe azure_event_hub_namespace(resource_group: 'RESOURCE_GROUP', namespace_name: 'EVENT_NAME') do
  it { should_not exist }
end
```

## Azure Permissions

{{% azure_permissions_service_principal role="contributor" %}}
