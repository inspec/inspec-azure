+++
title = "azure_subnet Resource"
platform = "azure"
draft = false
gh_repo = "inspec-azure"

[menu.inspec]
title = "azure_subnet"
identifier = "inspec/resources/azure/azure_subnet Resource"
parent = "inspec/resources/azure"
+++

Use the `azure_subnet` InSpec audit resource to test properties related to a subnet for a given virtual network.

## Azure REST API Version, Endpoint, and HTTP Client Parameters

{{% inspec_azure_common_parameters %}}

## Installation

{{% inspec_azure_install %}}

## Syntax

`resource_group`, `vnet` and `name` or the `resource_id` must be given as a parameter.

```ruby
describe azure_subnet(resource_group: 'MyResourceGroup', vnet: 'MyVnetName', name: 'MySubnetName') do
  it { should exist }
end
```

```ruby
describe azure_subnet(resource_id: '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.Network/virtualNetworks/{vnName}/subnets/{subnetName}') do
  it { should exist }
end
```

## Parameters

`resource_group`
: Azure resource group that the targeted resource resides in.

`vnet`
: Name of the Azure virtual network that the subnet is created in.

`name`
: Name of the Azure subnet to test.

`resource_id`
: The unique resource ID. `/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.Network/virtualNetworks/{vnName}/subnets/{subnetName}`.

Provide one of the following parameter sets for a valid query:

- `resource_id`
- `resource_group`, `vnet`, and `name`

## Properties

`address_prefix`

: The address prefix for the subnet.

`nsg`

: The network security group attached to the subnet.

For properties applicable to all resources, such as `type`, `name`, `id`, `properties`, refer to [`azure_generic_resource`]({{< relref "azure_generic_resource.md#properties" >}}).

Also, refer to [Azure documentation](https://docs.microsoft.com/en-us/rest/api/virtualnetwork/subnets/get#subnet) for other properties available.
Any property in the response may be accessed with the key names separated by dots (`.`).

## Examples

**Ensure that the Subnets Address Prefix is Configured As Expected.**

```ruby
describe azure_subnet(resource_group: 'MyResourceGroup', vnet: 'MyVnetName', name: 'MySubnetName') do
    its('address_prefix') { should eq '192.168.0.0/24' }
end
```

**Ensure that the Subnet is Attached to the Right Network Security Group.**

```ruby
describe azure_subnet(resource_group: 'MyResourceGroup', vnet: 'MyVnetName', name: 'MySubnetName') do
    its('nsg') { should eq 'NetworkSecurityGroupName'}
end
```

## Matchers

{{% inspec_matchers_link %}}

### exists

```ruby
# If a subnet is found it will exist

describe azure_subnet(resource_group: 'MyResourceGroup', vnet: 'MyVnetName', name: 'MySubnetName') do
  it { should exist }
end

# subnets that aren't found will not exist
describe azure_subnet(resource_group: 'MyResourceGroup', vnet: 'MyVnetName', name: 'DoesNotExist') do
  it { should_not exist }
end
```

## Azure Permissions

{{% azure_permissions_service_principal role="contributor" %}}
