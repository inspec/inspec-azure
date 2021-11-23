---
title: About the azure_service_bus_topic Resource
platform: azure
---

# azure_service_bus_topic

Use the `azure_service_bus_topic` InSpec audit resource to test properties related to an Azure Service Bus Topic.

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

`name`, `namespace_name` and `resource_group` is a required parameter.

```ruby
describe azure_service_bus_topic(resource_group: 'RESOURCE_GROUP', namespace_name: 'SERVICE_BUS_NAMESPACE_NAME', name: 'SERVICE_BUS_NAMESPACE') do
  it                                      { should exist }
  its('type')                             { should eq 'Microsoft.ServiceBus/Namespaces/Topics' }
end
```

```ruby
describe azure_service_bus_topic(resource_group: 'RESOURCE_GROUP', namespace_name: 'SERVICE_BUS_NAMESPACE_NAME', name: 'SERVICE_BUS_NAMESPACE') do
  it  { should exist }
end
```
## Parameters

| Name           | Description                                                                      |
|----------------|----------------------------------------------------------------------------------|
| name           | Name of the Azure Service Bus Topics to test.                                    |
| resource_group | Azure resource group that the targeted resource resides in. `MyResourceGroup`    |
| namespace_name | Name of the namespace where the topic resides in.                                |

The parameter set should be provided for a valid query:
- `resource_group` , `namespace_name` and `name`

## Properties

| Property                 | Description                                                      |
|--------------------------|------------------------------------------------------------------|
| id                       | Resource Id.                                                     |
| name                     | Resource name.                                                   |
| type                     | Resource type. `Microsoft.ServiceBus/Namespaces/Topics`          |
| properties               | The properties of the Service Bus Topic.                         |
| properties.maxSizeInMegabytes | Maximum size of the topic in megabytes, which is the size of the memory allocated for the topic. Default is 1024.|
| properties.sizeInBytes   | Size of the topic, in bytes.                                     |
| properties.status        | Enumerates the possible values for the status of a messaging entity.|
| properties.countDetails  | Message count details.                                           |


For properties applicable to all resources, such as `type`, `name`, `id`, `properties`, refer to [`azure_generic_resource`](azure_generic_resource.md#properties).

Also, refer to [Azure documentation](https://docs.microsoft.com/en-us/rest/api/servicebus/stable/topics/get) for other properties available.

## Examples

### Test that the Service Bus Topics is provisioned successfully.

```ruby
describe azure_service_bus_topic(resource_group: 'RESOURCE_GROUP', namespace_name: 'SERVICE_BUS_NAMESPACE_NAME', name: 'SERVICE_BUS_NAMESPACE') do
  its('properties.status') { should eq 'Active' }
end
```

## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](/inspec/matchers/).

### exists

```ruby
# If a Service Bus Topic is found it will exist
describe azure_service_bus_topic(resource_group: 'RESOURCE_GROUP', namespace_name: 'SERVICE_BUS_NAMESPACE_NAME', name: 'SERVICE_BUS_NAMESPACE') do
  it { should exist }
end
# if Service Bus Topic is not found it will not exist
describe azure_service_bus_topic(resource_group: 'RESOURCE_GROUP', namespace_name: 'SERVICE_BUS_NAMESPACE_NAME', name: 'SERVICE_BUS_NAMESPACE') do
  it { should_not exist }
end
```

## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be setup with a `reader` role on the subscription you wish to test.