---
title: About the azure_subnet Resource
platform: azure
---

# azure_subnet

Use the `azure_subnet` InSpec audit resource to test properties related to a subnet for a given virtual network.

## Azure REST API version, endpoint and http client parameters

This resource interacts with api versions supported by the resource provider.
The `api_version` can be defined as a resource parameter.
If not provided, the latest version will be used.
For more information, refer to [`azure_generic_resource`](azure_generic_resource.md).

Unless defined, `azure_cloud` global endpoint, and default values for the http client will be used .
For more information, refer to the resource pack [README](../../README.md). 

## Availability

### Installation

This resource is available in the `inspec-azure` [resource pack](/inspec/glossary/#resource-pack). 
For an example `inspec.yml` file and how to set up your Azure credentials, refer to resource pack [README](../../README.md#Service-Principal).

## Syntax
```ruby
describe azure_subnet(resource_group: 'MyResourceGroup', vnet: 'MyVnetName', name: 'MySubnetName') do
  #...
end
```
## Parameters

| Name                           | Description                                                                      |
|--------------------------------|----------------------------------------------------------------------------------|
| resource_group                 | Azure resource group that the targeted resource resides in. `MyResourceGroup`    |
| vnet                           | Name of the Azure virtual network that the subnet is created in. `MyVNetName`    |
| name                           | Name of the Azure subnet to test. `MySubnetName`                                 |
| resource_id                    | The unique resource ID. `/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.Network/virtualNetworks/{vnName}/subnets/{subnetName}` |

Either one of the parameter sets can be provided for a valid query:
- `resource_id`
- `resource_group`, `vnet` and `name`

## Parameters

| Property | Description |
|----------|-------------|
| address_prefix | The address prefix for the subnet. `its('address_prefix') { should eq "x.x.x.x/x" }` |
| nsg            | The network security group attached to the subnet. `its('nsg') { should eq 'MyNetworkSecurityGroupName' }` |

For parameters applicable to all resources, such as `type`, `name`, `id`, `location`, `properties`, refer to [`azure_generic_resource`](azure_generic_resource.md#parameters).

Also, refer to [Azure documentation](https://docs.microsoft.com/en-us/rest/api/virtualnetwork/subnets/get#subnet) for other properties available. 
Any property in the response may be accessed with the key names separated by dots (`.`).

## Examples

### Ensure that the Subnets Address Prefix is Configured As Expected
```ruby
describe azure_subnet(resource_group: 'MyResourceGroup', vnet: 'MyVnetName', name: 'MySubnetName') do
    its('address_prefix') { should eq '192.168.0.0/24' }
end
```
### Ensure that the Subnet is Attached to the Right Network Security Group
```ruby
describe azure_subnet(resource_group: 'MyResourceGroup', vnet: 'MyVnetName', name: 'MySubnetName') do
    its('nsg') { should eq 'NetworkSecurityGroupName'}
end
```
## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](https://www.inspec.io/docs/reference/matchers/).

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

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be setup with a `contributor` role on the subscription you wish to test.

