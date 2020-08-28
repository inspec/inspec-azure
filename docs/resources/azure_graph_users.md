---
title: About the azure_graph_users Resource
platform: azure
---

# azure_graph_users
Use the `azure_graph_users` InSpec audit resource to test properties of some or all Azure Active Directory users within a Tenant.

## Azure REST API version, endpoint and http client parameters

This resource interacts with api versions supported by the resource provider.
The `api_version` can be defined as a resource parameter.
If not provided, the latest stable version will be used.
For more information, refer to [`azure_graph_generic_resources`](azure_graph_generic_resources.md).

Unless defined, `azure_cloud` global endpoint, and default values for the http client will be used.
For more information, refer to the resource pack [README](../../README.md). 

## Availability

### Installation

This resource is available in the [InSpec Azure resource pack](https://github.com/inspec/inspec-azure). 
For an example `inspec.yml` file and how to set up your Azure credentials, refer to resource pack [README](../../README.md#Service-Principal).

## Syntax

An `azure_graph_users` resource block returns all Azure Active Directory user accounts contained within the configured Tenant and then tests that group of users.
```ruby
describe azure_graph_users do
  #...
end
```
## Parameters

The following parameters can be passed for targeting specific users.

| Name              | Description                                                 | Example                             |
|-------------------|-------------------------------------------------------------|-------------------------------------|
| filter            | A hash containing the filtering options and their values. The `starts_with_` operator can be used for fuzzy string matching. Parameter names are in snake_case. | `{ starts_with_given_name: 'J', starts_with_department: 'Core', country: 'United Kingdom', given_name: John}` |
| filter_free_text  | [OData](https://www.odata.org/getting-started/basic-tutorial/) query string in double quotes, `"`. Property names are in camelcase, refer to [here](https://docs.microsoft.com/en-us/graph/query-parameters#filter-parameter) for more information. | `"startswith(displayName,'J') and surname eq 'Doe'"` or `"userType eq 'Guest'"` |

It is advised to use these parameters to narrow down the targeted resources at the server side, Azure Graph API, for a more efficient test.

## Properties

| Property              | Description | Filter Criteria<superscript>*</superscript>  |
|-----------------------|-------------|-----------------|
| ids                   | The unique identifiers of users. | `id` |
| object_ids            | The unique identifiers of users. This is for backward compatibility, use `ids` instead.  | `id` |
| display_names         | The display names of users.  | `displayName` |
| given_names           | The given names of users.  | `givenName` |
| job_titles            | The job titles of users.  | `jobTitle` |
| mails                 | The email addresses of users.  | `mail` |
| user_types            | The user types of users, e.g.; `Member`, `Guest`.  | `userType` |
| user_principal_names  | The user principal names of users, e.g.; `jdoe@contoso.com`.  | `userPrincipalName` |

<superscript>*</superscript> For information on how to use filter criteria on plural resources refer to [FilterTable usage](https://github.com/inspec/inspec/blob/master/docs/dev/filtertable-usage.md#a-where-method-you-can-call-with-hash-params-with-loose-matching).

## Examples

The following examples show how to use this InSpec audit resource.

### Check Users with Some Filtering Parameters Applied at Server Side (Using `filter`)
```ruby
describe azure_graph_users(filter: {given_name: 'John', starts_with_department: 'Customer'}) do
  it { should exist }
end
```    
### Check Users with Some Filtering Parameters Applied at Server Side (Using `filter_free_text`)
```ruby
describe azure_graph_users(filter_free_text: "startswith(givenName,'J') and startswith(department,'customer') and country eq 'United States'") do
  it { should exist }
end
```
### Ensure There are No Guest Accounts Active (Client Side Filtering)
```ruby
describe azure_graph_users.guest_accounts do
  it { should_not exist }
end
```    
## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](https://www.inspec.io/docs/reference/matchers/).

### exists

The control will pass if the filter returns at least one result. Use `should_not` if you expect zero matches.
```ruby
describe azure_graph_users do
  it { should exist }
end
```
## Azure Permissions

Graph resources require specific privileges granted to your service principal.
Please refer to the [Microsoft Documentation](https://docs.microsoft.com/en-us/azure/active-directory/develop/active-directory-integrating-applications#updating-an-application) for information on how to grant these permissions to your application.
