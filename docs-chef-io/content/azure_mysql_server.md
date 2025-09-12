+++
title = "azure_mysql_server resource"
platform = "azure"
draft = false
gh_repo = "inspec-azure"

[menu.azure]
title = "azure_mysql_server"
identifier = "inspec/resources/azure/azure_mysql_server resource"
parent = "inspec/resources/azure"
+++

Use the `azure_mysql_server` InSpec audit resource to test the properties and configuration of an Azure MySQL server.

## Azure REST API version, endpoint, and HTTP client parameters

{{< readfile file="content/reusable/md/inspec_azure_common_parameters.md" >}}

## Syntax

`resource_group` and `name`, or the `resource_id` are required parameters.

```ruby
describe azure_mysql_server(resource_group: 'RESOURCE_GROUP', name: 'SERVER_NAME') do
  it { should exist }
end
```

```ruby
describe azure_mysql_server(resource_id: '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.DBforMySQL/servers/{serverName}') do
  it { should exist }
end
```

## Parameters

`resource_group`
: Azure resource group where the targeted resource resides.

`name`
: Name of the MySql server to test.

`server_name`
: Name of the MySql server to test. This is for backward compatibility. Use `name` instead.

`resource_id`
: The unique resource ID.

`firewall_rules_api_version`
: The endpoint API version for the `firewall_rules` property. The latest version will be used unless provided.

Either one of the parameter sets can be provided for a valid query:

- `resource_id`
- `resource_group` and `name`
- `resource_group` and `server_name`

## Properties

`firewall_rules`
: A list of all firewall rules in the targeted server.

`sku`
: The SKU (pricing tier) of the server.

For properties applicable to all resources, such as `type`, `name`, `id`, and `properties`, refer to [`azure_generic_resource`](azure_generic_resource#properties).

Also, see the [Azure documentation](https://docs.microsoft.com/en-us/rest/api/mysql/singleserver/servers(2017-12-01)/get) for other available properties.

You can access any attribute in the response with the key names separated by dots (`.`).

## Examples

### Test if a MySQL server is referenced with a valid name

```ruby
describe azure_mysql_server(resource_group: 'RESOURCE_GROUP', name: 'SERVER_NAME') do
  it { should exist }
end
```

### Test if a MySQL server is referenced with an invalid name

```ruby
describe azure_mysql_server(resource_group: 'RESOURCE_GROUP', name: 'i-dont-exist') do
  it { should_not exist }
end
```

### Test if a MySQL server has firewall rules set

```ruby
describe azure_mysql_server(resource_group: 'RESOURCE_GROUP', name: 'SERVER_NAME') do
  its('firewall_rules') { should_not be_empty }
end
```

### Test a MySQL server's fully qualified domain name, location, and public network access status

```ruby
describe azure_mysql_server(resource_id: '/subscriptions/.../my-server') do
  its('properties.fullyQualifiedDomainName') { should eq 'my-server.mysql.database.azure.com' }
  its('properties.publicNetworkAccess') { should cmp 'Enabled' }
  its('location') { should cmp 'westeurope' }
end
```

## Matchers

{{< readfile file="content/reusable/md/inspec_matchers_link.md" >}}

### exists

```ruby
describe azure_mysql_server(resource_group: 'RESOURCE_GROUP', server_name: 'SERVER_NAME-1') do
  it { should exist }
end
```

## Azure permissions

{{% inspec-azure/azure_permissions_service_principal role="contributor" %}}
