---
title: About the azure_data_factory_datasets Resource
platform: azure
---

# azure_data_factory_datasets

Use the `azure_data_factory_datasets` InSpec audit resource to test properties of multiple Azure Data Factory datasets for a resource group or the entire subscription.

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

An `azure_data_factory_datasets` resource block returns all Azure dataset, either within a Resource Group (if provided), or within an entire Subscription.

`resource_group` and `factory_name` must be given as parameters.

```ruby
describe azure_data_factory_datasets(resource_group: 'RESOURCE_GROUP', factory_name: 'FACTORY_NAME') do
  #...
end
```

## Parameters

| Name                           | Description                                                                       |
|--------------------------------|-----------------------------------------------------------------------------------|
| resource_group                 | Azure resource group that the targeted resource resides in.                       |
| factory_name                   | The Azure Data factory name.|

## Properties

| Property        | Description                                            | Filter Criteria<superscript>*</superscript> |
|-----------------|---------------------------------------------------------|-----------------|
| names           | A list of the unique resource names.                    | `name`          |
| ids             | A list of dataset IDs.                                  | `id`            |
| properties      | A list of properties for the resources.                 | `properties`          |
| types           | A list of types for each resource.                      | `type`          |
| descriptions    | A list of descriptions of the resources.                | `description` |
| linkedServiceName_referenceNames| The list of LinkedService names.            | `linkedServiceName_referenceName` |
| linkedServiceName_types | The list of LinkedService types.              | `linkedServiceName_type` |

<superscript>*</superscript> For information on how to use filter criteria on plural resources refer to [FilterTable usage](https://github.com/inspec/inspec/blob/master/dev-docs/filtertable-usage.md).

## Examples

### Test if Properties Match

```ruby
describe azure_data_factory_datasetsazure_data_factory_datasets(resource_group: 'RESOURCE_GROUP', factory_name: 'FACTORY_NAME') do
  its('names') { should include 'DATASET_NAME' }
  its('types') { should include 'Microsoft.SecurityInsights/alertRules' }
  its('enableds') { should include true }
end
```

## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](https://docs.chef.io/inspec/matchers/).

### Test if Any Dataset Exists in the Data Factory

```ruby
describe azure_data_factory_datasetsazure_data_factory_datasets(resource_group: 'RESOURCE_GROUP', factory_name: 'FACTORY_NAME') do
  it { should exist }
end
```

### Test That There Aren’t Any Datasets in a Data Factory

```ruby
# Should not exist if no dataset are in the data factory
describe azure_data_factory_datasetsazure_data_factory_datasets(resource_group: 'RESOURCE_GROUP', factory_name: 'FACTORY_NAME') do
  it { should_not exist }
end
```

## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be setup with a `contributor` role on the subscription you wish to test.
