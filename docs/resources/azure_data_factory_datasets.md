---
title: About the azure_data_factory_datasets Resource
platform: azure
 ---

# azure_data_factory_datasets

Use the `azure_data_factory_datasets` InSpec audit resource to test properties related to dataset for a resource group or the entire subscription.

## Azure REST API version, endpoint, and HTTP client parameters

This resource interacts with api versions supported by the resource provider.
The `api_version` can be defined as a resource parameter.
If not provided, the latest version will be used.
For more information, refer to [`azure_generic_resource`](azure_generic_resource.md).

Unless defined, `azure_cloud` global endpoint, and default values for the HTTP client will be used.
For more information, refer to the resource pack [README](../../README.md).
For api related info : [`Azure dataset Docs`](https://docs.microsoft.com/en-us/rest/api/securityinsights/alert-rules/list).
## Availability

### Installation

This resource is available in the [InSpec Azure resource pack](https://github.com/inspec/inspec-azure).
For an example `inspec.yml` file and how to set up your Azure credentials, refer to resource pack [README](../../README.md#Service-Principal).

## Syntax

An `azure_data_factory_datasets` resource block returns all Azure dataset, either within a Resource Group (if provided), or within an entire Subscription.

`resource_group` and `factory_name` must be given as parameters.

```ruby
 describe azure_data_factory_datasets(resource_group: resource_group, factory_name: factory_name) do
   #...
 end
 ```



## Parameters

| Name                           | Description                                                                       |
|--------------------------------|-----------------------------------------------------------------------------------|
| resource_group                 | Azure resource group that the targeted resource resides in. `MyResourceGroup`     |
| factory_name                   | The Azure Data factory Name.|

## Properties

| Property        | Description                                            | Filter Criteria<superscript>*</superscript> |
|-----------------|---------------------------------------------------------|-----------------|
| names           | A list of the unique resource names.                    | `name`          |
| ids             | A list of dataset IDs .                              | `id`            |
| properties      | A list of properties for the resource.                   | `properties`          |
| types           | A list of types for each resource.                       | `type`          |
| descriptions    | A list of descriptions about dataset.                   | `description` |
| linkedServiceName_referenceNames| The List of linked services.            | `linkedServiceName_referenceName` |
| linkedServiceName_types | The list of linked services type.                | `linkedServiceName_type` |

<superscript>*</superscript> For information on how to use filter criteria on plural resources refer to [FilterTable usage](https://github.com/inspec/inspec/blob/master/dev-docs/filtertable-usage.md).

## Examples

### Test if properties matches

  ```ruby
       describe azure_data_factory_datasetsazure_data_factory_datasets(resource_group: resource_group, factory_name: factory_name) do
       its('names') { should include 'BuiltInFusion' }
       its('types') { should include 'Microsoft.SecurityInsights/alertRules' }
       its('kinds') { should include 'Fusion' }
       its('severities') { should include 'High' }
       its('enableds') { should include true }
       its('displayNames') { should include 'Advanced Multistage Attack Detection' }
       its('alertRuleTemplateNames') { should include 'f71aba3d-28fb-450b-b192-4e76a83015c8' }
       end
  ```

### Test if any dataset exist in the data factory

  ```ruby
     describe azure_data_factory_datasetsazure_data_factory_datasets(resource_group: resource_group, factory_name: factory_name) do
       it { should exist }
     end
  ```
### Test that there aren't any dataset in a data factory

  ```ruby
      # Should not exist if no dataset are in the data factory
      describe azure_data_factory_datasetsazure_data_factory_datasets(resource_group: resource_group, factory_name: factory_name) do
       it { should_not exist }
      end
  ```
## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be setup with a `contributor` role on the subscription you wish to test.