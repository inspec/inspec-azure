---
title: About the azure_network_security_group Resource
platform: azure
---

# azure_network_security_group

Use the `azure_network_security_group` InSpec audit resource to test properties of an Azure Network Security Group.

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

An `azure_network_security_group` resource block identifies a Network Security Group by `name` and `resource_group` or the `resource_id`.
```ruby
describe azure_network_security_group(resource_group: 'example', name: 'GroupName') do
  it { should exist }
end
```
```ruby
describe azure_network_security_group(resource_id: '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.Network/networkSecurityGroups/{nsgName}') do
  it { should exist }
end
```
## Parameters

| Name                           | Description                                                                      |
|--------------------------------|----------------------------------------------------------------------------------|
| resource_group                 | Azure resource group that the targeted resource resides in.`MyResourceGroup`     |
| name                           | Name of the Azure resource to test. `MyNSG`                                      |
| resource_id                    | The unique resource ID. `/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.Network/networkSecurityGroups/{nsgName}` |

Either one of the parameter sets can be provided for a valid query:
- `resource_id`
- `resource_group` and `name`

## Properties

| Property                   | Description                   |
|----------------------------|-------------------------------|
| security_rules             | The set of security rules.    |
| default_security_rules     | The set of default security rules.|
| allow_ssh_from_internet<superscript>*</superscript>    | A boolean value determined by analysing the security rules and default security rules for unrestricted SSH access. `it { should_not allow_ssh_from_internet }` |
| allow_rdp_from_internet<superscript>*</superscript>    | A boolean value determined by analysing the security rules and default security rules for unrestricted RDP access. `it { should_not allow_rdp_from_internet }` |
| allow_port_from_internet<superscript>*</superscript>   | A boolean value determined by analysing the security rules and default security rules for unrestricted access to a specified port. `it { should_not allow_port_from_internet('443') }` |
| allow?<superscript>**</superscript>                     | Indicates if a provided criteria is complaint with the security rules including the default ones. `it { should allow(source_ip_range: '10.0.0.0/24'), direction: 'inbound' }` |
| allowed?<superscript>**</superscript>                     | Alias for `allow?`. `it { should be_allowed(source_ip_range: '10.0.0.0/24'), direction: 'inbound' }` |
| allow_in?<superscript>**</superscript>                  | Indicates if a provided criteria is complaint with the **inbound** security rules including the default ones. `it { should_not allow_in(service_tag: 'Internet') }` |
| allowed_in?<superscript>**</superscript>                  | Alias for `allow_in?`. `it { should_not be_allowed_in(service_tag: 'Internet') }` |
| allow_out?<superscript>**</superscript>                 | Indicates if a provided criteria is complaint with the **outbound** security rules including the default ones. `it { should_not allow_out(service_tag: 'Internet') }` |
| allowed_out?<superscript>**</superscript>                 | Alias for `allow_out?`. `it { should_not be_allowed_out(service_tag: 'Internet') }` |

<superscript>*</superscript> These properties do not take the priorities of security rules into account.
For example, if there are two security rules and one of them is allowing SSH from internet while the other one is prohibiting, `allow_ssh_from_internet` will pass without comparing the priority of the conflicting security rules.
Therefore, it is recommended to use `allow`, `allow_in` or `allow_out` properties with which the priorities are taken into consideration.

<superscript>**</superscript> These properties do not compare criteria defined by explicit ip ranges with the security rules defined by [Azure service tags](https://docs.microsoft.com/en-us/azure/virtual-network/service-tags-overview) and vice versa.
For example, providing that a network security group has a single security rule allowing all traffics from internet by using `Internet` service tag in the source will fail the `allow_in(ip_range: '64.233.160.0')` test due to incompatible source definitions.
This is because InSpec Azure resource pack has no control over which ip ranges are defined in Azure service tags.
Therefore, tests using these methods should be written explicitly for service tags and ip ranges. 
For more information about network security groups and security rules refer to [here](https://docs.microsoft.com/en-us/azure/virtual-network/security-overview).
`*ip_range` used in these methods support IPv4 and IPv6. The ip range criteriaom should be written in CIDR notation.   

For properties applicable to all resources, such as `type`, `name`, `id`, `properties`, refer to [`azure_generic_resource`](azure_generic_resource.md#properties).

Also, refer to [Azure documentation](https://docs.microsoft.com/en-us/rest/api/virtualnetwork/networksecuritygroups/get#networksecuritygroup) for other properties available. 
Any property in the response may be accessed with the key names separated by dots (`.`).

## Examples

### Test that a Resource Group Has the Specified Network Security Group
```ruby
describe azure_network_security_group(resource_group: 'example', name: 'GroupName') do
  it { should exist }
end
```
### Test that a Network Security Group Allows SSH from the Internet
```ruby
describe azure_network_security_group(resource_group: 'example', name: 'GroupName') do
  it { should allow_ssh_from_internet }
end
```    
### Test that a Network Security Group Allows Inbound Traffics from a Certain Ip Range in Any Port and Any Protocol
```ruby
describe azure_network_security_group(resource_group: 'example', name: 'GroupName') do
  it { should allow(source_ip_range: '10.0.0.0/24', direction: 'inbound') }
  it { should allow_in(ip_range: '10.0.0.0/24') }    # same test with the specific inbound rule check
end
```    
### Test that a Network Security Group Allows Inbound Traffics from Internet Service Tag in Port `80` and `TCP` Protocol
```ruby
describe azure_network_security_group(resource_group: 'example', name: 'GroupName') do
  it { should allow(source_service_tag: 'Internet', destination_port: '22', protocol: 'TCP', direction: 'inbound') }
  it { should allow_in(service_tag: 'Internet', port: '22', protocol: 'TCP') }    # same test with the specific inbound rule check
end
```        
### Test that a Network Security Group Allows Inbound Traffics from Virtual Network Service Tag in a Range of Ports and Any Protocol
```ruby
describe azure_network_security_group(resource_group: 'example', name: 'GroupName') do
  it { should allow(source_service_tag: 'VirtualNetwork', destination_port: %w{22 8080 56-78}, direction: 'inbound') }
  it { should allow_in(service_tag: 'VirtualNetwork', port: %w{22 8080 56-78}) }    # same test with the specific inbound rule check
end
```            
### Test that a Network Security Group Allows Outbound Traffics to a Certain Ip Range in any Port and Any Protocol
```ruby
describe azure_network_security_group(resource_group: 'example', name: 'GroupName') do
  it { should allow(destination_ip_range: '10.0.0.0/24', direction: 'outbound') }
  it { should allow_out(ip_range: '10.0.0.0/24') }   # same test with the specific outbound rule check
end
```    
Please note that `allow` requires `direction` parameter is set to either `inbound` or `outbound` and prefix the `ip_range`, `service_tag` and `port` with either `source_` or `destination_` identifiers.     
    
## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](https://www.inspec.io/docs/reference/matchers/).

### exists

The control will pass if the resource returns a result. Use `should_not` if you expect zero matches.
```ruby
# If we expect 'GroupName' to always e``xrubyst
describe azure_network_security_group(resource_group: 'example', name: 'GroupName') do
  it { should exist }
end

# If we expect 'EmptyGroupName' to never e``xrubyst
describe azure_network_security_group(resource_group: 'example', name: 'EmptyGroupName') do
  it { should_not exist }
end
```

## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be setup with a `contributor` role on the subscription you wish to test.

