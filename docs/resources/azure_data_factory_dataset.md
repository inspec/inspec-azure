---
title: About the azure_data_factory_dataset Resource
platform: azure
---

# azure_data_factory_dataset

Use the `azure_data_factory_dataset` InSpec audit resource to test properties related to an Azure Data Factory dataset.

See the [`Azure Data Factories Dataset documentation`](https://docs.microsoft.com/en-us/rest/api/datafactory/datasets/get) for additional information.

## Azure REST API Version, Endpoint, and HTTP Client Parameters

This resource interacts with API versions supported by the resource provider.
The `api_version` can be defined as a resource parameter.
If not provided, the latest version will be used.
For more information, refer to [`azure_generic_resource`](azure_generic_resource.md).

Unless defined, `azure_cloud` global endpoint, and default values for the HTTP client will be used.
For more information, refer to the resource pack [README](../../README.md).

## Availability

### Installation

This resource is available in the [InSpec Azure resource pack](https://github.com/inspec/inspec-azure).
For an example `inspec.yml` file and how to set up your Azure credentials, refer to resource pack [README](../../README.md#Service-Principal).

## Syntax

`resource_group`, `factory_name`, and `dataset_name` are required parameters.

```ruby
describe azure_data_factory_dataset(resource_group: 'RESOURCE_GROUP', factory_name: 'FACTORY_NAME', dataset_name: 'DATASET_NAME') do
  it { should exist }
end
```

## Parameters

| Name                           | Description                                                                      |
|--------------------------------|----------------------------------------------------------------------------------|
| resource_group                 | Azure resource group that the targeted resource resides in.                      |
| dataset_name                   | Name of the Azure resource to test.                                              |
| factory_name                   | The factory name.                                                                |

## Properties

| Name                           | Description                                                                      |
|--------------------------------|----------------------------------------------------------------------------------|
| name                           | Name of the Azure resource to test.                                              |
| id                             | The azure_sentinel_alert_rule type.                                              |
| properties                     | The properties of the resource.                                                  |
| type                           | Azure resource type.                                                             |
| description                    | The description of dataset type.                                                 |
| properties.linkedServiceName.referenceName | Reference LinkedService name.                                             |
| properties.linkedServiceName.type          | Linked service reference type.                                           |
| properties.type                | The dataset type.`AmazonMWSObjectDataset`, `AvroDataset`                         |

## Examples

### Test if Properties Match

```ruby
describe azure_data_factory_dataset(resource_group: 'RESOURCE_GROUP', factory_name: 'FACTORY_NAME', dataset_name: 'DATASET_NAME') do
  it { should exist }
  its('name') { should eq 'DATASET_NAME'}
  its('type') { should eq 'Microsoft.DataFactory/factories/datasets' }
  its('properties.description') { should eq 'Description of dataset.' }
  its('properties.linkedServiceName.referenceName') { should eq 'LINKED_SERVICE_NAME' }
  its('properties.linkedServiceName.type') { should eq 'LinkedServiceReference' }
end
```

## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](https://docs.chef.io/inspec/matchers/).

### exists

```ruby
# If a dataset should exist
describe azure_data_factory_dataset(resource_group: 'RESOURCE_GROUP', factory_name: 'FACTORY_NAME', dataset_name: 'DATASET_NAME') do
  it { should exist }
end

# If a dataset should not exist
describe azure_data_factory_dataset(resource_group: 'RESOURCE_GROUP', factory_name: 'FACTORY_NAME', dataset_name: 'DATASET_NAME') do
  it { should_not exist }
end
```

## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be setup with a `contributor` role on the subscription you wish to test.
