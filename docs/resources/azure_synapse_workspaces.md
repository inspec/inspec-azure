---
title: About the azure_synapse_workspaces Resource
platform: azure
---

# azure_synapse_workspaces

Use the `azure_synapse_workspaces` InSpec audit resource to test properties related to all Azure Synapse Workspaces.

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

An `azure_synapse_workspaces` resource block returns all Azure Synapse Workspaces.

```ruby
describe azure_synapse_workspaces do
  #...
end
```

## Parameters
| Name           | Description                                                                      |
|----------------|----------------------------------------------------------------------------------|
| resource_group | Azure resource group that the targeted resource resides in. `MyResourceGroup` (Optional)   |

The parameter set optionally be provided for a valid query:
- `resource_group`

## Properties

|Property                        | Description                                                            | Filter Criteria<superscript>*</superscript> |
|--------------------------------|------------------------------------------------------------------------|------------------|
| ids                            | A list of resource IDs.                                                | `id`             |
| names                          | A list of resource Names.                                              | `name`           |
| types                          | A list of the resource types.                                          | `type`           |
| properties                     | A list of Properties for all the Synapse Workspaces.           | `properties`     |
| locations                      | A list of the Geo-locations.                                           | `location`       |
| provisioningStates             | A list of provisioning states of the Synapse Workspaces.       | `provisioningState`|

<superscript>*</superscript> For information on how to use filter criteria on plural resources refer to [FilterTable usage](https://github.com/inspec/inspec/blob/master/dev-docs/filtertable-usage.md).

## Examples

### Loop through Synapse Workspaces by their names.

```ruby
azure_synapse_workspaces.names.each do |name|
  describe azure_synapse_workspace(resource_group: 'RESOURCE_GROUP', name: name) do
    it { should exist }
  end
end
```
### Test that there are Synapse Workspaces that are successfully provisioned.

```ruby
describe azure_synapse_workspaces(resource_group: 'RESOURCE_GROUP').where(provisioningState: 'Succeeded') do
  it { should exist }
end
```

## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](https://www.inspec.io/docs/reference/matchers/).

### exists

```ruby
# Should not exist if no Synapse Workspaces are present
describe azure_synapse_workspaces(resource_group: 'RESOURCE_GROUP') do
  it { should_not exist }
end
# Should exist if the filter returns at least one Synapse Workspaces
describe azure_synapse_workspaces(resource_group: 'RESOURCE_GROUP') do
  it { should exist }
end
```
## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be setup with a `reader` role on the subscription you wish to test.