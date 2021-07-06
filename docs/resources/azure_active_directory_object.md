---
title: About the azure_active_directory_object Resource
platform: azure
---

# azure_active_directory_object

Use the `azure_active_directory_object` InSpec audit resource to test properties of an Azure Active Directory Object.

## Azure REST API version, endpoint and http client parameters

This resource interacts with api versions supported by the resource provider.
The `api_version` can be defined as a resource parameter.
If not provided, the latest stable version will be used.
For more information, refer to [`azure_graph_generic_resource`](azure_graph_generic_resource.md).

Unless defined, `azure_cloud` global endpoint, and default values for the http client will be used.
For more information, refer to the resource pack [README](../../README.md).

## Availability

### Installation

This resource is available in the [InSpec Azure resource pack](https://github.com/inspec/inspec-azure).
For an example `inspec.yml` file and how to set up your Azure credentials, refer to resource pack [README](../../README.md#Service-Principal).

## Syntax
```ruby
describe azure_active_directory_object(id: 'test-id') do
  it { should exist }
end
```
## Parameters

Either one of the following parameters is mandatory.

| Name               | Description | Example |
|--------------------|-------------|---------|
| id                  | Directory Object ID | `abcd-1234-efabc-5678` | 

## Properties

| Property                      | Description |
|-------------------------------|-------------|
| id                            | The Directory Object's globally unique ID. |

## Examples

### Test If an Active Directory Domain is Referenced with a Valid ID
```ruby
describe azure_active_directory_object(id: 'someValidId') do
  it { should exist }
end
```
### Test If an Active Directory Domain is Referenced with an Invalid ID
```ruby
describe azure_active_directory_object(id: 'someInvalidId') do
  it { should_not exist }
end
```
## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](https://www.inspec.io/docs/reference/matchers/).

### exists
```ruby
describe azure_active_directory_object(id: 'test-id') do
  it { should exist }
end
```
## Azure Permissions

Graph resources require specific privileges granted to your service principal.
Please refer to the [Microsoft Documentation](https://docs.microsoft.com/en-us/azure/active-directory/develop/active-directory-integrating-applications#updating-an-application) for information on how to grant these permissions to your application.