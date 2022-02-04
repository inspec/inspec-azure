---
title: About the azure_api_management Resource
platform: azure
---

# azure_api_management

Use the `azure_api_management` InSpec audit resource to test properties and configuration of an Azure API Management Service.

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

`resource_group` and `name` or the `resource_id` must be given as a parameter.
```ruby
describe azure_api_management(resource_group: 'inspec-resource-group-9', name: 'apim01') do
  it { should exist }
end
```
```ruby
describe azure_api_management(resource_id: '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.ApiManagement/service/{apim01}') do
  it { should exist }
end
```
## Parameters

| Name                           | Description                                                                       |
|--------------------------------|-----------------------------------------------------------------------------------|
| resource_group                 | Azure resource group that the targeted resource resides in. `MyResourceGroup`     |
| name                           | The unique name of the API Management Service. `apim01`                           |
| api_management_name            | Alias for the `name` parameter.                                                    |
| resource_id                    | The unique resource ID. `/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.ApiManagement/service/{apim01}` |

Either one of the parameter sets can be provided for a valid query:
- `resource_id`
- `resource_group` and `name`
- `resource_group` and `api_management_name`

## Properties

| Property          | Description |
|-------------------|-------------|
| identity          | Managed service identity of the Api Management service. It is an [api management service identity object](https://docs.microsoft.com/en-us/rest/api/apimanagement/2019-12-01/apimanagementservice/get#apimanagementserviceidentity). |
| sku               | The SKU (pricing tier) of the resource. |

For properties applicable to all resources, such as `type`, `name`, `id`, `properties`, refer to [`azure_generic_resource`](azure_generic_resource.md#properties).

Also, refer to [Azure documentation](https://docs.microsoft.com/en-us/rest/api/apimanagement/2019-12-01/apimanagementservice/get#apimanagementserviceresource) for other properties available. 
Any attribute in the response may be accessed with the key names separated by dots (`.`).

## Examples

### Test API Management Service's Publisher Email Value
```ruby
describe azure_api_management(resource_group: resource_group, api_management_name: api_management_name) do
  its('properties.publisherEmail') { should eq 'company@inspec.io' }
end
```

### Loop through Resources via Plural Resource
```ruby
azure_api_managements.ids.each do |resource_id|
  describe azure_api_management(resource_id: resource_id) do
    its('properties.publisherEmail') { should eq 'company@inspec.io' }
  end
end
```
See [integration tests](../../test/integration/verify/controls/azure_api_management.rb) for more examples.

## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](https://docs.chef.io/inspec/matchers/).

### exists
```ruby
# If we expect 'apim01' to always exist
describe azure_api_management(resource_group: 'example', name: 'apim01') do
  it { should exist }
end

# If we expect 'apim01' to never exist
describe azure_api_management(resource_group: 'example', name: 'apim01') do
  it { should_not exist }
end
```
## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be setup with a `contributor` role on the subscription you wish to test.

