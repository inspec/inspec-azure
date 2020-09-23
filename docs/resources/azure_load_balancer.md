---
title: About the azure_load_balancer Resource
platform: azure
---

# azure_load_balancer

Use the `azure_load_balancer` InSpec audit resource to test properties and configuration of an Azure Load Balancer.

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

`resource_group` and `name` or the `resource_id` must be given as a parameter.
```ruby
describe azure_load_balancer(resource_group: 'inspec-resource-group-9', name: 'example_lb') do
  it { should exist }
end
```
```ruby
describe azure_load_balancer(resource_id: '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/loadBalancers/{loadBalancerName}') do
  it { should exist }
end
```
## Parameters

| Name                           | Description                                                                       |
|--------------------------------|-----------------------------------------------------------------------------------|
| resource_group                 | Azure resource group that the targeted resource resides in. `MyResourceGroup`     |
| name                           | The unique name of the load balancer. `loadBalancerName`                          |
| loadbalancer_name              | Alias for the `name` parameter.                                                   |
| resource_id                    | The unique resource ID. `/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/loadBalancers/{loadBalancerName}` |

Either one of the parameter sets can be provided for a valid query:
- `resource_id`
- `resource_group` and `name`
- `resource_group` and `loadbalancer_name`


## Properties

| Property          | Description |
|-------------------|-------------|
| sku.name          | Name of a load balancer SKU. |

For properties applicable to all resources, such as `type`, `name`, `id`, `properties`, refer to [`azure_generic_resource`](azure_generic_resource.md#properties).

Also, refer to [Azure documentation](https://docs.microsoft.com/en-us/rest/api/load-balancer/loadbalancers/get#loadbalancer) for other properties available. 
Any attribute in the response may be accessed with the key names separated by dots (`.`).


## Examples

### Test if a Load Balancer has Any Inbound Nat Rules
```ruby
describe azure_load_balancer(resource_group: 'my-rg', name: 'lb-1') do
  its('properties.inboundNatRules') { should_not be_empty }
end
```

### Loop through All Load Balancers in a Subscription via `resource_id`
```ruby
azure_load_balancers.ids.each do |id|
    describe azure_load_balancer(resource_id: id) do
      its('properties.inboundNatRules') { should_not be_empty }
    end
end 
```
## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](https://docs.chef.io/inspec/matchers/).

### exists
```ruby
# If we expect the resource to always exist
describe azure_load_balancer(resource_group: 'my-rg', name: 'lb-1') do
  it { should exist }
end

# If we expect the resource to never exist
describe azure_load_balancer(resource_group: 'my-rg', name: 'lb-1') do
  it { should_not exist }
end
```
## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be setup with a `contributor` role on the subscription you wish to test.
