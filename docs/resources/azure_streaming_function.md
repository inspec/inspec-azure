---
title: About the azure_streaming_analytics_function Resource
platform: azure
---

# azure_streaming_analytics_function

Use the `azure_streaming_analytics_function` InSpec audit resource to test properties and configuration of an Azure streaming analytics function.

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

`resource_group`,`job-name/name` and `function-name`  must be given as a parameter.
```ruby
describe azure_streaming_analytics_function(resource_group: 'inspec-rg', job-name: 'my_app', function-name: 'my-function') do
  it { should exist }
end
```

## Parameters

| Name                                  | Description                                                                       |
|---------------------------------------|-----------------------------------------------------------------------------------|
| resource_group                        | Azure resource group that the targeted resource resides in. `MyResourceGroup`     |
| name                                  | Name of the webapp to test. `my_function`                                    |
| function-name                         | Name of the function made in the job mentioned. `my-function` |

All three of the parameter are needed for a valid query along with the optional ones:

- `resource_group` and `name` and `function-name`

## Properties

| Property          | Description |
|-------------------|-------------|
| id                | unique id of the function  '/subscriptions/56b5e0a9-b645-407d-99b0-c64f86013e3d/resourceGroups/sjrg/providers/Microsoft.StreamAnalytics/streamingjobs/sjName/functions/function8197'|
| name              | Name of the function. |
| type              | Resource type.  `Microsoft.StreamAnalytics/streamingjobs/functions` |
| properties        |The properties that are associated with a function. |


For properties applicable to all resources, such as `type`, `name`, `id`, `properties`, refer to [`azure_generic_resource`](azure_generic_resource.md#properties).

Also, refer to [Azure documentation](https://docs.microsoft.com/en-us/rest/api/streamanalytics/) for other properties available.
Any attribute in the response may be accessed with the key names separated by dots (`.`), eg. `properties.<attribute>`.

## Examples

### Test that a Resource Group has the Specified type 
```ruby
describe azure_streaming_analytics_function(resource_group: 'inspec-rg', job-name: 'my_app', function-name: 'my-function') do
  it { should exist }
  its('type')                                         { should cmp 'Microsoft.StreamAnalytics/streamingjobs/functions' }
  its('properties.type')                              { should cmp 'Scalar' }
end
```

## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](https://www.inspec.io/docs/reference/matchers/).

### Test Streaming function to Ensure it's Using Javascript UDF
```ruby
describe azure_streaming_analytics_function(resource_group: 'inspec-rg', job-name: 'my_app', function-name: 'my-function') do
its('properties.binding.type')                              { should cmp 'Microsoft.StreamAnalytics/JavascriptUdf' }
end
```    

### exists
```ruby
# If we expect a resource to always exist
describe azure_streaming_analytics_function(resource_group: 'inspec-rg', job-name: 'my_app', function-name: 'my-function') do
  it { should exist }
end
# If we expect a resource to never exist
describe azure_streaming_analytics_function(resource_group: 'inspec-rg', job-name: 'my_app', function-name: 'my-function') do
  it { should_not exist }
end
```
## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be setup with a `contributor` role on the subscription you wish to test.
