---
title: About the azure_synapse_notebooks Resource
platform: azure
---

# azure_synapse_notebooks

Use the `azure_synapse_notebooks` InSpec audit resource to test properties related to all Azure Synapse Notebooks in a Synapse Analytics Workspace.

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

An `azure_synapse_notebooks` resource block returns all Azure Synapse Notebooks within a Synapse workspace.
```ruby
describe azure_synapse_notebooks(endpoint: 'https://analytics.dev.azuresynapse.net') do
  #...
end
```

## Parameters

The parameter should be provided for valid query
- `endpoint`

| Name                            | Description                                                                      |
|---------------------------------|----------------------------------------------------------------------------------|
| endpoint                        | The Azure Synapse workspace development endpoint.                                |

## Properties

|Property            | Description                                        | Filter Criteria<superscript>*</superscript> |
|--------------------|----------------------------------------------------|-----------------|
| ids                | A list of the unique Fully qualified resource Ids. | `id`            |
| names              | A list of name for all the Synapse Notebooks.      | `name`          |
| types              | A list of types for all the resources.             | `type`          |
| properties         | A list of Properties all the Notebooks.            | `properties`    |
| etags              | A list of resource Etags.                          | `tags`          |


<superscript>*</superscript> For information on how to use filter criteria on plural resources refer to [FilterTable usage](https://github.com/inspec/inspec/blob/master/dev-docs/filtertable-usage.md).

## Examples

### Loop through Synapse Notebooks by Their Names
```ruby
azure_synapse_notebooks(endpoint: 'https://analytics.dev.azuresynapse.net').names.each do |name|
  describe azure_synapse_notebook(endpoint: 'https://analytics.dev.azuresynapse.net', name: name) do
    it { should exist }
  end
end  
```     

### Test that There are Synapse Notebookss that includes a certain string in their names (Client Side Filtering)
```ruby
describe azure_synapse_notebooks(endpoint: 'https://analytics.dev.azuresynapse.net').where { name.include?('analytics-trends') } do
  it { should exist }
end
```    

## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](https://www.inspec.io/docs/reference/matchers/).

### exists
```ruby
# Should not exist if no Synapse Notebooks are in the resource group
describe azure_synapse_notebooks(endpoint: 'https://analytics.dev.azuresynapse.net') do
  it { should_not exist }
end
# Should exist if the filter returns at least one Synapse Notebooks
describe azure_synapse_notebooks(endpoint: 'https://analytics.dev.azuresynapse.net') do
  it { should exist }
end
```
## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be setup with a `contributor` role on the subscription you wish to test.