---
title: About the azure_virtual_network_gateway_connection Resource
platform: azure
---

# azure_virtual_network_gateway_connection

Use the `azure_virtual_network_gateway_connection` InSpec audit resource to test properties related to an Azure Virtual Network Gateway Connection.

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

`name` and `resource_group`  is a required parameter.

```ruby
describe azure_virtual_network_gateway_connection(resource_group: 'RESOURCE_GROUP', name: 'VIRTUAL_NETWORK_GATEWAY_CONNECTION_NAME') do
  it  { should exist }
end
```
## Parameters

| Name           | Description                                                                      |
|----------------|----------------------------------------------------------------------------------|
| name           | Name of the Azure Virtual Network Gateway Connection to test.                                   |
| resource_group | Azure resource group that the targeted resource resides in. `MyResourceGroup`    |

The parameter set should be provided for a valid query:
- `resource_group` and `name`

## Properties

| Property                      | Description                                                      |
|-------------------------------|------------------------------------------------------------------|
| id                            | Resource ID.                                                     |
| name                          | Resource name.                                                   |
| type                          | Resource type.                                                   |
| eTag                          | A unique read-only string that changes whenever the resource is updated.|
| location                      | Resource location.                                               |
| properties.provisioningState  | The provisioning state of the virtual network gateway resource.  |
| properties.connectionType     | Gateway connection type.                                         |
| properties.useLocalAzureIpAddresses| Use private local Azure IP for the connection.              |
| properties.ipsecPolicies      | The IPSec Policies to be considered by this connection.          |


For properties applicable to all resources, such as `type`, `name`, `id`, `properties`, refer to [`azure_generic_resource`](azure_generic_resource.md#properties).

Also, refer to [Azure documentation](https://docs.microsoft.com/en-us/rest/api/network-gateway/virtual-network-gateway-connections/get) for other properties available.
Any attribute in the response may be accessed with the key names separated by dots (`.`).

## Examples

### Test that the Virtual Network Gateway connection protocol is IKEv1.

```ruby
describe azure_virtual_network_gateway_connection(resource_group: 'RESOURCE_GROUP', name: 'VIRTUAL_NETWORK_GATEWAY_CONNECTION_NAME') do
  its('connectionProtocol') { should eq 'IKEv1' }
end
```

## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](/inspec/matchers/).

### exists

```ruby
# If a Virtual Network Gateway Connection is found it will exist
describe azure_virtual_network_gateway_connection(resource_group: 'RESOURCE_GROUP', name: 'VIRTUAL_NETWORK_GATEWAY_CONNECTION_NAME') do
  it { should exist }
end

# if Virtual Network Gateway Connection is not found it will not exist
describe azure_virtual_network_gateway_connection(resource_group: 'RESOURCE_GROUP', name: 'VIRTUAL_NETWORK_GATEWAY_CONNECTION_NAME') do
  it { should_not exist }
end
```

## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be setup with a minimum of `reader` role on the subscription you wish to test.