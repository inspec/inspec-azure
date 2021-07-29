---
title: About the azure_data_factories Resource
platform: azure
---

# azure_data_factories

Use the `azure_data_factories` InSpec audit resource to test properties related to data factories for a resource group or the entire subscription.

## Azure REST API version, endpoint, and HTTP client parameters

This resource interacts with api versions supported by the resource provider.
The `api_version` can be defined as a resource parameter.
If not provided, the latest version will be used.
For more information, refer to [`azure_generic_resource`](azure_generic_resource.md).

Unless defined, `azure_cloud` global endpoint, and default values for the HTTP client will be used.
For more information, refer to the resource pack [README](../../README.md).
For api related info : [`Azure Data Factories Docs`](https://docs.microsoft.com/en-us/rest/api/datafactory/factories/list).
## Availability

### Installation

This resource is available in the [InSpec Azure resource pack](https://github.com/inspec/inspec-azure).
For an example `inspec.yml` file and how to set up your Azure credentials, refer to resource pack [README](../../README.md#Service-Principal).

## Syntax

An `azure_data_factories` resource block returns all Azure data factories, either within a Resource Group (if provided), or within an entire Subscription.

```ruby
describe azure_data_factories do
  #...
end
```

or

```ruby
describe azure_data_factories(resource_group: 'my-rg') do
  #...
end
```

## Parameters

| Name                           | Description                                                                       |
|--------------------------------|-----------------------------------------------------------------------------------|
| resource_group                 | Azure resource group that the targeted resource resides in. `MyResourceGroup`     |

## Properties

| Property        | Description                                            | Filter Criteria<superscript>*</superscript> |
|-----------------|---------------------------------------------------------|-----------------|
| names           | A list of the unique resource names.                    | `name`          |
| ids             | A list of data factory IDs .                            | `id`            |
| tags            | A list of `tag:value` pairs for the resource.           | `tag`          |
| provisioning_states | The Data Factory provisioning state.                    | `provisioning_state`  |
| types           | The resource type.                         | `type` |
| repo_configuration_types| The Git or VSTS repository configuration types.           |  `repo type`|
| repo_configuration_project_names| The VSTS repository project names.    | `project_name`|
| repo_configuration_account_names| The Git or VSTS repository account names.                           | `account_name` |
| repo_configuration_repository_names| The Git or VSTS repository names.  | `repository_name` |
| repo_configuration_collaboration_branches| The Git or VSTS repository collaboration branches.  | `collaboration_branch` |
| repo_configuration_root_folders| The Git or VSTS repository root folders.                     | `root_folder` |
| repo_configuration_tenant_ids | The VSTS tenant IDs.     | `tenant_id` |

<superscript>*</superscript> For information on how to use filter criteria on plural resources refer to [FilterTable usage](https://github.com/inspec/inspec/blob/master/dev-docs/filtertable-usage.md).

## Examples

### Test if any Data Factories exist in the resource group

```ruby
describe azure_data_factories(resource_group: 'RESOURCE_GROUP') do
  it { should exist }
  its('names') { should include "factory_name" }
end
```
### Test that there aren't any Data Factories in a resource group

```ruby
# Should not exist if no Data Factory are in the resource group
describe azure_data_factories(resource_group: 'RESOURCE_GROUP') do
  it { should_not exist }
end
```

### Filter Data Factories in a resource group by properties

```ruby
describe azure_data_factories(resource_group: 'RESOURCE_GROUP') do
  its('repo_configuration_type') { should include CONFIGURATION_TYPE }
  its('repo_configuration_project_name') { should include PROJECT_NAME }
  its('repo_configuration_account_name') { should include ACCOUNT_NAME }
  its('repo_configuration_repository_name') { should include REPOSITORY_NAME }
  its('repo_configuration_collaboration_branch') { should include COLLABORATION_BRANCH }
  its('repo_configuration_root_folder') { should include ROOT_FOLDER }
end
```
## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be setup with a `contributor` role on the subscription you wish to test.
