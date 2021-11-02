---
title: About the azure_migrate_assessment_machines Resource
platform: azure
---

# azure_migrate_assessment_machines

Use the `azure_migrate_assessment_machines` InSpec audit resource to test properties related to all Azure Migrate assessment machines within a project.

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

An `azure_migrate_assessment_machines` resource block returns all Azure Migrate assessment machines within a project.

```ruby
describe azure_migrate_assessment_machines(resource_group: 'RESOURCE_GROUP', project_name: 'MIGRATE_ASSESSMENT_PROJECT_NAME') do
  #...
end
```

## Parameters

`resource_group` _(required)_

Azure resource group that the targeted resource resides in.

`project_name` _(required)_

The Azure Migrate Assessment Project.

## Properties

|Property                        | Description                                                            | Filter Criteria<superscript>*</superscript> |
|--------------------------------|------------------------------------------------------------------------|------------------|
| ids                            | Path reference to the assessment machines.                             | `id`             |
| names                          | Unique names for all assessment machines.                              | `name`           |
| types                          | Type of the objects.                                                   | `type`           |
| eTags                          | A list of eTags for all the assessment machines.                       | `eTag`           |
| properties                     | A list of properties for all the assessment machines.                  | `properties`     |
| bootTypes                      | A list of boot type of the machines.                                   | `bootType`       |
| createdTimestamps              | Times when this machine was created.                                   | `createdTimestamp`|
| datacenterManagementServerArmIds | A list of ARM IDs of the data center as tracked by the Microsoft.OffAzure.| `datacenterManagementServerArmId` |
| datacenterManagementServerNames| Name of the servers hosting the datacenter management solution.        | `datacenterManagementServerName`|
| descriptions                   | Descriptions of all the machines.                                      | `description`    |
| discoveryMachineArmIds         | A list of ARM IDs of the machine as tracked by the Microsoft.OffAzure. | `discoveryMachineArmId`|
| disks                          | Dictionary of disks attached to all the machines. Key is ID of disk. Value is a disk object. | `disks` |
| displayNames                   | User readable names of all the machines as defined by the user in their private datacenter.| `displayName` |
| groups                         | A List of references to the groups that the machine is member of.      | `groups`         |
| megabytesOfMemories            | A list of Memories in Megabytes.                                       | `megabytesOfMemory`|
| networkAdapters                | Dictionary of network adapters attached to all the machines. Key is ID of network adapter. Value is a network adapter object. | `networkAdapters` |
| numberOfCores                  | Processor counts.                                                      | `numberOfCores`  |
| operatingSystemTypes           | Operating system types of all the machines.                            | `operatingSystemType`|
| operatingSystemNames           | Operating system names of all the machines.                            | `operatingSystemName`|
| operatingSystemVersions        | Operating system versions of all the machines.                         | `operatingSystemVersion`|
| updatedTimestamps              | Time when the machines were last updated.                              | `updatedTimestamp` |

<superscript>*</superscript> For information on how to use filter criteria on plural resources refer to [FilterTable usage](https://github.com/inspec/inspec/blob/master/dev-docs/filtertable-usage.md).

## Examples

### Loop through Migrate assessment machines by their names.

```ruby
azure_migrate_assessment_machines(resource_group: 'RESOURCE_GROUP', project_name: 'MIGRATE_ASSESSMENT_PROJECT_NAME').names.each do |name|
  describe azure_migrate_assessment_machine(resource_group: 'RESOURCE_GROUP', project_name: 'MIGRATE_ASSESSMENT_PROJECT_NAME', group_name: 'MACHINE_GROUP_NAME', name: name) do
    it { should exist }
  end
end
```

### Test that there are Migrate assessment machines with BIOS boot type.

```ruby
describe azure_migrate_assessment_machines(resource_group: 'RESOURCE_GROUP', project_name: 'MIGRATE_ASSESSMENT_PROJECT_NAME').where(bootType: 'BIOS') do
  it { should exist }
end
```

## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](https://www.inspec.io/docs/reference/matchers/).

### exists

```ruby
# Should not exist if no Migrate assessment machines are present in the project and in the resource group
describe azure_migrate_assessment_machines(resource_group: 'RESOURCE_GROUP', project_name: 'MIGRATE_ASSESSMENT_PROJECT_NAME') do
  it { should_not exist }
end

# Should exist if the filter returns at least one Migrate assessment machines in the project and in the resource group
describe azure_migrate_assessment_machines(resource_group: 'RESOURCE_GROUP', project_name: 'MIGRATE_ASSESSMENT_PROJECT_NAME') do
  it { should exist }
end
```
## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be setup with a `contributor` role on the subscription you wish to test.
