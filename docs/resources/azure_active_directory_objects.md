---
title: About the azure_active_directory_objects Resource
platform: azure
---

# azure_active_directory_objects

Use the `azure_active_directory_objects` InSpec audit resource to test properties and configuration of multiple Azure Active Directory Objects.

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

An `azure_active_directory_objects` resource block returns all Active Directory Objects for the current service principle.
```ruby
describe azure_active_directory_objects do
  #...
end
```

## Properties

|Property       | Description                                              | Filter Criteria<superscript>*</superscript> |
|---------------|----------------------------------------------------------|-----------------|
| values        | A list of the unique directory object values.            | `value`         |

<superscript>*</superscript> For information on how to use filter criteria on plural resources refer to [FilterTable usage](https://github.com/inspec/inspec/blob/master/dev-docs/filtertable-usage.md).

## Examples

### Iterate over and test the visibility of Active Directory objects

```ruby
  azure_active_directory_objects.values.each do |value|
    describe azure_active_directory_object(id: value)  do
      it { should exist }
      its('visibility') { should_not be_empty }
    end
  end

```
## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](https://www.inspec.io/docs/reference/matchers/).

### exists

The control will pass if the filter returns at least one result. Use `should_not` if you expect zero matches.

```ruby
# If we expect current service principle to have AD objects
describe azure_active_directory_objects do
  it { should exist }
end

# If we expect current service principle to not have AD objects
describe azure_active_directory_objects do
  it { should_not exist }
end
```
## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be setup with a `contributor` role on the subscription you wish to test.
