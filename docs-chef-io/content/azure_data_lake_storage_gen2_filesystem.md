+++
title = "azure_data_lake_storage_gen2_filesystem resource"
platform = "azure"
draft = false
gh_repo = "inspec-azure"

[menu.azure]
title = "azure_data_lake_storage_gen2_filesystem"
identifier = "inspec/resources/azure/azure_data_lake_storage_gen2_filesystem resource"
parent = "inspec/resources/azure"
+++

Use the `azure_data_lake_storage_gen2_filesystem` InSpec audit resource to test the properties related to Azure Data Lake Storage Gen2 Filesystem.

## Azure REST API version, endpoint, and HTTP client parameters

{{< readfile file="content/reusable/md/inspec_azure_common_parameters.md" >}}

## Syntax

`name` and `account_name` are required parameters, and `dns_suffix` is an optional parameter.

```ruby
describe azure_data_lake_storage_gen2_filesystem(account_name: 'ACCOUNT_NAME', name: 'FILE_SYSTEM') do
  it  { should exist }
end
```

```ruby
describe azure_data_lake_storage_gen2_filesystem(account_name: 'ACCOUNT_NAME', name: 'FILE_SYSTEM')  do
  it  { should exist }
end
```

## Parameters

`name` _(required)_

: Name of the Azure Data Lake Storage Gen2 to test.

`account_name` _(required)_

: Azure storage account name.

`dns_suffix` _(optional)_

: The DNS suffix for the Azure Data Lake Storage endpoint.

## Properties

`last_modified`
: Last modified timestamp of the resource.

`etag`
: HTTP strong entity tag value.

`x_ms_properties`
: Properties of the filesystem.

`x_ms_namespace_enabled`
: Boolean string for namespace enablement.

`x_ms_default_encryption_scope`
: Default encryption scope.

`x_ms_deny_encryption_scope_override`
: Boolean string for deny encryption scope.

`x_ms_request_id`
: Request ID.

`x_ms_version`
: Version of the API.

`date`
: Date string of the request.

For properties applicable to all resources, such as `type`, `name`, `id`, and `properties`, refer to [`azure_generic_resource`]({{< relref "azure_generic_resource.md#properties" >}}).

Also, see the [Azure documentation](https://docs.microsoft.com/en-us/rest/api/storageservices/datalakestoragegen2/filesystem/get-properties) for other available properties.

## Examples

### Test that the Data Lake Storage Gen2 filesystem has namespace enabled

```ruby
describe azure_data_lake_storage_gen2_filesystem(account_name: 'ACCOUNT_NAME', name: 'FILE_SYSTEM')  do
  its('x_ms_namespace_enabled') { should eq 'false' }
end
```

## Matchers

{{< readfile file="content/reusable/md/inspec_matchers_link.md" >}}

### exists

```ruby
# If the Data Lake Storage Gen2 Filesystem is found, it exists.

describe azure_data_lake_storage_gen2_filesystem(account_name: 'ACCOUNT_NAME', name: 'FILE_SYSTEM')  do
  it { should exist }
end
```

### not_exists

```ruby
# Ff the Data Lake Storage Gen2 Filesystem is not found, it exists.

describe azure_data_lake_storage_gen2_filesystem(account_name: 'ACCOUNT_NAME', name: 'FILE_SYSTEM')  do
  it { should_not exist }
end
```

## Azure permissions

Your [service principal](https://learn.microsoft.com/en-us/entra/identity-platform/howto-create-service-principal-portal) must have the `contributor` role on the subscription and `Storage Blob Data Contributor` role on the **ADLS Gen2 Storage Account** you wish to test.
