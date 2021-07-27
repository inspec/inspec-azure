---
title: About the azure_df_dataset Resource
platform: azure
---

# azure_df_dataset

Use the `azure_df_dataset` InSpec audit resource to test properties related to a data set.

## Azure REST API version, endpoint and http client parameters

This resource interacts with api versions supported by the resource provider.
The `api_version` can be defined as a resource parameter.
If not provided, the latest version will be used.
For more information, refer to [`azure_generic_resource`](azure_generic_resource.md).

Unless defined, `azure_cloud` global endpoint, and default values for the http client will be used.
For more information, refer to the resource pack [README](../../README.md).
For api related info : [`Azure Data Factories Docs`](https://docs.microsoft.com/en-us/rest/api/dataset/factories/get).


## Availability

### Installation

This resource is available in the [InSpec Azure resource pack](https://github.com/inspec/inspec-azure).
For an example `inspec.yml` file and how to set up your Azure credentials, refer to resource pack [README](../../README.md#Service-Principal).

## Syntax

`resource_group` and Data set `name` must be given as a parameter.
```ruby
describe azure_df_dataset(resource_group: resource_group, name: set_name) do
  it { should exist }
  its('name') { should eq set_name }
  its('type') { should eq 'Microsoft.Dataset/factories' }
end
```

## Parameters

| Name                           | Description                                                                      |
|--------------------------------|----------------------------------------------------------------------------------|
| resource_group                 | Azure resource group that the targeted resource resides in. `MyResourceGroup`    |
| name                           | Name of the Azure resource to test. `MyDsName`                                       |
| type                           | Type of Data set                                                             |
| provisioning_state             | State of Data set creation                                                   |

Both the parameter sets needs be provided for a valid query:
- `resource_group` and `name`



## Examples

### exists
```ruby
# If a Data set is found it will exist
describe azure_df_dataset(resource_group: resource_group, name: 'ShouldExist') do
  it { should exist }
end

describe azure_df_dataset(resource_group: resource_group, name: 'DoesNotExist') do
  it { should_not exist }
end
```

## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be setup with a `contributor` role on the subscription you wish to test.