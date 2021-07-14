---
title: About the azure_data_lake_analytics_resource Resource
platform: azure
---

# azure_data_lake_analytics_resource

Use the `azure_data_lake_analytics_resource` InSpec audit resource to test properties related to a datalake analytics.

## Azure REST API version, endpoint and http client parameters

This resource interacts with api versions supported by the resource provider.
The `api_version` can be defined as a resource parameter.
If not provided, the latest version will be used.
For more information, refer to [`azure_generic_resource`](azure_generic_resource.md).

Unless defined, `azure_cloud` global endpoint, and default values for the http client will be used.
For more information, refer to the resource pack [README](../../README.md). 

## Availability

### Installation

This resource is available in the [InSpec Azure resource pack](https://github.com/inspec/inspec-azure). 
For an example `inspec.yml` file and how to set up your Azure credentials, refer to resource pack [README](../../README.md#Service-Principal).

## Syntax

`resource_group` and datalake analytics `name` or the `resource_id` must be given as a parameter.
```ruby
describe azure_data_lake_analytics_resource(resource_group: 'MyResourceGroup', name: 'MyVmName') do
  it { should exist }
end
```
## Parameters

| Name                           | Description                                                                      |
|--------------------------------|----------------------------------------------------------------------------------|
| resource_group                 | Azure resource group that the targeted resource resides in. `MyResourceGroup`    |
| name                           | Name of the Azure resource to test. `atalake analytics`                                       |

Either one of the parameter sets can be provided for a valid query:
- `resource_id`
- `resource_group` and `name`


For properties applicable to all resources, such as `type`, `name`, `id`, `properties`, refer to [`azure_generic_resource`](azure_generic_resource.md#properties).

Also, refer to [Azure documentation](https://docs.microsoft.com/en-us/rest/api/datalakeanalytics/accounts/get) for other properties available. 
Any attribute in the response may be accessed with the key names separated by dots (`.`).


## Examples

### Ensure that the datalake analytics has the Expected Data Disks
```ruby
describe azure_data_lake_analytics_resource(resource_group: 'MyResourceGroup', name: 'account_name') do
  its('names') { should include account_name }
end
```
### Ensure that the datalake analytics has the Expected Monitoring Agent Installed
```ruby
describe azure_data_lake_analytics_resource(resource_group: 'MyResourceGroup', name: 'account_name') do
  its('types') { should include 'Microsoft.DataLakeAnalytics/accounts'}
end
```
## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](/inspec/matchers/).

### exists
```ruby
# If a datalake analytics is found it will exist
describe azure_data_lake_analytics_resource(resource_group: 'MyResourceGroup', name: 'MyVmName') do
  it { should exist }
end

# datalake analyticss that aren't found will not exist
describe azure_data_lake_analytics_resource(resource_group: 'MyResourceGroup', name: 'DoesNotExist') do
  it { should_not exist }
end
```
## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be setup with a `contributor` role on the subscription you wish to test.
