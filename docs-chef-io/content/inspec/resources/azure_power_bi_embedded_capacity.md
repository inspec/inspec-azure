+++
title = "azure_power_bi_embedded_capacity Resource"
platform = "azure"
draft = false
gh_repo = "inspec-azure"

[menu.inspec]
title = "azure_power_bi_embedded_capacity"
identifier = "inspec/resources/azure/azure_power_bi_embedded_capacity Resource"
parent = "inspec/resources/azure"
+++

### azure_power_bi_embedded_capacity

Use the `azure_power_bi_embedded_capacity` InSpec audit resource to test the properties related to Azure Power BI Embedded Capacity.

## Azure REST API Version, Endpoint, and HTTP Client Parameters

{{% inspec_azure_common_parameters %}}

## Installation

{{% inspec_azure_install %}}

## Syntax

`name` and `resource_group` are required parameters.

```ruby
describe azure_power_bi_embedded_capacity(resource_group: 'RESOURCE_GROUP', name: 'POWER_BI_EMBEDDED') do
  it  { should exist }
end
```

```ruby
describe azure_power_bi_embedded_capacity(resource_group: 'RESOURCE_GROUP', name: 'POWER_BI_EMBEDDED')  do
  it  { should exist }
end
```

## Parameters

`name`
: Name of the Power BI Embedded Capacity to test.

`resource_group`
: Azure Resource Group.

The parameter set for a valid query that should be provided are `name` and `account_name`.

## Properties

`id`
: An identifier that represents the PowerBI Dedicated resource.

`location`
: Location of the PowerBI Dedicated resource.

`name`
: The name of the PowerBI Dedicated resource.

`properties.administration`
: A collection of Dedicated capacity administrators.

`properties.mode`
: The capacity mode.

`properties.state`
: The current state of PowerBI Dedicated resource. The state is to indicate more states outside of resource provisioning.

`sku`
: The SKU of the PowerBI Dedicated resource.

`tags`
: Key-value pairs of additional resource provisioning properties.

`type`
: The type of the PowerBI Dedicated resource.

For properties applicable to all resources, such as `type`, `name`, `id`, and `properties`, refer to [`azure_generic_resource`]({{< relref "azure_generic_resource.md#properties" >}}).

Also, refer to [Azure documentation](https://docs.microsoft.com/en-us/rest/api/power-bi-embedded/capacities/get-details) for other properties available.

## Examples

**Test that the Power BI Embedded Capacity.**

```ruby
describe azure_power_bi_embedded_capacity(resource_group: 'RESOURCE_GROUP', name: 'POWER_BI_EMBEDDED')  do
  its('count') { should eq 1.0 }
end
```

## Matchers

{{% inspec_matchers_link %}}

### exists

```ruby
# If the Power BI Embedded Capacity is found, it will exist
describe azure_power_bi_embedded_capacity(resource_group: 'RESOURCE_GROUP', name: 'POWER_BI_EMBEDDED')  do
  it { should exist }
end
# if the Power BI Embedded Capacity is not found, it will not exist
describe azure_power_bi_embedded_capacity(resource_group: 'RESOURCE_GROUP', name: 'POWER_BI_EMBEDDED')  do
  it { should_not exist }
end
```

## Azure Permissions

{{% azure_permissions_service_principal role="contributor" %}}
