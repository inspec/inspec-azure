---
title: About the azure_application_gateway Resource
platform: azure
---

# azure_application_gateway

Use the `azure_application_gateway` InSpec audit resource to test properties and configuration of an Azure Application Gateway.

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

The `resource_group` and `name` must be given as a parameter.
```ruby
describe azure_application_gateway(resource_group: 'inspec-resource-group-9', name: 'example_lb') do
  it { should exist }
end
```
## Parameters

| Name                           | Description                                                                       |
|--------------------------------|-----------------------------------------------------------------------------------|
| resource_group                 | Azure resource group that the targeted resource resides in. `MyResourceGroup`     |
| name                           | The unique name of the targeted resource. `gatewayName`                           |
| application_gateway_name       | Alias for the `name` parameter.                                                   |
| resource_id                    | The unique resource ID. `/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.Network/applicationGateways/{gatewayName}` |

Either one of the parameter sets can be provided for a valid query:
- `resource_id`
- `resource_group` and `name`
- `resource_group` and `application_gateway_name`

## Properties

| Property          | Description |
|-------------------|-------------|
| identity          | The identity of the application gateway, if configured. It is a [managed service identity object](https://docs.microsoft.com/en-us/rest/api/application-gateway/applicationgateways/get#managedserviceidentity). |
| zones             | A list of availability zones denoting where the resource needs to come from. |

For properties applicable to all resources, such as `type`, `name`, `id`, `properties`, refer to [`azure_generic_resource`](azure_generic_resource.md#properties).

Also, refer to [Azure documentation](https://docs.microsoft.com/en-us/rest/api/application-gateway/applicationgateways/get#applicationgateway) for other properties available. 
Any attribute in the response may be accessed with the key names separated by dots (`.`).

## Examples

### Test the SSL Policy Name of an Application Gateway
```ruby
describe azure_application_gateway(resource_group: 'resource_group', application_gateway_name: 'application_gateway_name') do
  its('properties.sslPolicy.policyName') { should eq 'AppGwSslPolicy20170401S' }
end
```
```ruby
describe azure_application_gateway(resource_id: '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.Network/applicationGateways/{gatewayName}') do
  its('properties.sslPolicy.policyName') { should eq 'AppGwSslPolicy20170401S' }
end
```

See [integration tests](../../test/integration/verify/controls/azurerm_application_gateway.rb) for more examples.

## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](https://docs.chef.io/inspec/matchers/).

### exists
```ruby
# If we expect 'appgw-1' to always exist
describe azure_application_gateway(resource_group: 'example', name: 'appgw-1') do
  it { should exist }
end

# If we expect 'appgw-1' to never exist
describe azure_application_gateway(resource_group: 'example', name: 'appgw-1') do
  it { should_not exist }
end
```
## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be setup with a `contributor` role on the subscription you wish to test.
