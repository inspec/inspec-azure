---
title: About the azure_active_directory_domain_services Resource
platform: azure
---

# azure_active_directory_domain_services
Use the `azure_active_directory_domain_services` InSpec audit resource to test properties of some or all Azure Active Directory Domains within a Tenant.

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

An `azure_active_directory_domain_services` resource block returns all Azure Active Directory Domains contained within the configured Tenant and then tests that group of domains.
```ruby
describe azure_active_directory_domain_services do
  #...
end
```
## Parameters

The following parameters can be passed for targeting specific Domains.

| Name              | Description                                                 | Example                             |
|-------------------|-------------------------------------------------------------|-------------------------------------|
| filter            | A hash containing the filtering options and their values. The `starts_with_` operator can be used for fuzzy string matching. Parameter names are in snake_case. | `{ starts_with_given_name: 'J', starts_with_department: 'Core', country: 'United Kingdom', given_name: John}` |
| filter_free_text  | [OData](https://www.odata.org/getting-started/basic-tutorial/) query string in double quotes, `"`. Property names are in camelcase, refer to [here](https://docs.microsoft.com/en-us/graph/query-parameters#filter-parameter) for more information. | `"startswith(displayName,'J') and surname eq 'Doe'"` or `"userType eq 'Guest'"` |

It is advised to use these parameters to narrow down the targeted resources at the server side, Azure Graph API, for a more efficient test.

## Properties

| Property              | Description                                           | Filter Criteria<superscript>*</superscript>  |
|-----------------------|-------------------------------------------------------|----------------------------------------------|
| ids                   | A list of fully qualified name of the domain.         | `id`                                         |
| authentication_types  | A list of the configured authentication types for the domain.| `authentication_type`                 |
| availability_statuses | A list of domain entities when verify action is set.  | `availability_status`                        |
| is_admin_managed      | A list of admin managed configuration.                | `is_admin_managed`                           |
| is_default            | A list of flags to indicate if it is default domains. | `is_default`                                 |
| is_initial            | A list of flags to indicate if initial domains created by Microsoft Online Services.| `is_initial`   |
| is_root               | A list of flags to indicate if verified root domain.  | `is_root`                                    |
| is_verified           | A list of flags to indicate if the domain has completed domain ownership verification.| `is_verified`|
| passwordNotificationWindowInDays | A list of password notification window days.| `passwordNotificationWindowInDays`          |
| passwordValidityPeriodInDays | A list of password validity period in days.    |  `passwordValidityPeriodInDays`              |
| supportedServices     | A list of capabilities assigned to the domain.        |  `supportedServices`                         |
| state                 | A list of asynchronous operations scheduled.          |  `state`                                     |

<superscript>*</superscript> For information on how to use filter criteria on plural resources refer to [FilterTable usage](https://github.com/inspec/inspec/blob/master/dev-docs/filtertable-usage.md).

## Examples

The following examples show how to use this InSpec audit resource.

### Check Domains with Some Filtering Parameters Applied at Server Side (Using `filter`)
```ruby
describe azure_active_directory_domain_services(filter: {authenticationType: "authenticationType-value"}) do
  it { should exist }
end
```    
### Check Domains with Some Filtering Parameters Applied at Server Side (Using `filter_free_text`)
```ruby
describe azure_active_directory_domain_services(filter_free_text: "startswith(authenticationType,'authenticationType-value')") do
  it { should exist }
end
```
### Ensure There are supported services (Client Side Filtering)
```ruby
describe azure_active_directory_domain_services.supportedServices do
  it { should_not exist }
end
```    
## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](https://www.inspec.io/docs/reference/matchers/).

### exists

The control will pass if the filter returns at least one result. Use `should_not` if you expect zero matches.
```ruby
describe azure_active_directory_domain_services do
  it { should exist }
end
```
## Azure Permissions

Graph resources require specific privileges granted to your service principal.
Please refer to the [Microsoft Documentation](https://docs.microsoft.com/en-us/azure/active-directory/develop/active-directory-integrating-applications#updating-an-application) for information on how to grant these permissions to your application.
