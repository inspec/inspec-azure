---
title: About the azure_data_factory_pipelines Resource
platform: azure
 ---

# azure_data_factory_pipelines

Use the `azure_data_factory_pipelines` InSpec audit resource to test properties related to pipeline for a resource group or the entire subscription.

## Azure REST API version, endpoint, and HTTP client parameters

This resource interacts with api versions supported by the resource provider.
The `api_version` can be defined as a resource parameter.
If not provided, the latest version will be used.
For more information, refer to [`azure_generic_resource`](azure_generic_resource.md).

Unless defined, `azure_cloud` global endpoint, and default values for the HTTP client will be used.
For more information, refer to the resource pack [README](../../README.md).
For api related info : [`Azure pipeline Docs`](https://docs.microsoft.com/en-us/rest/api/datafactory/pipelines/list-by-factory).
## Availability

### Installation

This resource is available in the [InSpec Azure resource pack](https://github.com/inspec/inspec-azure).
For an example `inspec.yml` file and how to set up your Azure credentials, refer to resource pack [README](../../README.md#Service-Principal).

## Syntax

An `azure_data_factory_pipelines` resource block returns all Azure pipeline, either within a Resource Group (if provided), or within an entire Subscription.

 ```ruby
 describe azure_data_factory_pipelines(resource_group: 'example', factory_name: 'fn') do
   #...
 end
 ```
`resource_group` and `factory_name` must be given as parameters.


## Parameters

| Name                           | Description                                                                       |
 |--------------------------------|-----------------------------------------------------------------------------------|
| resource_group                 | Azure resource group that the targeted resource resides in. `MyResourceGroup`     |
| factory_name | Azure Factory Name for which pipeline are being retrived.|

## Properties

| Property        | Description                                            | Filter Criteria<superscript>*</superscript> |
 |-----------------|---------------------------------------------------------|-----------------|
| names           | A list of the unique resource names.                    | `name`          |
| ids             | A list of pipeline IDs .                                | `id`            |
| properties      | A list of properties for the resource                   | `properties`          |

<superscript>*</superscript> For information on how to use filter criteria on plural resources refer to [FilterTable usage](https://github.com/inspec/inspec/blob/master/dev-docs/filtertable-usage.md).

## Examples

### Test if any pipeline exist in the resource group

 ```ruby
 describe azure_data_factory_pipelines(resource_group: 'example', factory_name: 'fn') do
   it { should exist }
   its('names') { should include 'pipeline_name' }
 end
 ```
### Test that there aren't any pipeline in a resource group

 ```ruby
 # Should not exist if no pipeline are in the resource group
 describe azure_data_factory_pipelines(resource_group: 'example', factory_name: 'fake') do
   it { should_not exist }
 end
 ```
## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be setup with a `contributor` role on the subscription you wish to test.