+++
title = "azure_sql_managed_instance resource"

draft = false


[menu.azure]
title = "azure_sql_managed_instance"
identifier = "inspec/resources/azure/azure_sql_managed_instance resource"
parent = "inspec/resources/azure"
+++

Use the `azure_sql_managed_instance` InSpec audit resource to test the properties related to an Azure SQL managed instance.

## Azure REST API version, endpoint, and HTTP client parameters

{{< readfile file="content/reusable/md/inspec_azure_common_parameters.md" >}}

## Syntax

`name` and`resource_group` are required parameters.

```ruby
describe azure_sql_managed_instance(resource_group: 'RESOURCE_GROUP', name: 'INSTANCE_NAME') do
  it                                      { should exist }
  its('type')                             { should eq 'Microsoft.Sql/managedInstances' }
  its('location')                         { should eq 'eastus' }
end
```

```ruby
describe azure_sql_managed_instance(resource_group: 'RESOURCE_GROUP', name: 'INSTANCE_NAME') do
  it  { should exist }
end
```

## Parameters

`name`
: Name of the Azure SQL managed instances to test.

`resource_group`
: Azure resource group where the targeted resource resides.

The parameter set that should be provided for a valid query is `resource_group` and `name`.

## Properties

`id`
: Resource ID.

`name`
: Resource name.

`type`
: Resource type.

`location`
: Resource location.

`properties`
: The properties of the SQL-Managed Instance.

`properties.minimalTlsVersion`
: Minimal TLS version. Allowed values are `None`, `1.0`, `1.1`, and `1.2`.

`properties.maintenanceConfigurationId`
: Specifies maintenance configuration ID to apply to this managed instance.

`properties.provisioningState`
: Provisioning state of the SQL-managed instance.

`sku.name`
: The name of the SKU, typically a letter with a number code. For example, `P3`.

For properties applicable to all resources, such as `type`, `name`, `id`, and `properties` refer to [`azure_generic_resource`](azure_generic_resource#properties). Also, see the [Azure documentation](https://docs.microsoft.com/en-us/rest/api/sql/2021-02-01-preview/managed-instances/get) for other available properties.

## Examples

Test that the SQL managed instances are provisioned successfully:

```ruby
describe azure_sql_managed_instance(resource_group: 'RESOURCE_GROUP', name: 'INSTANCE_NAME') do
  its('properties.provisioningState') { should eq 'Succeeded' }
end
```

## Matchers

{{< readfile file="content/reusable/md/inspec_matchers_link.md" >}}

### exists

```ruby
# If a SQL-managed instance is found, it will exist.

describe azure_sql_managed_instance(resource_group: 'RESOURCE_GROUP', name: 'INSTANCE_NAME') do
  it { should exist }
end
```

### not_exists

```ruby
# if SQL managed instance is not found, it will not exist.

describe azure_sql_managed_instance(resource_group: 'RESOURCE_GROUP', name: 'INSTANCE_NAME') do
  it { should_not exist }
end
```

## Azure permissions

{{% inspec-azure/azure_permissions_service_principal role="reader" %}}
