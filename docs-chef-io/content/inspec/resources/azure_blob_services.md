+++
title = "azure_blob_services Resource"
platform = "azure"
draft = false
gh_repo = "inspec-azure"

[menu.inspec]
title = "azure_blob_services"
identifier = "inspec/resources/azure/azure_blob_services Resource"
parent = "inspec/resources/azure"
+++

Use the `azure_blob_services` InSpec audit resource to test the properties and configuration of multiple Azure Blob Service.

## Azure REST API Version, Endpoint, and HTTP Client Parameters

{{% inspec_azure_common_parameters %}}

## Installation

{{% inspec_azure_install %}}

## Syntax

An `azure_blob_services` resource block returns all Azure Blob Service, either within a Resource Group (if provided) or within an entire Subscription.

```ruby
describe azure_blob_services(resource_group: 'RESOURCE_GROUP_NAME', storage_account_name: 'STORAGE_ACCOUNT_NAME') do
  it { should exist }
end
```

## Parameters

`resource_group`
: Azure resource group where the targeted resource resides.

`storage_account_name`
: Name of the Storage account to test.

## Properties

`ids`
: Fully qualified resource ID for the resource. Ex - /subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{resourceProviderNamespace}/{resourceType}/{resourceName}

: **Field**: `id`

`names`
: The name of the resource

: **Field**: `name`

`properties`
: The property of the resource.

: **Field**: `properties`

`skus`
: Sku name and tier.

: **Field**: `sku`

`types`
: The type of the resource. E.g. "Microsoft.Compute/virtualMachines" or "Microsoft.Storage/storageAccounts"

: **Field**: `type`

{{% inspec_filter_table %}}

## Examples

### Test that an example Resource Group has the named storage account

```ruby
describe azure_blob_services(resource_group: 'RESOURCE_GROUP_NAME', storage_account_name: 'STORAGE_ACCOUNT_NAME') do
  its('names') { should include('STORAGE_ACCOUNT_NAME') }
end
```

See [integration tests](../../test/integration/verify/controls/azure_blob_services.rb) for more examples.

## Matchers

{{% inspec_matchers_link %}}

### exist

The control passes if the filter returns at least one result. Use `should_not` if you expect zero matches.

```ruby
describe azure_blob_services(resource_group: 'RESOURCE_GROUP_NAME', storage_account_name: 'STORAGE_ACCOUNT_NAME') do
  it { should exist }
end
```

```ruby
describe azure_blob_services(resource_group: 'RESOURCE_GROUP_NAME', storage_account_name: 'STORAGE_ACCOUNT_NAME') do
  it { should_not exist }
end
```

## Azure Permissions

{{% azure_permissions_service_principal role="contributor" %}}
