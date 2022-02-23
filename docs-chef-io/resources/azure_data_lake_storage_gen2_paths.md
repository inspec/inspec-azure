---
title: About the azure_data_lake_storage_gen2_paths Resource
platform: azure
---

# azure_data_lake_storage_gen2_paths

Use the `azure_data_lake_storage_gen2_paths` InSpec audit resource to test the properties related to all Azure Data Lake Storage Gen2 Filesystem Paths within a project.

## Azure REST API version, Endpoint, and HTTP Client Parameters

This resource interacts with API versions supported by the resource provider. The `api_version` is defined as a resource parameter.
If not provided, the latest version is used. For more information, refer to [`azure_generic_resource`](azure_generic_resource.md).

Unless defined, `azure_cloud` global endpoint and default values for the HTTP client is used. For more information, refer to the resource pack [README](../../README.md).

## Availability

### Installation

This resource is available in the [InSpec Azure resource pack](https://github.com/inspec/inspec-azure). For an example, `inspec.yml` file and how to set up your Azure credentials, refer to resource pack [README](../../README.md#Service-Principal).

## Syntax

An `azure_data_lake_storage_gen2_paths` resource block returns all Azure Data Lake Storage Gen2 Filesystem Paths within a project.

```ruby
describe azure_data_lake_storage_gen2_paths(account_name: 'ACCOUNT_NAME', filesystem: 'ADLS FILESYSTEM') do
  #...
end
```

## Parameters
| Name           | Description                                                                      |
|----------------|----------------------------------------------------------------------------------|
| account_name   | The Azure Storage account name.                                                  |
| dns_suffix     | The DNS suffix for the Azure Data Lake Storage endpoint.                         |

The parameter set should be provided for a valid query:
- `account_name` and `filesystem`
- `account_name`, `filesystem` and `dns_suffix` (optional)

## Properties

|Property                        | Description                                                            | Filter Criteria<superscript>*</superscript> |
|--------------------------------|------------------------------------------------------------------------|------------------|
| names                          | Unique names for all the paths in the filesystem.                      | `name`           |
| lastModifieds                  | Last modified timestamps of all the paths in the filesystem.           | `lastModified`   |
| eTags                          | A list of eTags for all the paths in the filesystem.                   | `eTag`           |
| contentLengths                 | A list of Content Length of all the paths in the filesystem .          | `contentLength`|


<superscript>*</superscript> For information on how to use filter criteria on plural resources refer to [FilterTable usage](https://github.com/inspec/inspec/blob/master/dev-docs/filtertable-usage.md).
Also, refer to [Azure documentation](https://docs.microsoft.com/en-us/rest/api/storageservices/datalakestoragegen2/path/list) for other properties available.

## Examples

### Loop through Data Lake Storage Gen2 Filesystem Paths by their names

```ruby
azure_data_lake_storage_gen2_paths(account_name: 'ACCOUNT_NAME', filesystem: 'ADLS FILESYSTEM').names.each do |name|
  describe azure_data_lake_storage_gen2_path(account_name: 'ACCOUNT_NAME', filesystem: 'ADLS FILESYSTEM', name: name) do
    it { should exist }
  end
end
```

### Test to ensure Data Lake Storage Gen2 Filesystem Paths with file size greater than 2 MB

```ruby
describe azure_data_lake_storage_gen2_paths(account_name: 'ACCOUNT_NAME', filesystem: 'ADLS FILESYSTEM').where{ contentLength > 2097152 } do
  it { should exist }
end
```

## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](https://www.inspec.io/docs/reference/matchers/).

### exists

```ruby
# Should not exist if no Data Lake Storage Gen2 Filesystems are present in the project and in the resource group
describe azure_data_lake_storage_gen2_paths(account_name: 'ACCOUNT_NAME', filesystem: 'ADLS FILESYSTEM') do
  it { should_not exist }
end

# Should exist if the filter returns at least one Migrate Assessment in the project and in the resource group
describe azure_data_lake_storage_gen2_paths(account_name: 'ACCOUNT_NAME', filesystem: 'ADLS FILESYSTEM') do
  it { should exist }
end
```

## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be set up with a `contributor` role on the subscription you wish to test.