---
title: About the azure_virtual_network_peerings Resource
platform: azure
---

# azure_virtual_network_peerings

Use the `azure_virtual_network_peerings` InSpec audit resource to test properties related to virtual network peerings of a virtual network.

## Azure REST API Version, Endpoint and HTTP Client Parameters

This resource interacts with API versions supported by the resource provider. You can define the `api_version` as a resource parameter. If not provided, the latest version is used. For more information, refer to [`azure_generic_resource`](azure_generic_resource.md).

Unless defined, `azure_cloud` global endpoint and default values for the HTTP client is used. For more information, refer to the resource pack [README](../../README.md).

## Availability

### Installation

This resource is available in the [InSpec Azure resource pack](https://github.com/inspec/inspec-azure). For an example, `inspec.yml` file and how to set up your Azure credentials, refer to resource pack [README](../../README.md#Service-Principal).

## Syntax

The `resource_group` and `vnet` are required parameters.

```ruby
describe azure_virtual_network_peerings(resource_group: 'MyResourceGroup', vnet: 'virtual-network-name') do
  #...
end
```

## Parameters

|Name               | Description        |
|-------------------|--------------------|
| resource_group    | Azure resource group where the targeted resource resides in. `MyResourceGroup`    |
| vnet              | The virtual network that the network is peering that you wish to test is a part of. |

## Properties

|Property       | Description                                                                          | Filter Criteria<superscript>*</superscript> |
|---------------|--------------------------------------------------------------------------------------|-----------------|
| ids           | A list of the unique resource IDs.                                                   | `id`            |
| names         | A list of all the resources being interrogated.                                      | `name`          |
| etags         | A list of etags defined in the resources.                                            | `etag`          |

<superscript>*</superscript> For information on how to use filter criteria on plural resources refer to [FilterTable usage](https://github.com/inspec/inspec/blob/master/dev-docs/filtertable-usage.md).

## Examples

### Exists if Virtual Network Peerings Exist for a Given Virtual Network

```ruby
describe azure_virtual_network_peerings(resource_group: 'MYRESOURCEGROUP', vnet: 'VIRTUAL-NETWORK-NAME') do
  it { should exist }
end
```

### Filters the Results that Matches the Given Name

```ruby
describe azure_virtual_network_peerings(resource_group: 'MYRESOURCEGROUP', vnet: 'VIRTUAL-NETWORK-NAME') do
  .where(name: 'MYVIRTUALNETWORKPEERING') do
  it { should exist }
end
```

## Matchers

This InSpec audit resource has the following special matchers. For a complete list of available matchers, please visit our [Universal Matchers page](https://www.inspec.io/docs/reference/matchers/).

### exists

```ruby
# Should not exist if no virtual network peerings are in the virtual network
describe azure_virtual_network_peerings(resource_group: 'MYRESOURCEGROUP', vnet: 'VIRTUAL-NETWORK-NAME') do
  it { should_not exist }
end
```

## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be set up with a `contributor` role on the subscription you wish to test.
