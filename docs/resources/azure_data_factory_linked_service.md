---
title: About the azure_data_factory_linked_service Resource
platform: azure
---

# azure_data_factory_linked_service

Use the `azure_data_factory_linked_service` InSpec audit resource to test the properties of an Azure Linked service.

## Azure REST API Version, Endpoint, and HTTP Client Parameters

This resource interacts with API versions supported by the resource provider. The `api_version` is defined as a resource parameter.
If not provided, the latest version is used. For more information, refer to [`azure_generic_resource`](azure_generic_resource.md).

Unless defined, `azure_cloud` global endpoint and default values for the HTTP client is used. For more information, refer to the resource pack [README](../../README.md). For API related info : [`Azure Linked Services Docs`](https://docs.microsoft.com/en-us/rest/api/datafactory/linked-services/get).

## Availability

### Installation

This resource is available in the [InSpec Azure resource pack](https://github.com/inspec/inspec-azure). For an example, `inspec.yml` file and how to set up your Azure credentials, refer to resource pack [README](../../README.md#Service-Principal).

## Syntax

`resource_group`, `linked_service_name`, and `factory_name` are required parameters.

```ruby
describe azure_data_factory_linked_service(resource_group: `RESOURCE_GROUP`, factory_name: `FACTORY_NAME`, linked_service_name: `LINKED_SERVICE_NAME`) do
end
```

## Parameters

| Name                           | Description                                                                       |
|--------------------------------|-----------------------------------------------------------------------------------|
| resource_group                 | Azure resource group that the targeted resource resides in.                       |
| factory_name                   | The factory name.                                                                 |
| linked_service_name            | The name of the linked service. |

All the parameter sets are required for a valid query:

- `resource_group` , `factory_name`, and `linked_service_name`.

## Properties

| Name                           | Description                                                                      |
|--------------------------------|----------------------------------------------------------------------------------|
| name                           | Name of the Azure resource to test.                                              |
| type                           | The resource type.                                                               |
| linked_service_type            | The linked services type.                                                        |
| type_properties                | The properties of linked service type.                                           |
| properties                     | The properties of the resource.                                                  |

## Examples

### Test that a Linked Service exists

```ruby
describe azure_data_factory_linked_service(resource_group: `RESOURCE_GROUP`, factory_name: `FACTORY_NAME`, linked_service_name: `LINKED_SERVICE_NAME`) do
  it { should exist }
end
```

### Test that a linked service does not exist

```ruby
describe azure_data_factory_linked_service(resource_group: `RESOURCE_GROUP`, factory_name: `FACTORY_NAME`, linked_service_name: 'should not exit') do
  it { should_not exist }
end
```

### Test properties of a linked service

```ruby
describe azure_data_factory_linked_service(resource_group: `RESOURCE_GROUP`, name: 'FACTORY_NAME') do
  its('name') { should eq linked_service_name1 }
  its('type') { should eq 'Microsoft.DataFactory/factories/linkedservices' }
  its('linked_service_type') { should eq 'MYSQL' }
end
```

## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be set up with a `contributor` role on the subscription you wish to test.
