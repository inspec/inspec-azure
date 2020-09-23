---
title: About the azure_graph_generic_resources Resource
platform: azure
---

# azure_graph_generic_resources

Use the `azure_graph_generic_resources` Inspec audit resource to test any valid Azure resource available through Microsoft Azure Graph API. 

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
describe azure_graph_generic_resources(resource: 'resource', filter: {starts_with_property_name: 'A'}, select: %w(properties to be tested)) do
  its('property') { should eq 'value' }
end
```

where

- Resource parameters are used to query Azure Graph API endpoint for the resource to be tested.
- `property` - This generic resource dynamically creates the properties on the fly based on the type of resource that has been targeted and the parameters provided with the `select` parameter. 
- `value` is the expected output from the chosen property.

## Parameters

The following parameters can be passed for targeting specific Azure resources.

| Name              | Description                                                                                                                                                           | Example                             |
|-------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------------------------------------|
| resource          | Azure resource type that the targeted resource belongs to. This is the only **MANDATORY** parameter.                                                                  | `users`                             |
| filter            | A hash containing the filtering options and their values. The `starts_with_` operator can be used for fuzzy string matching. Parameter names are in snakecase. | `{ starts_with_given_name: 'J', starts_with_department: 'Core', country: 'United Kingdom', given_name: John}` |
| filter_free_text  | [OData](https://www.odata.org/getting-started/basic-tutorial/) query string in double quotes, `"`. Property names are in camelcase, refer to [here](https://docs.microsoft.com/en-us/graph/query-parameters#filter-parameter) for more information. | `"startswith(displayName,'J') and surname eq 'Doe'"`    |
| select            | A list of the query parameters defining which attributes that the resource will expose and to be tested. Property names are in camelcase. If not provided then the predefined attributes will be returned from the API. | `['givenName', 'surname', 'department']`    |
| api_version       | API version of the Azure Graph API to use when interrogating the resource. If not set then the predefined stable version will be used.                                 | `v1.0`, `beta`                      |

It is advised to use `filter` or `filter_free_text` to narrow down the targeted resources at the server side, Azure Graph API, for a more efficient test.

## Properties

Attributes will be created dynamically by pluralizing the name of the properties of the resources and converting them to `snake_case` form.

E.g., if the query parameters are `select: %w{ country department givenName }`, then the parameters will be:

- `ids` (default)
- `countries` 
- `departments` 
- `given_names` 
  
## Filter Criteria

Returned resources can be filtered by their parameters provided with the `select` option or the default values returned from the API unless the `select` is used.

E.g., if the query parameters are `select: %w{ country department givenName }`, then the filter criteria will be:

- `id` (default)
- `country` 
- `department` 
- `givenName` 

## Examples

### Test a Selection of User Accounts
```ruby
# Using filter parameter
describe azure_graph_generic_resources(resource: 'users', filter: { starts_with_given_name: 'J', starts_with_department: 'customer', country: 'United Kingdom' },  select: %w{ country userPrincipalName}) do
  it { should exist }
  its('countries'.uniq) { should eq ['United Kingdom'] }
end

# Using filter_free_text parameter
describe azure_graph_generic_resources(resource: 'users', filter_free_text: "startswith(givenName,'J') and startswith(department,'customer') and country eq 'United States'",  select: %w{ country userPrincipalName}) do
  it { should exist }
  its('countries'.uniq) { should eq ['United States'] }
end
```

### Filter<superscript>*</superscript> the Results to Only Include Those that Match the Given Country (Client-Side Filtering - NOT Recommended)
```ruby
    describe azure_graph_generic_resources(resource: 'users', select: %w{ country }).where(country: 'United Kingdom') do
      it { should exist }
    end
```
<superscript>*</superscript>For information on how to use filter criteria on plural resources refer to [FilterTable usage](https://github.com/inspec/inspec/blob/master/dev-docs/filtertable-usage.md). Please note that instead of client side filtering with `where`, it is much more efficient to use server side filtering at Azure Graph API with `filter` or `filter_free_text` at resource creation as described in previous examples.

### Test `given_names` Parameter
```ruby
azure_graph_generic_resources(resource: 'users', filter: { starts_with_given_name: 'J' }, select: %w{ givenName }).given_names.each do |name|
  describe name do
    it { should start_with('J') }
  end  
end  
```
## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](https://www.inspec.io/docs/reference/matchers/).

### exist
```ruby
# Should not exist if there is no resource with a given name
describe azure_graph_generic_resources(resource: 'users', filter: { given_name: 'fake_name'}, select: %w{ givenName }) do
  it { should_not exist }
end

# Should exist if there is at least one resource with a given name
describe azure_graph_generic_resources(resource: 'users', filter: { given_name: 'valid_name'}, select: %w{ givenName }) do
  it { should exist }
end
```

## Azure Permissions

Graph resources require specific privileges granted to your service principal.
Please refer to the [Microsoft Documentation](https://docs.microsoft.com/en-us/azure/active-directory/develop/active-directory-integrating-applications#updating-an-application) for information on how to grant these permissions to your application.