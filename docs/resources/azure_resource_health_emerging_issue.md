---
title: About the azure_resource_health_emerging_issue Resource
platform: azure
---

# azure_resource_health_emerging_issue

Use the `azure_resource_health_emerging_issue` InSpec audit resource to test properties related to a Azure Resource Health Emerging issue.

## Azure REST API version, endpoint, and HTTP client parameters

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

`name` is a required parameter.

```ruby
describe azure_resource_health_emerging_issue(name: 'EMERGING_ISSUE_NAME') do
  it                                      { should exist }
  its('properties.statusActiveEvents') { should be_empty }
end
```

```ruby
describe azure_resource_health_emerging_issue(name: 'EMERGING_ISSUE_NAME') do
  it  { should exist }
end
```
## Parameters

| Name           | Description                                                                      |
|----------------|----------------------------------------------------------------------------------|
| name           | Name of the Azure Resource Health emerging issue to test.                        |


## Properties

| Property                      | Description                                                       |
|-------------------------------|-------------------------------------------------------------------|
| id                            | Fully qualified resource ID for the resource.                     |
| name                          | The name of the resource.                                         |
| type                          | The type of the resource.                                         |
| properties.statusActiveEvents | The list of emerging issues of active event type.                 |
| properties.statusBanners      | The list of emerging issues of banner type.                       |
| properties.refreshTimestamp   | Timestamp for when last time refreshed for ongoing emerging issue.|


For properties applicable to all resources, such as `type`, `name`, `id`, `properties`, refer to [`azure_generic_resource`](azure_generic_resource.md#properties).

Also, refer to [Azure documentation](https://docs.microsoft.com/en-us/rest/api/resourcehealth/emerging-issues/get) for other properties available.
Any attribute in the response may be accessed with the key names separated by dots (`.`).

## Examples

### Test that there are emerging issues with an active event type

```ruby
describe azure_resource_health_emerging_issue(name: 'default') do
  its('properties.statusActiveEvents') { should_not be_empty }
end
```

## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](/inspec/matchers/).

### exists

```ruby
# If a emerging issue is found, it will exist
describe azure_resource_health_emerging_issue(name: 'default') do
  it { should exist }
end
# If no emerging issues are found, it will not exist
describe azure_resource_health_emerging_issue(name: 'default') do
  it { should_not exist }
end
```

## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be setup with a `contributor` role on the subscription you wish to test.