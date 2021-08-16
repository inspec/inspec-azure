---
title: About the azure_virtual_network_peering Resource
platform: azure
---

# azure_virtual_network_peering

Use the `azure_virtual_network_peering` InSpec audit resource to test properties related to a peering for a virtual network.

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

This resource requires either the `resource_id` parameter or the `resource_group`, `vnet` and `name` parameters.
```ruby
describe azure_virtual_network_peering(resource_group: 'MyResourceGroup',vnet: 'virtual-network-name' name: 'virtual-network-peering-name') do
  it { should exist }
end
```
```ruby
describe azure_virtual_network_peering(resource_id: '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.Network/virtualNetworks/{vnName}/virtualNetworkPeerings/{virtualNetworkPeeringName}') do
  it { should exist }
end
```
## Parameters

| Name                           | Description                                                                                                      |
|--------------------------------|------------------------------------------------------------------------------------------------------------------|
| resource_group                 | Azure resource group that the targeted resource resides in. `MyResourceGroup`                                    |
| vnet                           | Name of the Azure virtual network that the virtual network peering is created in. `MyVNetName`                   |
| name                           | Name of the Azure virtual network peering to test. `MyVirtualNetworkPeeringName`                                 |
| resource_id                    | The unique resource ID. `/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.Network/virtualNetworks/{vnName}/virtualNetworkPeerings/{virtualNetworkPeeringName}` |

Either one of the parameter sets can be provided for a valid query:
- `resource_id`
- `resource_group`, `vnet` and `name`

## Properties

| Property | Description |
|----------|-------------|
| peering_state | The peering state for the virtual network peering. `its('peering_state') { should eq "Connected" }` |

For properties applicable to all resources, such as `type`, `name`, `id`, `properties`, refer to [`azure_generic_resource`](azure_generic_resource.md#properties).

Also, refer to [Azure documentation](https://docs.microsoft.com/en-us/rest/api/virtualnetwork/virtual-network-peerings/get#virtualnetworkpeering) for other properties available. 
Any property in the response may be accessed with the key names separated by dots (`.`).

## Examples

### Ensure that the Virtual Network Peering State is Connected 
```ruby
describe azure_virtual_network_peering(resource_group: 'MyResourceGroup',vnet: 'virtual-network-name' name: 'virtual-network-peering-name') do
    its('peering_state') { should eq 'Connected' }
end
```
## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](https://www.inspec.io/docs/reference/matchers/).

### exists
```ruby
# If a Virtual Network Peering is found it will exist
describe azure_virtual_network_peering(resource_group: 'MyResourceGroup',vnet: 'virtual-network-name' name: 'virtual-network-peering-name') do do
  it { should exist }
end

# Virtual Network Peerings that aren't found will not exist
describe azure_virtual_network_peering(resource_group: 'MyResourceGroup', vnet: 'MyVnetName', name: 'DoesNotExist') do
  it { should_not exist }
end
```
## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be setup with a `contributor` role on the subscription you wish to test.

