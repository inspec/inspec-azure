---
title: About the azure_sql_managed_instance Resource
platform: azure
---

# azure_sql_managed_instance

Use the `azure_sql_managed_instance` InSpec audit resource to test the properties related to an Azure SQL managed instance.

## Azure REST API version, Endpoint, and HTTP Client Parameters

This resource interacts with API versions supported by the resource provider. The `api_version` is known as a resource parameter. If not provided, the latest version is used. For more information, refer to [`azure_generic_resource`](azure_generic_resource.md).

Unless defined, `azure_cloud` global endpoint and default values for the HTTP client are used. For more information, refer to the resource pack [README](../../README.md).

## Availability

### Installation

This resource is available in the [InSpec Azure resource pack](https://github.com/inspec/inspec-azure). For an example, `inspec.yml` file and how to set up your Azure credentials, refer to resource pack [README](../../README.md#Service-Principal).

## Syntax

`name`, `resource_group` are required parameters.

```ruby
describe azure_sql_managed_instance(resource_group: 'RESOURCE_GROUP', name: 'INSTANCE_NAME') do
  it                                      { should exist }
  its('type')                             { should eq 'Microsoft.Sql/managedInstances' }
  its('location')                         { should eq 'eastus' }
end
```

```ruby
describe azure_sql_managed_instance(resource_group: 'RESOURCE_GROUP', name: 'INSTANCE_NAME') do
  it  { should exist }
end
```

## Parameters

| Name             | Description                                                                        |
|:----------------:|:----------------------------------------------------------------------------------:|
| name             | Name of the Azure SQL managed instances to test.                                   |
| resource_group   | Azure resource group that the targeted resource resides in.                        |

The parameter set should be provided for a valid query: `resource_group` and `name`

## Properties

| Property                       | Description                                                                       |
|:------------------------------:|:---------------------------------------------------------------------------------:|
| id                             | Resource ID.                                                                      |
| name                           | Resource name.                                                                    |
| type                           | Resource type.                                                                    |
| location                       | Resource location.                                                                |
| properties                     | The properties of the SQL Managed Instance.                                       |
| properties.minimalTlsVersion   | Minimal TLS version. Allowed values are 'None', '1.0', '1.1', '1.2'               |
| properties.maintenanceConfigurationId | Specifies maintenance configuration id to apply to this managed instance.  |
| properties.provisioningState   | Provisioning state of the SQL managed instance.                                   |
| sku.name                       | The name of the SKU, typically, a letter with a number code. For example, P3.     |

For properties applicable to all resources, such as `type`, `name`, `id`, `properties` refer to [`azure_generic_resource`](azure_generic_resource.md#properties). Also, refer to [Azure documentation](https://docs.microsoft.com/en-us/rest/api/sql/2021-02-01-preview/managed-instances/get) for other properties available.

## Examples

### Test that the SQL managed instances is provisioned successfully

```ruby
describe azure_sql_managed_instance(resource_group: 'RESOURCE_GROUP', name: 'INSTANCE_NAME') do
  its('properties.provisioningState') { should eq 'Succeeded' }
end
```

## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](/inspec/matchers/).

### exists

```ruby
# If a SQL managed instance is found, it will exist
describe azure_sql_managed_instance(resource_group: 'RESOURCE_GROUP', name: 'INSTANCE_NAME') do
  it { should exist }
end
# if SQL managed instance is not found, it will not exist
describe azure_sql_managed_instance(resource_group: 'RESOURCE_GROUP', name: 'INSTANCE_NAME') do
  it { should_not exist }
end
```

## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be set up with a `reader` role on the subscription you wish to test.
