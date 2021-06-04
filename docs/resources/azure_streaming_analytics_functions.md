---
title: About the azure_streaming_analytics_functions Resource
platform: azure
---

# azure_streaming_analytics_functions

Use the `azure_streaming_analytics_functions` InSpec audit resource to test properties and configuration of multiple Azure streaming analytics fuctions.

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

An `azure_streaming_analytics_functions` resource block returns all functions  under a job.
```ruby

describe azure_streaming_analytics_functions(resource_group: "EmptyExampleGroup", job_name: "azure_streaming_job_name") do
  #...
end

```
or

## Parameters

- `resource_group` (Required)
- `Job_name` (Required)

## Properties

|Property       | Description                                                                          | Filter Criteria<superscript>*</superscript> |
|---------------|--------------------------------------------------------------------------------------|-----------------|
| ids           | A list of the unique resource ids.                                                   | `id`            |
| names         | A list of names of all the resources being interrogated.                             | `name`          |
| tags          | A list of `tag:value` pairs defined on the resources being interrogated.             | `tags`          |
| properties    | A list of properties for all the resources being interrogated.                       | `properties`    |

Also, refer to [Azure documentation](https://docs.microsoft.com/en-us/rest/api/streamanalytics/) for other properties available.
Any attribute in the response may be accessed with the key names separated by dots (`.`), eg. `properties.<attribute>`.

<superscript>*</superscript> For information on how to use filter criteria on plural resources refer to [FilterTable usage](https://github.com/inspec/inspec/blob/master/dev-docs/filtertable-usage.md).

## Examples

### Test that an the names should be an array
```ruby
describe azure_streaming_analytics_functions(resource_group: "EmptyExampleGroup", job_name: "azure_streaming_job_name") do
  its('names') { should be_an(Array) }
end

```
## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](https://www.inspec.io/docs/reference/matchers/).

### exists

The control will pass if the filter returns at least one result. Use `should_not` if you expect zero matches.
```ruby
# If we expect 'EmptyExampleGroup' having 'azure_streaming_job_name' job should have functions in it.
describe azure_streaming_analytics_functions(resource_group: "EmptyExampleGroup", job_name: "azure_streaming_job_name") do
  it { should exist } # The test itself.
end


# If we expect 'EmptyExampleGroup' having 'azure_streaming_job_name' job should not have any functions in it
describe azure_streaming_analytics_functions(resource_group: "EmptyExampleGroup", job_name: "azure_streaming_job_name") do
  it { should_not exist }
end
```
## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be setup with a `contributor` role on the subscription you wish to test.
