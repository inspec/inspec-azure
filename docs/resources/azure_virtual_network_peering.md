---
title: About the azure_virtual_network_peering Resource
platform: azure
---

# azure_virtual_network_peering

Use the `azure_virtual_network_peering` InSpec audit resource to test properties related to a given virtual network peering.

## Azure REST API Version, Endpoint, and HTTP Client Parameters

This resource interacts with API versions supported by the resource provider. You can define the `api_version` as a resource parameter. If not provided, the latest version is used. For more information, refer to [`azure_generic_resource`](azure_generic_resource.md).

Unless defined, `azure_cloud` global endpoint, and default values for the HTTP client is used. For more information, refer to the resource pack [README](../../README.md).

## Availability

### Installation

This resource is available in the [InSpec Azure resource pack](https://github.com/inspec/inspec-azure). For an example, `inspec.yml` file and how to set up your Azure credentials, refer to resource pack [README](../../README.md#Service-Principal).

## Syntax

`resource_group`, `vnet`, and `name` or the `resource_id` are required parameters.

```ruby
describe azure_virtual_network_peering(resource_group: 'RESOURCE_GROUP',vnet: 'VIRTUAL-NETWORK-NAME' name: 'VIRTUAL-NETWORK-PEERING-NAME') do
  it { should exist }
end
```

```ruby
describe azure_virtual_network_peering(resource_id: '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.Network/virtualNetworks/{vnName}/virtualNetworkPeerings/{virtualNetworkPeeringName}') do
  it { should exist }
end
```

## Parameters

| Name                           | Description                                                                    |
|--------------------------------|--------------------------------------------------------------------------------|
| resource_group                 | Azure resource group that the targeted resource resides in. `MyResourceGroup`  |
| vnet                           | Name of the Azure virtual network where the virtual network peering is created in. `MyVNetName` |
| name                           | Name of the Azure virtual network peering to test. `MyVirtualNetworkPeeringName`  |
| resource_id                    | The unique resource ID. `/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.Network/virtualNetworks/{vnName}/virtualNetworkPeerings/{virtualNetworkPeeringName}` |
| Either one of the parameter sets is provided for a valid query:

- `resource_id`
- `resource_group`, `vnet` and `name` |

## Properties

| Property | Description |
|----------|-------------|
| peering_state | The status of the virtual network peering. The possible values are `Connected`, `Disconnected`, and `Initiated`. `its('peering_state') { should eq "Connected" }` |

For properties applicable to all resources, such as `type`, `name`, `id`, `properties`, refer to [`azure_generic_resource`](azure_generic_resource.md#properties).

Also, refer to [Azure documentation](https://docs.microsoft.com/en-us/rest/api/virtualnetwork/virtual-network-peerings/get#virtualnetworkpeering) for other properties available. Any property in the response are accessed with the key names separated by dots (`.`).

## Examples

### Ensure that a Virtual Network Peering State is 'Connected'

```ruby
describe azure_virtual_network_peering(resource_group: 'MYRESOURCEGROUP',vnet: 'VIRTUAL-NETWORK-NAME' name: 'VIRTUAL-NETWORK-PEERING-NAME') do
    its('peering_state') { should eq 'Connected' }
end
```

## Matchers

This InSpec audit resource has the following special matchers. For a complete list of available matchers, please visit our [Universal Matchers page](https://www.inspec.io/docs/reference/matchers/).

### exists

```ruby
# If a Virtual Network Peering is found, it will exist
describe azure_virtual_network_peering(resource_group: 'MYRESOURCEGROUP',vnet: 'VIRTUAL-NETWORK-NAME' name: 'VIRTUAL-NETWORK-PEERING-NAME') do
  it { should exist }
end

# Virtual Network Peerings that aren't found, it will not exist
describe azure_virtual_network_peering(resource_group: 'MYRESOURCEGROUP', vnet: 'MYVNETNAME', name: 'DOESNOTEXIST') do
  it { should_not exist }
end
```

## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be set up with a `contributor` role on the subscription you wish to test.
