+++
title = "azure_virtual_network_gateway_connection resource"

draft = false


[menu.azure]
title = "azure_virtual_network_gateway_connection"
identifier = "inspec/resources/azure/azure_virtual_network_gateway_connection resource"
parent = "inspec/resources/azure"
+++

Use the `azure_virtual_network_gateway_connection` InSpec audit resource to test the properties related to an Azure Virtual Network Gateway connection.

## Azure REST API version, endpoint, and HTTP client parameters

{{< readfile file="content/reusable/md/inspec_azure_common_parameters.md" >}}

## Syntax

`name` and `resource_group`  are required parameters.

```ruby
describe azure_virtual_network_gateway_connection(resource_group: 'RESOURCE_GROUP', name: 'VIRTUAL_NETWORK_NAME') do
  it  { should exist }
end
```

## Parameters

`name`
: Name of the Azure Virtual Network Gateway connection to test.

`resource_group`
: Azure resource group name where the targeted resource resides.

The parameter set should be provided for a valid query is `resource_group` and `name`.

## Properties

`id`
: Resource ID.

`name`
: Resource name.

`type`
: Resource type.

`eTag`
: A unique read-only string that changes whenever the resource is updated.

`location`
: Resource location.

`properties.provisioningState`
: The provisioning state of the virtual network gateway resource.

`properties.connectionType`
: Gateway connection type.

`properties.useLocalAzureIpAddresses`
: Use private local Azure IP for the connection.

`properties.ipsecPolicies`
: The IPSec Policies to be considered by this connection.

For properties applicable to all resources, such as `type`, `name`, `id`, and `properties`, refer to [`azure_generic_resource`](azure_generic_resource#properties).

Also, see the [Azure documentation](https://docs.microsoft.com/en-us/rest/api/network-gateway/virtual-network-gateway-connections/get) for other available properties. Any attribute in the response is accessed with the key names separated by dots (`.`).

## Examples

Test that the Virtual Network Gateway connection protocol is IKEv1:

```ruby
describe azure_virtual_network_gateway_connection(resource_group: 'RESOURCE_GROUP', name: 'VIRTUAL_NETWORK_NAME') do
  its('connectionProtocol') { should eq 'IKEv1' }
end
```

## Matchers

{{< readfile file="content/reusable/md/inspec_matchers_link.md" >}}

### exists

```ruby
# If a Virtual Network Gateway connection is found, it will exist.

describe azure_virtual_network_gateway_connection(resource_group: 'RESOURCE_GROUP', name: 'VIRTUAL_NETWORK_NAME') do
  it { should exist }
end
```

### not_exists

```ruby
# If Virtual Network Gateway connection is not found, it will not exist.

describe azure_virtual_network_gateway_connection(resource_group: 'RESOURCE_GROUP', name: 'VIRTUAL_NETWORK_NAME') do
  it { should_not exist }
end
```

## Azure permissions

{{% inspec-azure/azure_permissions_service_principal role="reader" %}}
