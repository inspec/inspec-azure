---
title: About the azure_express_route_providers Resource
platform: azure
---

# azure_express_route_providers

Use the `azure_express_route_providers` InSpec audit resource to test properties related to azure_express_route for a resource group or the entire subscription.

## Azure REST API version, endpoint and http client parameters

This resource interacts with api versions supported by the resource provider.
The `api_version` can be defined as a resource parameter.
If not provided, the latest version will be used.
For more information, refer to [`azure_generic_resource`](azure_generic_resource.md).

Unless defined, `azure_cloud` global endpoint, and default values for the http client will be used.
For more information, refer to the resource pack [README](../../README.md).
For api related info : [`Azure Express Route Providers Docs`](https://docs.microsoft.com/en-us/rest/api/expressroute/express-route-service-providers/list).

## Availability

### Installation

This resource is available in the [InSpec Azure resource pack](https://github.com/inspec/inspec-azure). 
For an example `inspec.yml` file and how to set up your Azure credentials, refer to resource pack [README](../../README.md#Service-Principal).

## Syntax

An `azure_express_route_providers` resource block returns all Azure azure_express_route, either within a Resource Group (if provided), or within an entire Subscription.
```ruby
describe azure_express_route_providers do
  #...
end
```
or
```ruby
describe azure_express_route_providers(resource_group: 'my-rg') do
  #...
end
```
## Parameters

- `resource_group` (Optional)

## Properties

|Property       | Description                                                                          | Filter Criteria<superscript>*</superscript> |
|---------------|--------------------------------------------------------------------------------------|-----------------|
| names           | A list of the unique resource ids.                                                   | `name`            |
| types      | A list of all the azure_express_route.                                | `type`       |
| ids    | A list of id for all the azure_express_route.                                   | `id`    |
| tags      | A list of all the express_route names.                                             | `tag`          |
| provisioning_states     | A list of status of request| `provisioning_state`|
| peering_locations_list          | A list of `peering locations` pairs defined on the resources.                                | `locations`          |
| bandwidths_offered_list          | A list of `bandwidths offered` pairs defined on the resources.                                | `bandwidths`          |
  
<superscript>*</superscript> For information on how to use filter criteria on plural resources refer to [FilterTable usage](https://github.com/inspec/inspec/blob/master/dev-docs/filtertable-usage.md).
  
## Examples

### Test If Any azure_express_route Exist in the Resource Group
```ruby
describe azure_express_route_providers(resource_group: 'MyResourceGroup') do
  it { should exist }
end
describe azure_express_route_providers do
  it { should exist }
end
``` 
### Test that There are express_route that Includes a Certain String in their Names (Server Side Filtering via Generic Resource - Recommended)   
```ruby
describe azure_generic_resources(resource_group: 'MyResourceGroup') do
  it { should exist }
end
```
## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](https://www.inspec.io/docs/reference/matchers/).


```ruby
# Should not exist if no azure_express_route are in the resource group
describe azure_express_route_providers(resource_group: 'MyResourceGroup') do
  its('provisioning_states') { should include('Succeeded') }
  its('peering_locations_list') { should include(["Melbourne", "Sydney"]) }
  its('bandwidths_offered_list') { should include('bandwidths_offered') }
end


```
## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be setup with a `contributor` role on the subscription you wish to test.
