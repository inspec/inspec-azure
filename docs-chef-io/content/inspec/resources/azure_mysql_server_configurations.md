+++
title = "azure_mysql_database_configurations Resource"
platform = "azure"
draft = false
gh_repo = "inspec-azure"

[menu.inspec]
title = "azure_mysql_database_configurations"
identifier = "inspec/resources/azure/azure_mysql_database_configurations Resource"
parent = "inspec/resources/azure"
+++

Use the `azure_mysql_database_configurations` InSpec audit resource to test the properties of an Azure MySQL Database Configuration on a MySQL Database Server.

## Azure REST API Version, Endpoint, and HTTP Client Parameters

{{% inspec_azure_common_parameters %}}

## Installation

{{% inspec_azure_install %}}

## Syntax

The `resource_group` and `server_name` are required parameters.

```ruby
describe azure_mysql_database_configuration(resource_group: 'RESOURCE_GROUP', server_name: 'SERVER_NAME') do
  it { should exist }
end
```

## Parameters

`resource_group`
: Azure resource group where the targeted resource resides.

`server_name`
: The name of the server in which the database resides.

## Properties

`ids`
: A list of the unique resource IDs.

: **Field**: `id`

`names`
: A list of names of all the resources being interrogated.

: **Field**: `name`

`types`
: A list of the types of resources being interrogated.

: **Field**: `type`

`properties`
: A list of properties for all the resources being interrogated.

: **Field**: `properties`

{{% inspec_filter_table %}}

## Examples

### Check resources are present

```ruby
describe azure_mysql_database_configuration(resource_group: 'RESOURCE_GROUP', server_name: 'SERVER_NAME') do
    it            { should exist }
    its('names')  { should include 'my-db' }
end
```

### Filter the results to include only those with names match the specified string value

```ruby
describe azure_mysql_database_configuration(resource_group: 'RESOURCE_GROUP', server_name: 'SERVER_NAME').where{ name.eql?('user-override') } do
  it { should exist }
end
```

## Matchers

{{% inspec_matchers_link %}}

### exists

The control passes if the filter returns at least one result. Use `should_not` if you expect zero matches.

```ruby
# If we expect resources to exist.

describe azure_mysql_database_configuration(resource_group: 'RESOURCE_GROUP', server_name: 'SERVER_NAME') do
  it { should exist }
end
```

```ruby
# If we expect resources not to exist.

describe azure_mysql_database_configuration(resource_group: 'RESOURCE_GROUP', server_name: 'SERVER_NAME') do
  it { should_not exist }
end
```

## Azure Permissions

{{% azure_permissions_service_principal role="contributor" %}}
