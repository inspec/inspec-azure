---
title: About the azure_virtual_network_peerings Resource
platform: azure
---

# azure_virtual_network_peerings

Use the `azure_virtual_network_peerings` InSpec audit resource to test properties related to virtual network peerings of a virtual network.

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

The `resource_group` and `vnet` must be given as a parameter.
```ruby
describe azure_virtual_network_peerings(resource_group: 'MyResourceGroup', vnet: 'virtual-network-name') do
  #...
end
```
## Parameters

|Name               | Description        |
|-------------------|--------------------|
| resource_group    | Azure resource group that the targeted resource resides in. `MyResourceGroup`    |
| vnet              | The virtual network that the network peering that you wish to test is a part of. |

## Properties

|Property       | Description                                                                          | Filter Criteria<superscript>*</superscript> |
|---------------|--------------------------------------------------------------------------------------|-----------------|
| ids           | A list of the unique resource ids.                                                   | `id`            |
| names         | A list of all the resources being interrogated.                                      | `name`          |
| etags         | A list of etags defined on the resources.                                            | `etag`          |

<superscript>*</superscript> For information on how to use filter criteria on plural resources refer to [FilterTable usage](https://github.com/inspec/inspec/blob/master/dev-docs/filtertable-usage.md).

## Examples

### Exists if Any Virtual Network Peerings Exist for a Given Virtual Network in the Resource Group
```ruby
describe azure_virtual_network_peerings(resource_group: 'MyResourceGroup', vnet: 'virtual-network-name') do
  it { should exist }
end
```
### Filters the Results to Only Those that Match the Given Name
```ruby
describe azure_virtual_network_peerings(resource_group: 'MyResourceGroup', vnet: 'virtual-network-name') do
  .where(name: 'MyVirtualNetworkPeering') do
  it { should exist }
end
```
## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](https://www.inspec.io/docs/reference/matchers/).

### exists
```ruby
# Should not exist if no virtual network peerings are in the virtual network
describe azure_virtual_network_peerings(resource_group: 'MyResourceGroup', vnet: 'virtual-network-name') do
  it { should_not exist }
end
```
## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be setup with a `contributor` role on the subscription you wish to test.
