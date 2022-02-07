---
title: About the azure_sql_virtual_machine_group_availability_listeners Resource
platform: azure
---

# azure_sql_virtual_machine_group_availability_listeners

Use the `azure_sql_virtual_machine_group_availability_listeners` InSpec audit resource to test properties related to all Azure SQL virtual machine group availability listeners.

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

An `azure_sql_virtual_machine_group_availability_listeners` resource block returns all Azure SQL virtual machine group availability listeners.

```ruby
describe azure_sql_virtual_machine_group_availability_listeners(resource_group: 'RESOURCE_GROUP', sql_virtual_machine_group_name: 'SQL_VIRTUAL_MACHINE_GROUP_NAME') do
  #...
end
```

## Parameters

`resource_group` _(required)_

Azure resource group that the targeted resource resides in.

`sql_virtual_machine_group_name` _(required)_

Azure SQL virtual machine group name

## Properties

|Property                        | Description                                                            | Filter Criteria<superscript>*</superscript> |
|--------------------------------|------------------------------------------------------------------------|------------------|
| ids                            | A list of resource IDs.                                                | `id`             |
| names                          | A list of resource names.                                              | `name`           |
| types                          | A list of the resource types.                                          | `type`           |
| properties                     | A list of Properties for all the SQL virtual machine group availability listeners.     | `properties`     |
| provisioningStates             | A list of provisioning states of the SQL virtual machine group availability listeners. | `provisioningState`|

<superscript>*</superscript> For information on how to use filter criteria on plural resources refer to [FilterTable usage](https://github.com/inspec/inspec/blob/master/dev-docs/filtertable-usage.md).

## Examples

### Loop through SQL virtual machine group availability listeners by their names.

```ruby
azure_sql_virtual_machine_group_availability_listeners(resource_group: 'RESOURCE_GROUP', sql_virtual_machine_group_name: 'SQL_VIRTUAL_MACHINE_GROUP_NAME').names.each do |name|
  describe azure_sql_virtual_machine_group_availability_listener(resource_group: 'RESOURCE_GROUP', sql_virtual_machine_group_name: 'SQL_VIRTUAL_MACHINE_GROUP_NAME', name: name) do
    it { should exist }
  end
end
```

### Test that there are SQL virtual machine group availability listeners that are successfully provisioned.

```ruby
describe azure_sql_virtual_machine_group_availability_listeners(resource_group: 'RESOURCE_GROUP', sql_virtual_machine_group_name: 'SQL_VIRTUAL_MACHINE_GROUP_NAME').where(provisioningState: 'Succeeded') do
  it { should exist }
end
```

## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](https://www.inspec.io/docs/reference/matchers/).

### exists

```ruby
# Should not exist if no SQL virtual machine group availability listeners are present
describe azure_sql_virtual_machine_group_availability_listeners(resource_group: 'RESOURCE_GROUP', sql_virtual_machine_group_name: 'SQL_VIRTUAL_MACHINE_GROUP_NAME') do
  it { should_not exist }
end
# Should exist if the filter returns at least one SQL virtual machine group availability listeners
describe azure_sql_virtual_machine_group_availability_listeners(resource_group: 'RESOURCE_GROUP', sql_virtual_machine_group_name: 'SQL_VIRTUAL_MACHINE_GROUP_NAME') do
  it { should exist }
end
```

## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be setup with a `reader` role on the subscription you wish to test.
