---
title: About the azure_service_bus_namespace Resource
platform: azure
---

# azure_service_bus_namespace

Use the `azure_service_bus_namespace` InSpec audit resource to test properties related to an Azure Service Bus Namespace.

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

`name`, `resource_group` is a required parameter.

```ruby
describe azure_service_bus_namespace(resource_group: 'RESOURCE_GROUP', name: 'SERVICE_BUS_NAMESPACE') do
  it                                      { should exist }
  its('type')                             { should eq 'Microsoft.ServiceBus/Namespaces' }
  its('location')                         { should eq 'East US' }
end
```

```ruby
describe azure_service_bus_namespace(resource_group: 'RESOURCE_GROUP', name: 'SERVICE_BUS_NAMESPACE') do
  it  { should exist }
end
```
## Parameters

| Name           | Description                                                                      |
|----------------|----------------------------------------------------------------------------------|
| name           | Name of the Azure Service Bus Namespaces to test.                                   |
| resource_group | Azure resource group that the targeted resource resides in. `MyResourceGroup`    |

The parameter set should be provided for a valid query:
- `resource_group` and `name`

## Properties

| Property                 | Description                                                      |
|--------------------------|------------------------------------------------------------------|
| id                       | Resource Id.                                                     |
| name                     | Resource name.                                                   |
| type                     | Resource type. `Microsoft.ServiceBus/Namespaces`                 |
| location                 | The Geo-location where the resource lives.                       |
| properties               | The properties of the Service Bus Namespace.                     |
| properties.serviceBusEndpoint | Endpoint you can use to perform Service Bus operations.     |
| properties.metricId      | Identifier for Azure Insights metrics.                           |
| properties.provisioningState | Provisioning state of the namespace.                         |
| sku.name                 | Name of this SKU.                                                |


For properties applicable to all resources, such as `type`, `name`, `id`, `properties`, refer to [`azure_generic_resource`](azure_generic_resource.md#properties).

Also, refer to [Azure documentation](https://docs.microsoft.com/en-us/rest/api/servicebus/stable/namespaces/get) for other properties available.

## Examples

### Test that the Service Bus Namespaces is provisioned successfully.

```ruby
describe azure_service_bus_namespace(resource_group: 'RESOURCE_GROUP', name: 'SERVICE_BUS_NAMESPACE') do
  its('properties.provisioningState') { should eq 'Succeeded' }
end
```

## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](/inspec/matchers/).

### exists

```ruby
# If a Service Bus Namespace is found it will exist
describe azure_service_bus_namespace(resource_group: 'RESOURCE_GROUP', name: 'SERVICE_BUS_NAMESPACE') do
  it { should exist }
end
# if Service Bus Namespace is not found it will not exist
describe azure_service_bus_namespace(resource_group: 'RESOURCE_GROUP', name: 'SERVICE_BUS_NAMESPACE') do
  it { should_not exist }
end
```

## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be setup with a `reader` role on the subscription you wish to test.