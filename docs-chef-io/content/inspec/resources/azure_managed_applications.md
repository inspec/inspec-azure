+++
title = "azure_managed_applications Resource"
platform = "azure"
draft = false
gh_repo = "inspec-azure"

[menu.inspec]
title = "azure_managed_applications"
identifier = "inspec/resources/azure/azure_managed_applications Resource"
parent = "inspec/resources/azure"
+++

Use the `azure_managed_applications` InSpec audit resource to test properties related to all Azure managed applications.

## Azure REST API Version, Endpoint, and HTTP Client Parameters

{{% inspec_azure_common_parameters %}}

## Installation

{{% inspec_azure_install %}}

## Syntax

An `azure_managed_applications` resource block returns all Azure managed applications.

```ruby
describe azure_managed_applications do
  #...
end
```

## Parameters

`resource_group`  _(optional)_
: Azure resource group that the targeted resource resides in.

## Properties

`ids`
: A list of resource IDs.

: **Field**: `id`

`names`
: A list of resource Names.

: **Field**: `name`

`types`
: A list of the resource types.

: **Field**: `type`

`properties`
: A list of Properties for all the managed applications.

: **Field**: `properties`

`locations`
: A list of the resource locations.

: **Field**: `location`

`identities`
: A list of the identity of the resources.

: **Field**: `identity`

`plans`
: A list of the plan informations.

: **Field**: `plan`

`provisioningStates`
: A list of provisioning states of the app.

: **Field**: `provisioningState`

`publisherTenantIds`
: A list of the publisher tenant Id.

: **Field**: `publisherTenantId`

{{% inspec_filter_table %}}

## Examples

**Loop through managed applications by their names.**

```ruby
azure_managed_applications(resource_group: 'RESOURCE_GROUP').names.each do |name|
  describe azure_managed_application(resource_group: 'RESOURCE_GROUP', name: name) do
    it { should exist }
  end
end
```

**Test that there are managed applications that are successfully provisioned.**

```ruby
describe azure_managed_applications(resource_group: 'RESOURCE_GROUP').where(provisioningState: 'Succeeded') do
  it { should exist }
end
```

## Matchers

{{% inspec_matchers_link %}}

### exists

```ruby
# Should not exist if no managed applications are present

describe azure_managed_applications(resource_group: 'RESOURCE_GROUP') do
  it { should_not exist }
end
# Should exist if the filter returns at least one managed applications

describe azure_managed_applications(resource_group: 'RESOURCE_GROUP') do
  it { should exist }
end
```

## Azure Permissions

{{% azure_permissions_service_principal role="reader" %}}
