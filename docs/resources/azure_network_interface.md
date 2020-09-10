---
title: About the azure_network_interface Resource
platform: azure
---

# azure_network_interface

Use the `azure_network_interface` InSpec audit resource to test properties and configuration of Azure Network Interface.

## Azure REST API version, endpoint and http client parameters

This resource interacts with api versions supported by the resource provider.
The `api_version` can be defined as a resource parameter.
If not provided, the latest version will be used.
For more information, refer to [`azure_generic_resource`](azure_generic_resource.md).

Unless defined, `azure_cloud` global endpoint, and default values for the http client will be used .
For more information, refer to the resource pack [README](../../README.md). 

## Availability

### Installation

This resource is available in the [InSpec Azure resource pack](https://github.com/inspec/inspec-azure). 
For an example `inspec.yml` file and how to set up your Azure credentials, refer to resource pack [README](../../README.md#Service-Principal).

## Syntax

An `azure_network_interface` resource block identifies an AKS Cluster by `name` and `resource_group` or the `resource_id`.
```ruby
describe azure_network_interface(resource_group: 'example', name: 'networkInterfaceName') do
  it { should exist }
end
```
```ruby
describe azure_network_interface(resource_id: '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkInterfaces/{networkInterfaceName}') do
  it { should exist }
end
```
## Parameters

| Name                           | Description                                                                       |
|--------------------------------|-----------------------------------------------------------------------------------|
| resource_group                 | Azure resource group that the targeted resource resides in. `MyResourceGroup`     |
| name                           | Name of the AKS cluster to test. `networkInterfaceName`                                      |
| resource_id                    | The unique resource ID. `/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkInterfaces/{networkInterfaceName}` |

Either one of the parameter sets can be provided for a valid query:
- `resource_id`
- `resource_group` and `name`

## Properties

| Property                | Description |
|-------------------------|-------------|
| primary?                | Indicates whether this is a primary network interface on a virtual machine. |
| ip_configurations       | A list of [IPConfigurations](https://docs.microsoft.com/en-us/rest/api/virtualnetwork/networkinterfaceipconfigurations/get#networkinterfaceipconfiguration) of the network interface. |
| private_ip              | The private IP address of the interrogated network interface's primary IP configuration. |
| private_ip_address_list | A list of all the private IP addresses of the interrogated network interface. |
| has_private_address_ip? | Indicates whether the interrogated network interface has a private IP address. |
| public_ip               | The public IP address ID of the interrogated network interface's primary IP configuration. `/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/publicIPAddresses/{publicIpAddressName}` |
| public_ip_id_list       | A list of all the public IP address IDs of the interrogated network interface. |
| has_public_address_ip?  | Indicates whether the interrogated network interface has a public IP address. |
For properties applicable to all resources, such as `type`, `name`, `id`, `properties`, refer to [`azure_generic_resource`](azure_generic_resource.md#properties).

Also, refer to [Azure documentation](https://docs.microsoft.com/en-us/rest/api/virtualnetwork/networkinterfaces/get#networkinterface) for other properties available. 
Any attribute in the response may be accessed with the key names separated by dots (`.`).

## Examples

### Test if IP Forwarding is Enabled
```ruby
describe azure_network_interface(resource_group: 'my-rg', name: 'networkInterfaceName') do
  its('properties.enableIPForwarding') { should be_true }
end
```
### Test if the Primary IP Configuration is Set to Correct Private IP Address
```ruby
describe azure_network_interface(resource_group: 'my-rg', name: 'networkInterfaceName') do
  its('private_ip') { should cmp '172.16.2.6' }
end
```
## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](https://docs.chef.io/inspec/matchers/).

### be_primary

Tests if a network interface is the primary network interface on a Virtual Machine.
```ruby
describe azure_network_interface(resource_group: 'my-rg', name: 'networkInterfaceName') do
  it {should be_primary}
end
```
### have_public_address_ip

Test if a network interface has a public IP address.
```ruby
describe azure_network_interface(resource_group: 'my-rg', name: 'networkInterfaceName') do
  it { should have_public_address_ip}
end
```
### have_private_address_ip

Test if a network interface has a private IP address.
```ruby
describe azure_network_interface(resource_group: 'my-rg', name: 'networkInterfaceName') do
  it { should have_private_address_ip}
end
```
### exists
```ruby
# If we expect 'networkInterfaceName' to always exist
describe azure_network_interface(resource_group: 'my-rg', name: 'networkInterfaceName') do
  it { should exist }
end

# If we expect 'networkInterfaceName' to never exist
describe azure_network_interface(resource_group: 'my-rg', name: 'networkInterfaceName') do
  it { should_not exist }
end
```
## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be setup with a `contributor` role on the subscription you wish to test.
