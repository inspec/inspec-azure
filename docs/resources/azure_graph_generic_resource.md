---
title: About the azure_graph_generic_resource Resource
platform: azure
---

# azure_graph_generic_resource

Use the `azure_graph_generic_resource` Inspec audit resource to test any valid Azure resource available through Microsoft Azure Graph API. 

## Azure REST API version, endpoint and http client parameters

This resource interacts with api versions supported by the Azure Graph API.
The `api_version` can be defined as a resource parameter.
If not provided, the latest stable version will be used.

Unless defined, `azure_cloud` global endpoint, and default values for the http client will be used.
For more information, refer to the resource pack [README](../../README.md). 

## Availability

### Installation

This resource is available in the [InSpec Azure resource pack](https://github.com/inspec/inspec-azure). 
For an example `inspec.yml` file and how to set up your Azure credentials, refer to resource pack [README](../../README.md#Service-Principal).

## Syntax
```ruby
describe azure_graph_generic_resource(resource: 'resource', id: 'GUID', select: %w(attributes to be tested)) do
  its('property') { should eq 'value' }
end
```
where

- Resource parameters are used to query Azure Graph API endpoint for the resource to be tested.
- `property` - This generic resource dynamically creates the properties on the fly based on the property names provided with the `select` parameter. 
- `value` is the expected output from the chosen property.

## Parameters

The following parameters can be passed for targeting a specific Azure resource.

| Name              | Description                                                                                                                                                         | Example                                |
|-------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------------------------------------|
| resource          | Azure resource type that the targeted resource belongs to.                                                                                                          | `users`                                |
| id                | Globally unique ID of the targeted resource.                                                                                                                        | `jdoe@contoso.com`                     |
| select            | The list of query parameters defining which attributes that the resource will expose. If not provided then the predefined attributes will be returned from the API. | `['givenName', 'surname', 'department']` |
| api_version       | API version of the GRAPH API to use when interrogating the resource. If not set then the predefined stable version will be used.                                    | `v1.0`, `beta`                         |

## Properties

The properties that can be tested are entirely dependent on the Azure Resource that is tested and the query parameters provided with the `select` parameter.

## Examples

### Test Properties of a User Account
```ruby
describe azure_graph_generic_resource(resource: 'users', id: 'jdoe@contoso.com', select: %w{ surname givenName }) do
  its('surname') { should cmp 'Doe' }
  its('givenName') { should cmp 'John' }
end
```
For more examples, please see the [integration tests](../../test/integration/verify/controls/azure_graph_generic_resource.rb).

## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](https://www.inspec.io/docs/reference/matchers/).

### exist
```ruby
# Should not exist if there is no resource with a given name
describe azure_graph_generic_resource(resource: 'users', id: 'fake_id') do
  it { should_not exist }
end
# Should exist if there is one resource with a given name
describe azure_graph_generic_resource(resource: 'users', id: 'valid_id') do
  it { should exist }
end
```
## Azure Permissions

Graph resources require specific privileges granted to your service principal.
Please refer to the [Microsoft Documentation](https://docs.microsoft.com/en-us/azure/active-directory/develop/active-directory-integrating-applications#updating-an-application) for information on how to grant these permissions to your application.