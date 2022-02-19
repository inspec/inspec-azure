---
title: About the azure_sql_virtual_machines Resource
platform: azure
---

# azure_sql_virtual_machines

Use the `azure_sql_virtual_machines` InSpec audit resource to test properties of all Azure SQL virtual machines.

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

An `azure_sql_virtual_machines` resource block returns all Azure SQL virtual machines.

```ruby
describe azure_sql_virtual_machines do
  #...
end
```

## Parameters

`resource_group` _(optional)_

Azure resource group that the targeted resource resides in.

## Properties

|Property                        | Description                                                            | Filter Criteria<superscript>*</superscript> |
|--------------------------------|------------------------------------------------------------------------|------------------|
| ids                            | A list of resource IDs.                                                | `id`             |
| names                          | A list of resource Names.                                              | `name`           |
| types                          | A list of the resource types.                                          | `type`           |
| properties                     | A list of Properties for all the SQL virtual machines.                 | `properties`     |
| locations                      | A list of the Geo-locations.                                           | `location`       |
| provisioningStates             | A list of provisioning states of the SQL virtual machines.             | `provisioningState`|

<superscript>*</superscript> For information on how to use filter criteria on plural resources refer to [FilterTable usage](https://github.com/inspec/inspec/blob/master/dev-docs/filtertable-usage.md).

## Examples

### Loop through SQL virtual machines by their names.

```ruby
azure_sql_virtual_machines(resource_group: 'RESOURCE_GROUP').names.each do |name|
  describe azure_sql_virtual_machine(resource_group: 'RESOURCE_GROUP', name: name) do
    it { should exist }
  end
end
```

### Test that there are SQL virtual machines that are successfully provisioned.

```ruby
describe azure_sql_virtual_machines(resource_group: 'RESOURCE_GROUP').where(provisioningState: 'Succeeded') do
  it { should exist }
end
```

## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](https://www.inspec.io/docs/reference/matchers/).

### exists

```ruby
# Should not exist if no SQL virtual machines are present
describe azure_sql_virtual_machines(resource_group: 'RESOURCE_GROUP') do
  it { should_not exist }
end
# Should exist if the filter returns at least one SQL virtual machines
describe azure_sql_virtual_machines(resource_group: 'RESOURCE_GROUP') do
  it { should exist }
end
```

## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be setup with a `reader` role on the subscription you wish to test.
