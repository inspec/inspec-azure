+++
title = "azure_synapse_workspaces Resource"
platform = "azure"
draft = false
gh_repo = "inspec-azure"

[menu.inspec]
title = "azure_synapse_workspaces"
identifier = "inspec/resources/azure/azure_synapse_workspaces Resource"
parent = "inspec/resources/azure"
+++

Use the `azure_synapse_workspaces` InSpec audit resource to test the properties related to all Azure Synapse workspaces.

## Azure REST API Version, Endpoint, and HTTP Client Parameters

{{% inspec_azure_common_parameters %}}

## Installation

{{% inspec_azure_install %}}

## Syntax

An `azure_synapse_workspaces` resource block returns all Azure Synapse workspaces.

```ruby
describe azure_synapse_workspaces do
  #...
end
```

## Parameters

`resource_group` _(optional)_
: Azure resource group where the targeted resource resides.

## Properties

`ids`
: A list of resource IDs.

: **Field**: `id`

`names`
: A list of resource names.

: **Field**: `name`

`types`
: A list of the resource types.

: **Field**: `type`

`properties`
: A list of properties for all the Synapse workspaces.

: **Field**: `properties`

`locations`
: A list of the Geo-locations.

: **Field**: `location`

`provisioningStates`
: A list of provisioning states of the Synapse workspaces.

: **Field**: `provisioningState`

{{% inspec_filter_table %}}

## Examples

### Loop through Synapse workspaces by their names

```ruby
azure_synapse_workspaces.names.each do |name|
  describe azure_synapse_workspace(resource_group: 'RESOURCE_GROUP', name: name) do
    it { should exist }
  end
end
```

### Test that there are Synapse workspaces that are successfully provisioned

```ruby
describe azure_synapse_workspaces(resource_group: 'RESOURCE_GROUP').where(provisioningState: 'Succeeded') do
  it { should exist }
end
```

## Matchers

{{% inspec_matchers_link %}}

### exists

```ruby
# Should not exist if no Synapse workspaces are present.

describe azure_synapse_workspaces(resource_group: 'RESOURCE_GROUP') do
  it { should_not exist }
end
```

### not_exists

```ruby
# Should exist if the filter returns at least one Synapse workspace.

describe azure_synapse_workspaces(resource_group: 'RESOURCE_GROUP') do
  it { should exist }
end
```

## Azure Permissions

{{% azure_permissions_service_principal role="reader" %}}
