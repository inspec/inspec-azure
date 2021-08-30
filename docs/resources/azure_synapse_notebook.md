---
title: About the azure_synapse_notebook Resource
platform: azure
---

# azure_synapse_notebook

Use the `azure_synapse_notebook` InSpec audit resource to test properties related to a Azure Synapse notebook in a Synapse workspace.

## Azure REST API Version, Endpoint, and HTTP Client Parameters

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

This resource requires the `endpoint` and `name` parameters for a valid query.

```ruby
describe azure_synapse_notebook(endpoint: 'WORKSPACE_DEVELOPMENT_ENDPOINT', name: 'NOTEBOOK_NAME') do
  it { should exist }
end
```

```ruby
describe azure_synapse_notebook(endpoint: 'WORKSPACE_DEVELOPMENT_ENDPOINT', name: 'NOTEBOOK_NAME') do
  it                                      { should exist }
  its('name')                             { should eq 'NOTEBOOK_NAME' }
  its('type')                             { should eq 'Microsoft.Synapse/workspaces/notebooks' }
  its('properties.sessionProperties.executorCores')          { should eq CORE_NUMBER }
end
```

## Parameters

| Name                            | Description                                                                      |
|---------------------------------|----------------------------------------------------------------------------------|
| endpoint                        | The Azure Synapse workspace development endpoint.                                |
| name                            | Name of the Azure Synapse Notebook to test.                                      |

This resource requires the `endpoint` and `name` parameters for a valid query.

## Properties

| Property                                  | Description                                          |
|-------------------------------------------|------------------------------------------------------|
| id                                        | Fully qualified resource ID for the resource.        |
| name                                      | The name of the resource.                            |
| type                                      | The type of the resource.                            |
| etag                                      | The resource Etag.                                   |
| properties                                | The properties of the notebook.                      |


For properties applicable to all resources, such as `type`, `name`, `id`, `properties`, refer to [`azure_generic_resource`](azure_generic_resource.md#properties).

Also, refer to [Azure documentation](https://docs.microsoft.com/en-us/rest/api/synapse/data-plane/notebook/get-notebook) for other available properties.

Access any property in the response by separating the key names with a period (`.`).

## Examples

### Test that there are four cores for each executor.

```ruby
describe azure_synapse_notebook(endpoint: 'WORKSPACE_DEVELOPMENT_ENDPOINT', name: 'NOTEBOOK_NAME') do
  its('properties.sessionProperties.executorCores') { should eq 4 }
end
```
### Test that the notebook uses the Python kernel.

```ruby
describe azure_synapse_notebook(endpoint: 'WORKSPACE_DEVELOPMENT_ENDPOINT', name: 'NOTEBOOK_NAME') do
  its('properties.metadata.language_info.name') { should 'Python' }
end
```
## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](/inspec/matchers/).

### exists

If a Synapse Notebook is found it will exist

```ruby
describe azure_synapse_notebook(endpoint: 'WORKSPACE_DEVELOPMENT_ENDPOINT', name: 'NOTEBOOK_NAME') do
  it { should exist }
end
```

Synapse Notebooks that aren't found will not exist

```ruby
describe azure_synapse_notebook(endpoint: 'WORKSPACE_DEVELOPMENT_ENDPOINT', name: 'NOTEBOOK_NAME') do
  it { should_not exist }
end
```

## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be setup with a `contributor` role on the subscription you wish to test.
