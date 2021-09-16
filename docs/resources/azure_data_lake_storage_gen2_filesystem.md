---
title: About the azure_data_lake_storage_gen2_filesystem Resource
platform: azure
---

# azure_data_lake_storage_gen2_filesystem

Use the `azure_data_lake_storage_gen2_filesystem` InSpec audit resource to test the properties related to Azure Data Lake Storage Gen2 Filesystem.

## Azure REST API version, Endpoint, and HTTP Client Parameters

This resource interacts with API versions supported by the resource provider. The `api_version` is defined as a resource parameter.
If not provided, the latest version is used. For more information, refer to [`azure_generic_resource`](azure_generic_resource.md).

Unless defined, `azure_cloud` global endpoint and default values for the HTTP client are used. For more information, refer to the resource pack [README](../../README.md).

## Availability

### Installation

This resource is available in the [InSpec Azure resource pack](https://github.com/inspec/inspec-azure). For an example, `inspec.yml` file and how to set up your Azure credentials, refer to resource pack [README](../../README.md#Service-Principal).

## Syntax

`name`, `account_name` is a required parameter and `dns_suffix` is an optional parameter.

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

| Name           | Description                                                                      |
|----------------|----------------------------------------------------------------------------------|
| name           | Name of the Azure Date Lake Storage Gen2 to test.                                |
| account_name   | Azure Storage Account Name.                                                       |
| dns_suffix     | The DNS suffix for the Azure Data Lake Storage endpoint.                        |

The parameter set should be provided for a valid query:

- `name` and `account_name`

## Properties

| Property                            | Description                                                      |
|-------------------------------------|------------------------------------------------------------------|
| last_modified                       | Last Modified Timestamp of the resource.                         |
| etag                                | HTTP strong entity tag value.                                    |
| x_ms_properties                     | Properties of the filesystem.                                    |
| x_ms_namespace_enabled              | Boolean String for Namespace enablement.                         |
| x_ms_default_encryption_scope       | Default Encryption Scope.                                        |
| x_ms_deny_encryption_scope_override | Boolean String for Deny Encryption Scope.                        |
| x_ms_request_id                     | Request ID.                                                      |
| x_ms_version                        | Version of the API.                                              |
| date                                | Date String of the request.                                      |


For properties applicable to all resources, such as `type`, `name`, `id`, and `properties`, refer to [`azure_generic_resource`](azure_generic_resource.md#properties).

Also, refer to [Azure documentation](https://docs.microsoft.com/en-us/rest/api/storageservices/datalakestoragegen2/filesystem/get-properties) for other properties available.

## Examples

### Test that the Data Lake Storage Gen 2 Filesystem 

```ruby
describe azure_data_lake_storage_gen2_filesystem(account_name: 'ACCOUNT_NAME', name: 'FILE_SYSTEM')  do
  its() { should eq 1.0 }
end
```

## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](/inspec/matchers/).

### exists

```ruby
# If the Data Lake Storage Gen 2 Filesystem is found, it will exist
describe azure_data_lake_storage_gen2_filesystem(account_name: 'ACCOUNT_NAME', name: 'FILE_SYSTEM')  do
  it { should exist }
end

# if the Data Lake Storage Gen 2 Filesystem is not found, it will not exist
describe azure_data_lake_storage_gen2_filesystem(account_name: 'ACCOUNT_NAME', name: 'FILE_SYSTEM')  do
  it { should_not exist }
end
```

## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be set up with a `contributor` role on the subscription and `Storage Blob Data Contributor` role on the ADLS Gen2 Storage Account you wish to test.