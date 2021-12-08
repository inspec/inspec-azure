---
title: About the azure_sql_managed_instances Resource
platform: azure
---

# azure_sql_managed_instances

Use the `azure_sql_managed_instances` InSpec audit resource to test the properties related to all Azure SQL managed instances within a project.

## Azure REST API Version, Endpoint, and HTTP Client Parameters

This resource interacts with API versions supported by the resource provider. The `api_version` is known as a resource parameter. If not provided, the latest version is used. For more information, refer to [`azure_generic_resource`](azure_generic_resource.md).

Unless defined, `azure_cloud` global endpoint and default values for the HTTP client is used. For more information, refer to the resource pack [README](../../README.md).

## Availability

### Installation

This resource is available in the [InSpec Azure resource pack](https://github.com/inspec/inspec-azure). For an example, `inspec.yml` file and how to set up your Azure credentials, refer to resource pack [README](../../README.md#Service-Principal).

## Syntax

An `azure_sql_managed_instances` resource block returns all Azure SQL managed instances within a project.

```ruby
describe azure_sql_managed_instances do
  #...
end
```

## Parameters

`resource_group` _(optional)_

The Azure resource group that the targeted resource resides in.

## Properties

|Property                        | Description                                                            | Filter Criteria<superscript>*</superscript> |
|--------------------------------|------------------------------------------------------------------------|------------------|
| ids                            | A list of resource IDs.                                                | `id`             |
| names                          | A list of resource names.                                              | `name`           |
| types                          | A list of the resource types.                                          | `type`           |
| properties                     | A list of properties for all the SQL managed instances.                | `properties`     |
| locations                      | A list of the locations.                                               | `location`       |
| provisioningStates             | A list of provisioning states of all the SQL managed instances.        | `provisioningState`|
| minimalTlsVersions             | A list of minimalTlsVersion for all the SQL managed instances.         | `minimalTlsVersion` |
| sku_names                      | A list of names for the sku.                                           | `sku_name`       |
| sku_tiers                      | A list of tiers for the sku.                                           | `sku_tier`       |

<superscript>*</superscript> For information on how to use filter criteria on plural resources, refer to [FilterTable usage](https://github.com/inspec/inspec/blob/master/dev-docs/filtertable-usage.md).

## Examples

### Loop through SQL managed instances by their names

```ruby
azure_sql_managed_instances(resource_group: 'RESOURCE_GROUP').names.each do |name|
  describe azure_sql_managed_instance(resource_group: 'RESOURCE_GROUP', name: name) do
    it { should exist }
  end
end
```

### Test that there are SQL managed instances that are successfully provisioned

```ruby
describe azure_sql_managed_instances.where(provisioningState: 'Succeeded') do
  it { should exist }
end
```

## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](https://www.inspec.io/docs/reference/matchers/).

### exists

```ruby
# Should not exist if no SQL Managed Instances are present
describe azure_sql_managed_instances do
  it { should_not exist }
end
# Should exist if the filter returns at least one SQL Managed Instances
describe azure_sql_managed_instances do
  it { should exist }
end
```

## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be set up with a `reader` role on the subscription you wish to test.
