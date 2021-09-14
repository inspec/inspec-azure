---
title: About the azure_data_factory_linked_service Resource
platform: azure
---

# azure_data_factory_linked_service

Use the `azure_data_factory_linked_service` InSpec audit resource to test the properties related to linked services for a resource group or the entire subscription.

## Azure REST API Version, Endpoint, and HTTP Client Parameters

This resource interacts with API versions supported by the resource provider. The `api_version` is defined as a resource parameter. If not provided, the latest version is used. For more information, refer to [`azure_generic_resource`](azure_generic_resource.md).

Unless defined, `azure_cloud` global endpoint and default values for the HTTP client is used. For more information, refer to the resource pack [README](../../README.md). For information on API, refer [`Azure Linked Services Docs`](https://docs.microsoft.com/en-us/rest/api/datafactory/linked-services/list-by-factory).

## Availability

### Installation

This resource is available in the [InSpec Azure resource pack](https://github.com/inspec/inspec-azure). For an example, `inspec.yml` file and how to set up your Azure credentials, refer to resource pack [README](../../README.md#Service-Principal).

## Syntax

An `azure_data_factory_linked_service` resource block returns all Azure Linked Services, either within a Resource Group (if provided), or within an entire Subscription.

```ruby
describe (resource_group: `RESOURCE_GROUP`, factory_name: 'FACTORY_NAME') do
  #...
end
```

`resource_group` and `factory_name` are required parameters.

## Parameters

| Name                           | Description                                                                       |
|--------------------------------|-----------------------------------------------------------------------------------|
| resource_group                 | Azure resource group that the targeted resource resides in.                       |
| factory_name                   | Azure factory name for which linked services are retrived.                        |

## Properties

| Property        | Description                                            | Filter Criteria<superscript>*</superscript> |
|-----------------|---------------------------------------------------------|-----------------------|
| names                 | A list of the unique resource names.              | `name`                |
| ids                   | A list of Linked Services IDs.                    | `id`                  |
| properties            | A list of properties for the resource             | `properties`          |
| provisioning_states   | The linked services provisioning state.           | `provisioning_state`  |
| linked_service_types  | The type of linked service resource.              | `linked_service_type` |
| type_properties       | The linked service type of properties.            |  `type_properties`    |

<superscript>*</superscript> For information on how to use filter criteria on plural resources, refer to [FilterTable usage](https://github.com/inspec/inspec/blob/master/dev-docs/filtertable-usage.md).

## Examples

### Test if any linked services exist in the resource group

```ruby
describe azure_data_factory_linked_service(resource_group: `RESOURCE_GROUP`, factory_name: 'FACTORY_NAME') do
  it { should exist }
  its('names') { should include "factory_name" }
end
```

### Test that there aren't any Linked Services in a resource group

```ruby
# Should not exist if no Linked Services are in the resource group
describe azure_data_factory_linked_service(resource_group: `RESOURCE_GROUP`, factory_name: 'FACTORY_NAME') do
  it { should_not exist }
end
```

### Filter Linked Services in a resource group by properties

```ruby
describe azure_data_factory_linked_service(resource_group: `RESOURCE_GROUP`, factory_name: 'FACTORY_NAME') do
  its('names') { should include linked_service_name1 }
  its('types') { should include 'Microsoft.DataFactory/factories/linkedservices' }
  its('linked_service_types') { should include('MySql') }
end
```

## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be set up with a `contributor` role on the subscription you wish to test.
