+++
title = "azure_sql_virtual_machine resource"
platform = "azure"
draft = false
gh_repo = "inspec-azure"

[menu.azure]
title = "azure_sql_virtual_machine"
identifier = "inspec/resources/azure/azure_sql_virtual_machine resource"
parent = "inspec/resources/azure"
+++

Use the `azure_sql_virtual_machine` Chef InSpec audit resource to test the properties of an Azure SQL virtual machine.

## Azure REST API version, endpoint, and HTTP client parameters

{{< readfile file="content/reusable/md/inspec_azure_common_parameters.md" >}}

## Syntax

```ruby
describe azure_sql_virtual_machine(resource_group: 'RESOURCE_GROUP', name: 'SQL_VM_NAME') do
  it                                      { should exist }
  its('type')                             { should eq 'Microsoft.SqlVirtualMachine/sqlVirtualMachines' }
  its('location')                         { should eq 'eastus' }
end
```

```ruby
describe azure_sql_virtual_machine(resource_group: 'RESOURCE_GROUP', name: 'SQL_VM_NAME') do
  it  { should exist }
end
```

## Parameters

`name` _(required)_

: Name of the Azure SQL Virtual Machine to test.

`resource_group` _(required)_

: Azure resource group where the targeted resource resides.

## Properties

`id`
: The resource ID.

`name`
: The resource name.

`type`
: The resource type. `Microsoft.SqlVirtualMachine/sqlVirtualMachines`.

`location`
: The resource location.

`properties`
: The properties of the SQL virtual machine.

`properties.provisioningState`
: State of the resource.

For properties applicable to all resources, such as `type`, `name`, `id`, and `properties`, refer to [`azure_generic_resource`]({{< relref "azure_generic_resource.md#properties" >}}).

Also, see the [Azure documentation](https://docs.microsoft.com/en-us/rest/api/compute/virtual-machines/get) for other available properties.

## Examples

### Test that the SQL virtual machine is provisioned successfully

```ruby
describe azure_sql_virtual_machine(resource_group: 'RESOURCE_GROUP', name: 'SQL_VM_NAME') do
  its('properties.provisioningState') { should eq 'Succeeded' }
end
```

## Matchers

{{< readfile file="content/reusable/md/inspec_matchers_link.md" >}}

### exists

```ruby
# If a SQL Virtual Machine is found, it will exist.

describe azure_sql_virtual_machine(resource_group: 'RESOURCE_GROUP', name: 'SQL_VM_NAME') do
  it { should exist }
end
```

### not_exists

```ruby
# If SQL Virtual Machine is not found, it will not exist.

describe azure_sql_virtual_machine(resource_group: 'RESOURCE_GROUP', name: 'SQL_VM_NAME') do
  it { should_not exist }
end
```

## Azure permissions

{{% inspec-azure/azure_permissions_service_principal role="reader" %}}
