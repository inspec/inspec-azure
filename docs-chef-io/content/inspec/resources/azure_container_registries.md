+++
title = "azure_container_registries Resource"
platform = "azure"
draft = false
gh_repo = "inspec-azure"

[menu.inspec]
title = "azure_container_registries"
identifier = "inspec/resources/azure/azure_container_registries Resource"
parent = "inspec/resources/azure"
+++

Use the `azure_container_registries` InSpec audit resource to test the properties and configuration of Azure Container Registries.

## Azure REST API Version, Endpoint, and HTTP Client Parameters

{{% inspec_azure_common_parameters %}}

## Installation

{{% inspec_azure_install %}}

## Syntax

An `azure_container_registries` resource block returns all Azure Container Registries, within a Resource Group (if provided) or an entire Subscription.

```ruby
describe azure_container_registries do
  #...
end
```

or

```ruby
describe azure_container_registries(resource_group: 'RESOURCE_GROUP') do
  #...
end
```

## Parameters

`resource_group` _(optional)_

: The name of the resource group.

## Properties

`ids`
: A list of the unique resource IDs.

: **Field**: `id`

`locations`
: A list of locations for all the resources being interrogated.

: **Field**: `location`

`names`
: A list of names of all the resources being interrogated.

: **Field**: `name`

`tags`
: A list of `tag:value` pairs defined on the resources being interrogated.

: **Field**: `tags`

`types`
: A list of the types of resources being interrogated.

: **Field**: `type`

`properties`
: A list of properties for all the resources being interrogated.

: **Field**: `properties`

{{% inspec_filter_table %}}

## Examples

### Check container registries are present

```ruby
describe azure_container_registries do
  it            { should exist }
  its('names')  { should include 'my-cr' }
end
```

### Filter the results to include only those with names match the given string value

```ruby
describe azure_container_registries.where{ name.eql?('production-cr-01') } do
  it { should exist }
end
```

## Matchers

{{% inspec_matchers_link %}}

### exists

The control passes if the filter returns at least one result.

```ruby
# If we expect 'EXAMPLEGROUP' resource group to have Container Registries.

describe azure_container_registries(resource_group: 'EXAMPLEGROUP') do
  it { should exist }
end
```

### not_exists

Use `should_not` if you expect zero matches.

```ruby
# If we expect 'EMPTYEXAMPLEGROUP' resource group to not have Container Registries.

describe azure_container_registries(resource_group: 'EMPTYEXAMPLEGROUP') do
  it { should_not exist }
end
```

## Azure Permissions

{{% azure_permissions_service_principal role="contributor" %}}
