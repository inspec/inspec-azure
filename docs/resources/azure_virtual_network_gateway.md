---
title: About the azure_virtual_network_gateway Resource
platform: azure
---

# azure_virtual_network_gateway

Use the `azure_virtual_network_gateway` InSpec audit resource to test properties and configuration of an Azure Virtual Network Gateway.

## Azure REST API Version, Endpoint, and HTTP Client Parameters

This resource interacts with API versions supported by the resource provider.
The `api_version` can be defined as a resource parameter.
If not provided, the latest version will be used.
For more information, refer to [`azure_generic_resource`](azure_generic_resource.md).

Unless defined, `azure_cloud` global endpoint and default values for the HTTP client will be used.
For more information, refer to the resource pack [README](../../README.md).

## Availability

### Installation

This resource is available in the [InSpec Azure resource pack](https://github.com/inspec/inspec-azure).
For an example `inspec.yml` file and how to set up your Azure credentials, refer to resource pack [README](../../README.md#Service-Principal).

## Syntax

`resource_group` and `name` must be given as a parameter.
```ruby
describe azure_virtual_network_gateway(resource_group: 'RESOURCE_GROUP', name: 'VIRTUAL_NETWORK_GATEWAY_NAME') do
  it { should exist }
end
```

## Parameters

| Name                           | Description                                                                       |
|--------------------------------|-----------------------------------------------------------------------------------|
| resource_group                 | Azure resource group that the targeted resource resides in. `MyResourceGroup`     |
| name                           | The unique name of the targeted resource. `gatewayName`                           |

The below parameter sets should be provided for a valid query:
- `resource_group` and `name`

## Properties

| Property                    | Description                                                              |
|-----------------------------|--------------------------------------------------------------------------|
| name                        | Resource name.                                                           |
| id                          | Resource ID.                                                             |
| etag                        | A unique read-only string that changes whenever the resource is updated. |
| type                        | Resource type.                                                           |
| location                    | Resource location.                                                       |
| tags                        | Resource tags.                                                           |
| properties.bgpSettings      | Virtual network gateway's BGP speaker settings.                          |
| properties.provisioningState| The provisioning state of the virtual network gateway resource.          |
| properties.vpnClientConfiguration | The reference to the VpnClientConfiguration resource which represents the P2S VpnClient configurations. |

For properties applicable to all resources, such as `type`, `name`, `id`, `properties`, refer to [`azure_generic_resource`](azure_generic_resource.md#properties).

Also, refer to [Azure documentation](https://docs.microsoft.com/en-us/rest/api/network-gateway/virtual-network-gateways/get) for other properties available.
Any attribute in the response may be accessed with the key names separated by dots (`.`).

## Examples

### Test the VPN Client Protocol of an Virtual Network Gateway
```ruby
describe azure_virtual_network_gateway(resource_group: 'RESOURCE_GROUP', name: 'VIRTUAL_NETWORK_GATEWAY_NAME') do
  its('properties.vpnClientConfiguration.vpnClientProtocols') { should include 'OpenVPN' }
end
```

## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](https://docs.chef.io/inspec/matchers/).

### exists
```ruby
# If we expect a virtual network gateway to always exist
describe azure_virtual_network_gateway(resource_group: 'RESOURCE_GROUP', name: 'VIRTUAL_NETWORK_GATEWAY_NAME') do
  it { should exist }
end

# If we expect virtual network gateway to never exist
describe azure_virtual_network_gateway(resource_group: 'RESOURCE_GROUP', name: 'VIRTUAL_NETWORK_GATEWAY_NAME') do
  it { should_not exist }
end
```
## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be setup with a minimum of `reader` role on the subscription you wish to test.
