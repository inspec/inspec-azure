+++
title = "azure_mariadb_servers Resource"
platform = "azure"
draft = false
gh_repo = "inspec-azure"

[menu.inspec]
title = "azure_mariadb_servers"
identifier = "inspec/resources/azure/azure_mariadb_servers Resource"
parent = "inspec/resources/azure"
+++

Use the `azure_mariadb_servers` InSpec audit resource to test the properties and configuration of multiple Azure MariaDB Servers.

## Azure REST API Version, Endpoint, and HTTP Client Parameters

{{% inspec_azure_common_parameters %}}

## Installation

{{% inspec_azure_install %}}

## Syntax

An `azure_mariadb_servers` resource block returns all Azure MariaDB Servers within a resource group (if provided) or the entire subscription.

```ruby
describe azure_mariadb_servers do
  #...
end
```

Or

```ruby
describe azure_mariadb_servers(resource_group: 'RESOURCE_GROUP') do
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
: A list of `tag:value` pairs defined on the resources.

: **Field**: `tags`

`skus`
: A list of the SKUs (pricing tiers) of the servers.

: **Field**: `sku`

`types`
: A list of the types of resources being interrogated.

: **Field**: `type`

`properties`
: A list of properties for all the resources being interrogated.

: **Field**: `properties`

{{% inspec_filter_table %}}

## Examples

**Check MariaDB Servers are present.**

```ruby
describe azure_mariadb_servers do
  it            { should exist }
  its('names')  { should include 'MY-SERVER-NAME' }
end
```

### Filters the results to include only those servers that have the specified name (Client Side Filtering)

```ruby
describe azure_mariadb_servers.where{ name.include?('production') } do
  it { should exist }
end
```

### Filters the results to include only those servers which reside in a specified location (Client Side Filtering)

```ruby
describe azure_mariadb_servers.where{ location.eql?('westeurope') } do
  it { should exist }
end
```

### Filters the results to include only those servers which reside in a specified location and has the specified name (Server Side Filtering - Recommended)

```ruby
describe azure_generic_resources(resource_provider: 'Microsoft.DBforMariaDB/servers', substring_of_name: 'production', location: 'westeurope') do
  it {should exist}
end
```

## Matchers

{{% inspec_matchers_link %}}

### exists

The control passes if the filter returns at least one result. Use `should_not` if you expect zero matches.

```ruby
describe azure_mariadb_servers do
  it { should exist }
end
```

## Azure Permissions

{{% azure_permissions_service_principal role="contributor" %}}
