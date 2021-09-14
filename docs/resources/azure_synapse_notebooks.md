---
title: About the azure_synapse_notebooks Resource
platform: azure
---

# azure_synapse_notebooks

Use the `azure_synapse_notebooks` InSpec audit resource to test properties related to all Azure Synapse notebooks in a Synapse Analytics workspace.

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

An `azure_synapse_notebooks` resource block returns all Azure Synapse notebooks within a Synapse workspace.

```ruby
describe azure_synapse_notebooks(endpoint: 'WORKSPACE_DEVELOPMENT_ENDPOINT') do
  #...
end
```

## Parameters

This resource requires the `endpoint` parameter for valid query.

| Name                            | Description                                                                      |
|---------------------------------|----------------------------------------------------------------------------------|
| endpoint                        | The Azure Synapse workspace development endpoint.                                |

## Properties

|Property            | Description                                        | Filter Criteria<superscript>*</superscript> |
|--------------------|----------------------------------------------------|-----------------|
| ids                | A list of the unique Fully qualified resource IDs. | `id`            |
| names              | A list of name for all the Synapse notebooks.      | `name`          |
| types              | A list of types for all the resources.             | `type`          |
| properties         | A list of Properties all the notebooks.            | `properties`    |
| etags              | A list of resource Etags.                          | `tags`          |


<superscript>*</superscript> For information on how to use filter criteria on plural resources refer to [FilterTable usage](https://github.com/inspec/inspec/blob/master/dev-docs/filtertable-usage.md).

## Examples

### Loop through Synapse Notebooks by their names.

```ruby
azure_synapse_notebooks(endpoint: 'WORKSPACE_DEVELOPMENT_ENDPOINT').names.each do |name|
  describe azure_synapse_notebook(endpoint: 'WORKSPACE_DEVELOPMENT_ENDPOINT', name: name) do
    it { should exist }
  end
end
```

### Test that there are Synapse Notebooks that include a certain string in their names (Client Side Filtering)

```ruby
describe azure_synapse_notebooks(endpoint: 'WORKSPACE_DEVELOPMENT_ENDPOINT').where { name.include?('analytics-trends') } do
  it { should exist }
end
```

## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](https://www.inspec.io/docs/reference/matchers/).

### exists

Should not exist if there aren't any Synapse notebooks in the resource group.

```ruby
describe azure_synapse_notebooks(endpoint: 'WORKSPACE_DEVELOPMENT_ENDPOINT') do
  it { should_not exist }
end
```

Should exist if the filter returns at least one Synapse notebook.

```ruby
describe azure_synapse_notebooks(endpoint: 'WORKSPACE_DEVELOPMENT_ENDPOINT') do
  it { should exist }
end
```
## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be setup with a `contributor` role on the subscription you wish to test.
