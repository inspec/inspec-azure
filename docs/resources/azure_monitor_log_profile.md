---
title: About the azure_monitor_log_profile Resource
platform: azure
---

# azure_monitor_log_profile

Use the `azure_monitor_log_profile` InSpec audit resource to test properties and configuration of an Azure log profile.

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

`name` or the `resource_id` must be given as a parameter.
```ruby
describe azure_monitor_log_profile(name: 'my_log_profile') do
  it { should exist }
end
```
```ruby
describe azure_monitor_log_profile(resource_id: '/subscriptions/{subscriptionId}/providers/microsoft.insights/logprofiles/{logProfileName}') do
  it { should exist }
end
```
## Parameters

| Name                                  | Description                                                                       |
|---------------------------------------|-----------------------------------------------------------------------------------|
| name                                  | Name of the log profile to test. `logProfileName`                                 |
| resource_id                           | The unique resource ID. `/subscriptions/{subscriptionId}/providers/microsoft.insights/logprofiles/{logProfileName}` |

## Properties

| Property          | Description |
|---------------------------|-------------|
| retention_policy                      | The retention policy for the events in the log with [these](https://docs.microsoft.com/en-us/rest/api/monitor/logprofiles/get#retentionpolicy) properties. |
| retention_days                        | The number of days for the log retention in days. A value of `0` means that the events will be retained indefinitely. |
| storage_account                       | A hash containing the `name` and the `resouce_group` of the storage account in which the activity logs are kept. |

For properties applicable to all resources, such as `type`, `name`, `id`, `properties`, refer to [`azure_generic_resource`](azure_generic_resource.md#properties).

Also, refer to [Azure documentation](https://docs.microsoft.com/en-us/rest/api/monitor/logprofiles/get#logprofileresource) for other properties available. 
Any attribute in the response may be accessed with the key names separated by dots (`.`), eg. `properties.<attribute>`.

## Examples

### Test If a Log Profile is Referenced with a Valid Name
```ruby
describe azure_monitor_log_profile(name: 'my_log_profile') do
  it { should exist }
end
```
### Test If a Log Profile is Referenced with an Invalid Name
```ruby
describe azure_monitor_log_profile(name: 'i-dont-exist') do
  it { should_not exist }
end
```    
### Test the Retention Days of a Log Profile
```ruby
describe azure_monitor_log_profile(name: 'my_log_profile') do
  its('retention_days') { should be 90 }
end
```        
### Test the Storage Account of a Log Profile
```ruby
describe azure_monitor_log_profile(resource_id: '/subscriptions/{subscriptionId}/providers/microsoft.insights/logprofiles/{logProfileName}') do
  its('storage_account') { should eql(resource_group: 'InSpec_rg', name: 'my_storage_account') }
end
```
## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](https://www.inspec.io/docs/reference/matchers/).

### have_log_retention_enabled

Test whether the log retention is enabled.
```ruby
describe azure_monitor_log_profile(name: 'my_log_profile') do
  it { should have_log_retention_enabled }
end
```

### exists
```ruby
# If we expect a resource to always exist
describe azure_monitor_log_profile(name: 'my_log_profile') do
  it { should exist }
end
# If we expect a resource to never exist
describe azure_monitor_log_profile(name: 'my_log_profile') do
  it { should_not exist }
end
```
## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be setup with a `contributor` role on the subscription you wish to test.
