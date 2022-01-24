---
title: About the azure_storage_account Resource
platform: azure
---

# azure_storage_account

Use the `azure_storage_account` InSpec audit resource to test properties related to an Azure Storage Account.

## Azure REST API Version, Endpoint, and HTTP Client Parameters

This resource interacts with API versions supported by the resource provider.
The `api_version` can be defined as a resource parameter.
If not provided, the latest version will be used.
For more information, refer to [`azure_generic_resource`](azure_generic_resource.md).

Unless defined, `azure_cloud` global endpoint and default values for the HTTP client will be used.
For more information, refer to the resource pack [README](../../README.md).

## Availability

### Installation

This resource is available in the [InSpec Azure resource pack](https://github.com/inspec/inspec-azure). 
For an example `inspec.yml` file and how to set up your Azure credentials, refer to resource pack [README](../../README.md#Service-Principal).

## Syntax

An `azure_storage_account` resource block identifies an Azure storage account by `name` and `resource_group` or the `resource_id`.
```ruby
describe azure_storage_account(resource_group: 'rg', name: 'sa')  do
  it { should exist }
end
```
```ruby
describe azure_storage_account(resource_id: '/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Storage/storageAccounts/{accountName}') do
  it { should exist }
end
```
## Parameters

| Name                           | Description                                                                          |
|--------------------------------|--------------------------------------------------------------------------------------|
| resource_group                 | Azure resource group that the targeted resource resides in. `MyResourceGroup`        |
| name                           | The name of the storage account within the specified resource group. `accountName`   |
| resource_id                    | The unique resource ID. `/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Storage/storageAccounts/{accountName}` |
| activity_log_alert_api_version | The activity log alerts endpoint api version used in `have_recently_generated_access_key` matcher. The latest version will be used unless provided. |
| storage_service_endpoint_api_version | The storage service endpoint api version. `2019-12-12` wil be used unless provided. |
| resource_data                  | In-Memory cached Azure Storage Account Data. This is an optional parameter and can be provided to increase performance since it avoids multiple network calls to the same resource. When provided it binds the values directly to the resource. | 
[Warning] when `resource_data` parameter is in use, the resource state itself could be stale and it is the user's responsibility to refresh the data.

Either one of the parameter sets can be provided for a valid query:
- `resource_id`
- `resource_group` and `name`
- `resource_data`

## Properties

| Property                                     | Description |
|----------------------------------------------|-------------|
| queues<superscript>*</superscript>           | Lists all of the queues in a given storage account. See [here](https://docs.microsoft.com/en-us/rest/api/storageservices/list-queues1) for more. |
| queue_properties<superscript>*</superscript> | gets the properties of a storage account’s Queue service, including properties for Storage Analytics and CORS (Cross-Origin Resource Sharing) rules. See [here](https://docs.microsoft.com/en-us/rest/api/storageservices/get-queue-service-properties) for more. |
| blobs<superscript>*</superscript>           | Lists all of the blob containers in a given storage account. See [here](https://docs.microsoft.com/en-us/rest/api/storageservices/list-containers2) for more.  |
| blob_properties<superscript>*</superscript> | gets the properties of a storage account’s Blob service, including properties for Storage Analytics and CORS (Cross-Origin Resource Sharing) rules. See [here](https://docs.microsoft.com/en-us/rest/api/storageservices/get-blob-service-properties) for more. |
| table_properties<superscript>*</superscript> | gets the properties of a storage account’s Table service, including properties for Storage Analytics and CORS (Cross-Origin Resource Sharing) rules. See [here](https://docs.microsoft.com/en-us/rest/api/storageservices/get-table-service-properties) for more. |

<superscript>*</superscript>: Note that the Azure endpoints return data in XML format; however, they will be converted to Azure Resource Probe to make the properties accessible via dot notation.
The property names will be in snake case, `propety_name`. Therefore, `<EnumerationResults ServiceEndpoint="https://myaccount.queue.core.windows.net/">` can be tested via `its('enumeration_results.service_endpoint)`.

The property names will be in snake case, `propety_name`. Therefore, `<EnumerationResults ServiceEndpoint="https://myaccount.blob.core.windows.net/">` can be tested via `its('enumeration_results.service_endpoint)`.

For properties applicable to all resources, such as `type`, `name`, `id`, `properties`, refer to [`azure_generic_resource`](azure_generic_resource.md#properties).

Also, refer to [Azure documentation](https://docs.microsoft.com/en-us/rest/api/storagerp/storageaccounts/getproperties#storageaccount) for other properties available. 
Any attribute in the response may be accessed with the key names separated by dots (`.`).

## Examples

### Test the Primary Endpoints
```ruby
describe azure_storage_account(resource_group: 'rg', name: 'mysa') do
  its('properties.primaryEndpoints.blob') { should cmp 'https://mysa.blob.core.windows.net/' }
  its('properties.primaryEndpoints.queue') { should cmp 'https://mysa.queue.core.windows.net/' }
  its('properties.primaryEndpoints.table') { should cmp 'https://mysa.table.core.windows.net/' }
  its('properties.primaryEndpoints.file') { should cmp 'https://mysa.file.core.windows.net/' }
end
```
### Verify that Only HTTPs is Supported
```ruby
describe azure_storage_account(resource_group: 'rg', name: 'mysa') do
  its('properties.supportsHttpsTrafficOnly') { should be true }
end
```
### Test Queues Service Endpoint
```ruby
describe azure_storage_account(resource_group: 'rg', name: 'mysa') do
  its('queues.enumeration_results.service_endpoint') { should cmp 'https://mysa.queue.core.windows.net/' }
end
```
### Test Blobs Service Endpoint
```ruby
describe azure_storage_account(resource_group: 'rg', name: 'mysa') do
  its('blobs.enumeration_results.service_endpoint') { should cmp 'https://mysa.blob.core.windows.net/' }
end
```
### Test Queue Properties Logging Version
```ruby
describe azure_storage_account(resource_group: 'rg', name: 'mysa') do
  its('queue_properties.logging.version') { should cmp '1.0' }
end
```
### Test Blob Properties Logging Version
```ruby
describe azure_storage_account(resource_group: 'rg', name: 'mysa') do
  its('blob_properties.logging.version') { should cmp '1.0' }
end
```
### Test Table Properties Logging Version
```ruby
describe azure_storage_account(resource_group: 'rg', name: 'mysa') do
  its('table_properties.logging.version') { should cmp '1.0' }
end
```

### Test that Blobs Service Endpoint exist from already cached data
```ruby
azure_storage_accounts.entries.each do |azure_storage_account_data|
    describe azure_storage_account(resource_data: azure_storage_account_data) do
      its('blobs.enumeration_results.service_endpoint') { should cmp 'https://mysa.blob.core.windows.net/' }
    end
end
```

## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](https://docs.chef.io/inspec/matchers/).

### have_encryption_enabled

Test if encryption is enabled.
```ruby
describe azure_storage_account(resource_group: 'rg', name: 'mysa') do
  it { should have_encryption_enabled }
end
```
### have_recently_generated_access_key

Test if an access key has been generated within the last **90** days.
```ruby
describe azure_storage_account(resource_group: 'rg', name: 'mysa') do
  it { should have_recently_generated_access_key }
end
```
### exists
```ruby
# If we expect the resource to always exist
describe azure_storage_account(resource_group: 'rg', name: 'mysa') do
  it { should exist }
end

# If we expect the resource to never exist
describe azure_storage_account(resource_group: 'rg', name: 'mysa') do
  it { should_not exist }
end
```
## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be setup with a `contributor` role on the subscription you wish to test.
