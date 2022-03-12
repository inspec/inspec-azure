+++
title = "azure_service_bus_topics Resource"
platform = "azure"
draft = false
gh_repo = "inspec-azure"

[menu.inspec]
title = "azure_service_bus_topics"
identifier = "inspec/resources/azure/azure_service_bus_topics Resource"
parent = "inspec/resources/azure"
+++

Use the `azure_service_bus_topics` InSpec audit resource to test properties related to all Azure Service Bus topics within a project.

## Azure REST API Version, Endpoint, and HTTP Client Parameters

{{% inspec_azure_common_parameters %}}

## Installation

{{% inspec_azure_install %}}

## Syntax

An `azure_service_bus_topics` resource block returns all Azure Service Bus topics within a project.

`name`, `namespace_name`, and `resource_group` are the required parameters.

```ruby
describe azure_service_bus_topics(resource_group: 'RESOURCE_GROUP', namespace_name: 'SERVICE_BUS_NAMESPACE_NAME') do
  #...
end
```

## Parameters

`resource_group` _(required)_
: Azure resource group that the targeted resource resides in. `MyResourceGroup`.

`namespace_name` _(required)_
: Name of the namespace where the topic resides in.

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
: A list of properties for all the Service Bus topics.

: **Field**: `properties`

`maxSizeInMegabytes`
: A list of maximum sizes of the topics.

: **Field**: `maxSizeInMegabytes`

`sizeInBytes`
: A list of sizes of the topics.

: **Field**: `sizeInBytes`

`statuses`
: A list of the status of a messaging entity.

: **Field**: `status`

`countDetails`
: A list of message count details.

: **Field**: `countDetails`

{{% inspec_filter_table %}}

## Examples

**Loop through Service Bus topics by their names.**

```ruby
azure_service_bus_topics(resource_group: 'RESOURCE_GROUP', namespace_name: 'SERVICE_BUS_NAMESPACE_NAME').names.each do |name|
  describe azure_service_bus_topic(resource_group: 'RESOURCE_GROUP', namespace_name: 'SERVICE_BUS_NAMESPACE_NAME', name: name) do
    it { should exist }
  end
end
```

**Test that there are Service Bus topics that are successfully provisioned.**

```ruby
describe azure_service_bus_topics(resource_group: 'RESOURCE_GROUP', namespace_name: 'SERVICE_BUS_NAMESPACE_NAME').where(status: 'Active') do
  it { should exist }
end
```

## Matchers

{{% inspec_matchers_link %}}

### exists

```ruby
# Should not exist if no Service Bus topics are present

describe azure_service_bus_topics(resource_group: 'RESOURCE_GROUP', namespace_name: 'SERVICE_BUS_NAMESPACE_NAME') do
  it { should_not exist }
end
# Should exist if the filter returns at least one Service Bus topics

describe azure_service_bus_topics(resource_group: 'RESOURCE_GROUP', namespace_name: 'SERVICE_BUS_NAMESPACE_NAME') do
  it { should exist }
end
```

## Azure Permissions

{{% azure_permissions_service_principal role="reader" %}}
