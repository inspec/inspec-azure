---
title: About the azure_data_factory_dataset Resource
platform: azure
---

# azure_data_factory_dataset

Use the `azure_data_factory_dataset` InSpec audit resource to test properties related to a data factory data set.

## Azure REST API version, endpoint and http client parameters

This resource interacts with api versions supported by the resource provider.
The `api_version` can be defined as a resource parameter.
If not provided, the latest version will be used.
For more information, refer to [`azure_generic_resource`](azure_generic_resource.md).

Unless defined, `azure_cloud` global endpoint, and default values for the http client will be used.
For more information, refer to the resource pack [README](../../README.md).
For api related info : [`Azure Data Factories Dataset Docs`](https://docs.microsoft.com/en-us/rest/api/datafactory/datasets/get).


## Availability

### Installation

This resource is available in the [InSpec Azure resource pack](https://github.com/inspec/inspec-azure).
For an example `inspec.yml` file and how to set up your Azure credentials, refer to resource pack [README](../../README.md#Service-Principal).

## Syntax

`resource_group`, `factory_name` and `dataset_name` must be given as a parameter.

```ruby
describe azure_data_factory_dataset(resource_group: resource_group, factory_name: factory_name, dataset_name: dataset_name) do
  it { should exist }
end
```

## Parameters

| Name                           | Description                                                                      |
|--------------------------------|----------------------------------------------------------------------------------|
| resource_group                 | Azure resource group that the targeted resource resides in. `MyResourceGroup`    |
| dataset_name                   | Name of the Azure resource to test.                                      |
| factory_name                   | The factory name.                                                            |

## Properties

| Name                           | Description                                                                      |
|--------------------------------|----------------------------------------------------------------------------------|
| name                           | Name of the Azure resource to test.                                       |
| id                             | The azure_sentinel_alert_rule type.                                                 |
| properties                     | The Properties of the Resource.                                | 
| type                           | Azure resource type. |
| description                    | The description of dataset type. |
| properties.linkedServiceName.referenceName | The Linked service used.  |
| properties.linkedServiceName.type          | The Linked service type.  |
| properties.type                | The dataset type.`AmazonMWSObjectDataset`, `AvroDataset`  |

## Examples

### exists
```ruby
# If a Data set is found it will exist
describe azure_data_factory_dataset(resource_group: resource_group, factory_name: factory_name, dataset_name: dataset_name) do
  it { should exist }
end

describe azure_data_factory_dataset(resource_group: resource_group, factory_name: factory_name, dataset_name: 'fake') do
  it { should_not exist }
end
```
### Test if properties matches

```ruby
describe azure_data_factory_dataset(resource_group: resource_group, factory_name: factory_name, dataset_name: dataset_name) do
  it { should exist }
  its('name') { should eq 'BinaryDatasetForDeleteActivity' }
  its('type') { should eq 'Microsoft.DataFactory/factories/datasets' }
  its('properties.description') { should eq 'Connect to your source store to delete files.' }
  its('properties.linkedServiceName.referenceName') { should eq 'linkedService1' }
  its('properties.linkedServiceName.type') { should eq 'LinkedServiceReference' }
end
```
## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be setup with a `contributor` role on the subscription you wish to test.