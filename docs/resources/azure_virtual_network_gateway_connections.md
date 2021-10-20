---
title: About the azure_virtual_network_gateway_connections Resource
platform: azure
---

# azure_virtual_network_gateway_connections

Use the `azure_virtual_network_gateway_connections` InSpec audit resource to test properties related to all Azure Virtual Network Gateway Connections within a project.

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

An `azure_virtual_network_gateway_connections` resource block returns all Azure Virtual Network Gateway Connections within a project.

```ruby
describe azure_virtual_network_gateway_connections(resource_group: 'RESOURCE_GROUP') do
  #...
end
```

## Parameters
| Name           | Description                                                                      |
|----------------|----------------------------------------------------------------------------------|
| resource_group | Azure resource group that the targeted resource resides in. `MyResourceGroup`    |

The parameter set should be provided for a valid query:
- `resource_group`

## Properties

|Property                        | Description                                                            | Filter Criteria<superscript>*</superscript> |
|--------------------------------|------------------------------------------------------------------------|------------------|
| ids                            | A list of resource ID.                                                 | `id`             |
| names                          | A list of resource names.                                              | `name`           |
| types                          | A list of types.                                                       | `type`           |
| eTags                          | A list of eTags.                                                       | `eTag`           |
| locations                      | A list of all locations.                                               | `location`       |
| properties                     | A list of Properties for all the virtual network gateway connections.  | `properties`     |
| provisioningStates             | A list of provisioning states.                                         | `provisioningState`|
| connectionTypes                | A list of gateway connection type.                                     | `connectionType`|
| connectionProtocols            | A list of connection protocols used for this connection.               | `connectionProtocol`|
| useLocalAzureIpAddresses       | A list of private local Azure IPs for the connection.                  | `datacenterManagementServerName`|
| ipsecPolicies                  | A list of all The IPSec Policies to be considered by this connection.  | `ipsecPolicies`  |                               | `description`    |

<superscript>*</superscript> For information on how to use filter criteria on plural resources refer to [FilterTable usage](https://github.com/inspec/inspec/blob/master/dev-docs/filtertable-usage.md).
Also, refer to [Azure documentation](https://docs.microsoft.com/en-us/rest/api/network-gateway/virtual-network-gateway-connections/list) for other properties available.

## Examples

### Loop through Virtual Network Gateway Connection by their names.

```ruby
azure_virtual_network_gateway_connections(resource_group: 'RESOURCE_GROUP').names.each do |name|
  describe azure_virtual_network_gateway_connection(resource_group: 'RESOURCE_GROUP', name: name) do
    it { should exist }
  end
end
```
### Test that there are Virtual Network Gateway Connection with connection type IPsec.

```ruby
describe azure_virtual_network_gateway_connections(resource_group: 'RESOURCE_GROUP').where(connectionType: 'VPN_CONNECTION_TYPE') do
  it { should exist }
end
```

## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](https://www.inspec.io/docs/reference/matchers/).

### exists

```ruby
# Should not exist if no Virtual Network Gateway Connection are present in the project and in the resource group
describe azure_virtual_network_gateway_connections(resource_group: 'RESOURCE_GROUP') do
  it { should_not exist }
end

# Should exist if the filter returns at least one Virtual Network Gateway Connection in the project and in the resource group
describe azure_virtual_network_gateway_connections(resource_group: 'RESOURCE_GROUP') do
  it { should exist }
end
```
## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be setup with a minimum of `reader` role on the subscription you wish to test.