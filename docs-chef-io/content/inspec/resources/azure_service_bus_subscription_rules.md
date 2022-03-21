+++
title = "azure_service_bus_subscription_rules Resource"
platform = "azure"
draft = false
gh_repo = "inspec-azure"

[menu.inspec]
title = "azure_service_bus_subscription_rules"
identifier = "inspec/resources/azure/azure_service_bus_subscription_rules Resource"
parent = "inspec/resources/azure"
+++

Use the `azure_service_bus_subscription_rules` InSpec audit resource to test properties related to all Azure Service Bus subscription rules.

## Azure REST API Version, Endpoint, and HTTP Client Parameters

{{% inspec_azure_common_parameters %}}

## Installation

{{% inspec_azure_install %}}

## Syntax

An `azure_service_bus_subscription_rules` resource block returns all Azure Service Bus subscription rules.

```ruby
describe azure_service_bus_subscription_rules(resource_group: 'RESOURCE_GROUP', namespace_name: 'NAMESPACE_NAME', subscription_name: 'SUBSCRIPTION_NAME', topic_name: 'TOPIC_NAME') do
  #...
end
```

## Parameters

`namespace_name` _(required)_
: The namespace name.

`subscription_name` _(required)_
: The subscription name.

`topic_name` _(required)_
: The topic name.

`resource_group` _(required)_
: Azure resource group that the targeted resource resides in.

## Properties

`ids`
: A list of resource IDs.

: **Field**: `id`

`names`
: A list of resource Names.

: **Field**: `name`

`types`
: A list of the resource types.

: **Field**: `type`

`properties`
: A list of Properties for all the Service Bus subscription rules.

: **Field**: `properties`

`filterTypes`
: A list of the Filter types.

: **Field**: `filterType`

`sqlFilter`
: A list of sqlFilters.

: **Field**: `sqlFilter`

{{% inspec_filter_table %}}

## Examples

**Test that there are Service Bus subscription rules that are of SQL Filter type.**

```ruby
describe azure_service_bus_subscription_rules(resource_group: 'RESOURCE_GROUP', namespace_name: 'NAMESPACE_NAME', subscription_name: 'SUBSCRIPTION_NAME', topic_name: 'TOPIC_NAME').where(filterType: 'SqlFilter') do
  it { should exist }
end
```

## Matchers

{{% inspec_matchers_link %}}

### exists

```ruby
# Should not exist if no Service Bus subscription rules are present

describe azure_service_bus_subscription_rules(resource_group: 'RESOURCE_GROUP', namespace_name: 'NAMESPACE_NAME', subscription_name: 'SUBSCRIPTION_NAME', topic_name: 'TOPIC_NAME') do
  it { should_not exist }
end
# Should exist if the filter returns at least one Service Bus subscription rules

describe azure_service_bus_subscription_rules(resource_group: 'RESOURCE_GROUP', namespace_name: 'NAMESPACE_NAME', subscription_name: 'SUBSCRIPTION_NAME', topic_name: 'TOPIC_NAME') do
  it { should exist }
end
```

## Azure Permissions

{{% azure_permissions_service_principal role="reader" %}}
