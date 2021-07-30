---
title: About the azure_synapse_notebook Resource
platform: azure
---

# azure_synapse_notebook

Use the `azure_synapse_notebook` InSpec audit resource to test properties related to a Azure Synapse Notebook in a synapse workspace.

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

`endpoint` and `name` must be given as a parameter.
```ruby
describe azure_synapse_notebook(endpoint: 'https://analytics.dev.azuresynapse.net', name: 'my-analytics-notebook') do
  it                                      { should exist }
  its('name')                             { should eq 'my-analytics-notebook' }
  its('type')                             { should eq 'Microsoft.Synapse/workspaces/notebooks' }
  its('properties.sessionProperties.executorCores')          { should eq 4 }
  its('properties.metadata.a365ComputeOptions.sparkVersion') { should eq '2.4' }
end
```
```ruby
describe azure_synapse_notebook(endpoint: 'https://analytics.dev.azuresynapse.net', name: 'my-analytics-notebook') do
  it  { should exist }
end
```
## Parameters

| Name                            | Description                                                                      |
|---------------------------------|----------------------------------------------------------------------------------|
| endpoint                        | The Azure Synapse workspace development endpoint.                                |
| name                            | Name of the Azure Synapse Notebook to test.                                      |

The parameter set should be provided for a valid query:
- `endpoint` and `name`

## Properties

| Property                                  | Description                                          |
|-------------------------------------------|------------------------------------------------------|
| id                                        | Fully qualified resource Id for the resource.        |
| name                                      | Synapse Notebook Name.                               |
| type                                      | The type of the resource. `Microsoft.Synapse/workspaces/Notebooks`|
| etag                                      | Resource Etag.                                       |
| properties                                | Properties of Notebook.                              |
| properties.sessionProperties.executorCores| Number of cores to use for each executor.            |
| properties.metadata.language_info.name    | The programming language which this kernel runs..    |


For properties applicable to all resources, such as `type`, `name`, `id`, `properties`, refer to [`azure_generic_resource`](azure_generic_resource.md#properties).

Also, refer to [Azure documentation](https://docs.microsoft.com/en-us/rest/api/synapse/data-plane/notebook/get-notebook) for other properties available.
Any attribute in the response may be accessed with the key names separated by dots (`.`).

## Examples

### Test <>
```ruby
describe azure_synapse_notebook(endpoint: 'https://analytics.dev.azuresynapse.net', name: 'my-analytics-notebook') do
  its('properties.sessionProperties.executorCores') { should eq 4 }
end
```
### Test <>
```ruby
describe azure_synapse_notebook(endpoint: 'https://analytics.dev.azuresynapse.net', name: 'my-analytics-notebook') do
  its('properties.metadata.language_info.name') { should 'Python' }
end
```
## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](/inspec/matchers/).

### exists
```ruby
# If a Synapse Notebook is found it will exist
describe azure_synapse_notebook(endpoint: 'https://analytics.dev.azuresynapse.net', name: 'my-analytics-notebook') do
  it { should exist }
end
# Synapse Notebooks that aren't found will not exist
describe azure_synapse_notebook(endpoint: 'https://analytics.dev.azuresynapse.net', name: 'my-analytics-notebook') do
  it { should_not exist }
end
```

## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be setup with a `contributor` role on the subscription you wish to test.