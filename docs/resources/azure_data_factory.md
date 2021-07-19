---
title: About the azure_data_factory Resource
platform: azure
---

# azure_data_factory

Use the `azure_data_factory` InSpec audit resource to test properties related to a data factory.

## Azure REST API version, endpoint and http client parameters

This resource interacts with api versions supported by the resource provider.
The `api_version` can be defined as a resource parameter.
If not provided, the latest version will be used.
For more information, refer to [`azure_generic_resource`](azure_generic_resource.md).

Unless defined, `azure_cloud` global endpoint, and default values for the http client will be used.
For more information, refer to the resource pack [README](../../README.md).
For api related info : [`Azure Data Factories Docs`](https://docs.microsoft.com/en-us/azure/data-factory/quickstart-create-data-factory-rest-api#create-a-data-factory).


## Availability

### Installation

This resource is available in the [InSpec Azure resource pack](https://github.com/inspec/inspec-azure). 
For an example `inspec.yml` file and how to set up your Azure credentials, refer to resource pack [README](../../README.md#Service-Principal).

## Syntax

`resource_group` and Data Factory `name` must be given as a parameter.
```ruby
describe azure_data_factory(resource_group: resource_group, name: factory_name) do
  it { should exist }
  its('name') { should eq factory_name }
  its('type') { should eq 'Microsoft.DataFactory/factories' }
end
```

## Parameters

| Name                           | Description                                                                      |
|--------------------------------|----------------------------------------------------------------------------------|
| resource_group                 | Azure resource group that the targeted resource resides in. `MyResourceGroup`    |
| name                           | Name of the Azure resource to test. `MyDf`                                       |
| type                           | Type of Data Factory                                                             |
| provisioning_state             | State of Data Factory creation                                                   |

Both the parameter sets needs be provided for a valid query:
- `resource_group` and `name`



## Examples

### exists
```ruby
# If a Data Factory is found it will exist
describe azure_data_factory(resource_group: resource_group, name: 'ShouldExist') do
  it { should exist }
end

describe azure_data_factory(resource_group: resource_group, name: 'DoesNotExist') do
  it { should_not exist }
end
```

## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be setup with a `contributor` role on the subscription you wish to test.
