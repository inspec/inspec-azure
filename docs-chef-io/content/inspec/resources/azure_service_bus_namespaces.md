+++
title = "azure_service_bus_namespaces Resource"
platform = "azure"
draft = false
gh_repo = "inspec-azure"

[menu.inspec]
title = "azure_service_bus_namespaces"
identifier = "inspec/resources/azure/azure_service_bus_namespaces Resource"
parent = "inspec/resources/azure"
+++

Use the `azure_service_bus_namespaces` InSpec audit resource to test properties related to all Azure Service Bus namespaces within a project.

## Azure REST API Version, Endpoint, and HTTP Client Parameters

{{% inspec_azure_common_parameters %}}

## Installation

{{% inspec_azure_install %}}

## Syntax

An `azure_service_bus_namespaces` resource block returns all Azure Service Bus namespaces within a project.

```ruby
describe azure_service_bus_namespaces do
  #...
end
```

## Parameters

`resource_group` _(optional)_
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
: A list of Properties for all the Service Bus namespaces.

: **Field**: `properties`

`locations`
: A list of the Geo-locations.

: **Field**: `location`

`serviceBusEndpoints`
: A list of endpoints you can use to perform Service Bus operations.

: **Field**: `serviceBusEndpoint`

`metricIds`
: A list of identifiers for Azure Insights metrics.

: **Field**: `metricId`

`provisioningStates`
: A list of provisioning states of the namespace..

: **Field**: `provisioningState`

`sku_names`
: A list of names for the sku.

: **Field**: `sku_name`

`sku_tiers`
: A list of tiers for the sku.

: **Field**: `sku_tier`

{{% inspec_filter_table %}}

## Examples

**Loop through Service Bus namespaces by their names.**

```ruby
azure_service_bus_namespaces(resource_group: 'RESOURCE_GROUP').names.each do |name|
  describe azure_service_bus_namespace(resource_group: 'RESOURCE_GROUP', name: name) do
    it { should exist }
  end
end
```

**Test that there are Service Bus namespaces that are successfully provisioned.**

```ruby
describe azure_service_bus_namespaces(resource_group: 'RESOURCE_GROUP').where(provisioningState: 'Succeeded') do
  it { should exist }
end
```

## Matchers

{{% inspec_matchers_link %}}

### exists

```ruby
# Should not exist if no Service Bus namespaces are present

describe azure_service_bus_namespaces(resource_group: 'RESOURCE_GROUP') do
  it { should_not exist }
end
# Should exist if the filter returns at least one Service Bus namespaces

describe azure_service_bus_namespaces(resource_group: 'RESOURCE_GROUP') do
  it { should exist }
end
```

## Azure Permissions

{{% azure_permissions_service_principal role="reader" %}}
