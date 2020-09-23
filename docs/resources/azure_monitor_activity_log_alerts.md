---
title: About the azure_monitor_activity_log_alerts Resource
platform: azure
---

# azure_monitor_activity_log_alerts

Use the `azure_monitor_activity_log_alerts` InSpec audit resource to test properties and configuration of multiple Activity Log Alerts.

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

An `azure_monitor_activity_log_alerts` resource block returns all Activity Log Alerts, either within a Resource Group (if provided), or within an entire Subscription.
```ruby
describe azure_monitor_activity_log_alerts do
  it { should exist }
end
```
or
```ruby
describe azure_monitor_activity_log_alerts(resource_group: 'my-rg') do
  it { should exist }
end
```
## Parameters

- `resource_group` (Optional)

## Properties

|Property         | Description                                                                          | Filter Criteria<superscript>*</superscript> |
|-----------------|--------------------------------------------------------------------------------------|-----------------|
| ids             | A list of the unique resource ids.                                                   | `id`            |
| location        | A list of locations for all the resources being interrogated.                        | `location`      |
| names           | A list of names of all the resources being interrogated.                             | `name`          |
| tags            | A list of `tag:value` pairs defined on the resources being interrogated.             | `tags`          |
| operations      | A list of operations for all the resources being interrogated.                       | `operations`    |
| resource_group  | Azure resource group that the targeted resource resides in.                          | `resource_group`    |

<superscript>*</superscript> For information on how to use filter criteria on plural resources refer to [FilterTable usage](https://github.com/inspec/inspec/blob/master/dev-docs/filtertable-usage.md).

## Examples

### Test that a Subscription Has the Named Activity Log Alert
```ruby
describe azure_monitor_activity_log_alerts do
  its('names') { should include('ExampleLogAlert') }
end
```
### Loop through All Resources with `resource_id`
```ruby
azure_monitor_activity_log_alerts.ids.each do |id|
  describe azure_monitor_activity_log_alert(resource_id: id) do
    it { should be_enabled }
  end
end
```
## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](https://www.inspec.io/docs/reference/matchers/).

### exists

The control will pass if the filter returns at least one result. Use `should_not` if you expect zero matches.
```ruby
# If we expect 'ExampleGroup' Resource Group to have Activity Log Alerts
describe azure_monitor_activity_log_alerts(resource_group: 'ExampleGroup') do
  it { should exist }
end

# If we expect 'EmptyExampleGroup' Resource Group to not have Activity Log Alerts
describe azure_monitor_activity_log_alerts(resource_group: 'ExampleGroup') do
  it { should_not exist }
end
```
## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be setup with a `contributor` role on the subscription you wish to test.
