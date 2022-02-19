---
title: About the azure_sql_virtual_machine_group_availability_listener Resource
platform: azure
---

# azure_sql_virtual_machine_group_availability_listener

Use the `azure_sql_virtual_machine_group_availability_listener` InSpec audit resource to test properties related to an Azure SQL virtual machine group availability listener.

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

```ruby
describe azure_sql_virtual_machine_group_availability_listener(resource_group: 'RESOURCE_GROUP', sql_virtual_machine_group_name: 'SQL_VIRTUAL_MACHINE_GROUP_NAME', name: 'AVAILABILITY_LISTENER_NAME') do
  it                                      { should exist }
  its('type')                             { should eq 'Microsoft.SqlVirtualMachine/sqlVirtualMachineGroups/availabilityGroupListeners' }
end
```

```ruby
describe azure_sql_virtual_machine_group_availability_listener(resource_group: 'RESOURCE_GROUP', sql_virtual_machine_group_name: 'SQL_VIRTUAL_MACHINE_GROUP_NAME', name: 'AVAILABILITY_LISTENER_NAME') do
  it  { should exist }
end
```

## Parameters

`name` _(required)_

Name of the Azure SQL virtual machine group availability listeners to test.

`resource_group` _(required)_

Azure resource group that the targeted resource resides in.

`sql_virtual_machine_group_name` _(required)_

The Azure SQL virtual machine group name

## Properties

| Property                 | Description                                                      |
|--------------------------|------------------------------------------------------------------|
| id                       | Resource ID.                                                     |
| name                     | Resource name.                                                   |
| type                     | Resource type.                                                   |
| properties               | The properties of the SQL virtual machine group availability listener. |
| properties.provisioningState | State of the resource.                                       |


For properties applicable to all resources, such as `type`, `name`, `id`, `properties`, refer to [`azure_generic_resource`](azure_generic_resource.md#properties).

Also, refer to [Azure documentation](https://docs.microsoft.com/en-us/rest/api/servicefabric/sfmeshrp-api-application_get) for other properties available.

## Examples

### Test that the SQL virtual machine group availability listener is provisioned successfully.

```ruby
describe azure_sql_virtual_machine_group_availability_listener(resource_group: 'RESOURCE_GROUP', sql_virtual_machine_group_name: 'SQL_VIRTUAL_MACHINE_GROUP_NAME', name: 'AVAILABILITY_LISTENER_NAME') do
  its('properties.provisioningState') { should eq 'Succeeded' }
end
```

## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](/inspec/matchers/).

### exists

```ruby
# If a SQL virtual machine group availability listener is found it will exist
describe azure_sql_virtual_machine_group_availability_listener(resource_group: 'RESOURCE_GROUP', sql_virtual_machine_group_name: 'SQL_VIRTUAL_MACHINE_GROUP_NAME', name: 'AVAILABILITY_LISTENER_NAME') do
  it { should exist }
end
# if SQL virtual machine group availability listener is not found it will not exist
describe azure_sql_virtual_machine_group_availability_listener(resource_group: 'RESOURCE_GROUP', sql_virtual_machine_group_name: 'SQL_VIRTUAL_MACHINE_GROUP_NAME', name: 'AVAILABILITY_LISTENER_NAME') do
  it { should_not exist }
end
```

## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be setup with a `reader` role on the subscription you wish to test.
