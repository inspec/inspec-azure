---
title: About the azure_active_directory_domain_services Resource
platform: azure
---

# azure_active_directory_domain_services
Use the `azure_active_directory_domain_services` InSpec audit resource to test properties of some or all Azure Active Directory domains within a tenant.

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

An `azure_active_directory_domain_services` resource block returns all Azure Active Directory domains contained within the configured tenant and then tests that group of domains.

```ruby
describe azure_active_directory_domain_services do
  #...
end
```

## Parameters

The following parameters can be passed for targeting specific domains.

| Name              | Description                                                 | Example                             |
|-------------------|-------------------------------------------------------------|-------------------------------------|
| filter            | A hash containing the filtering options and their values. The `starts_with_` operator can be used for fuzzy string matching. Parameter names are in snake case. | `{ starts_with_given_name: 'J', starts_with_department: 'Core', country: 'United Kingdom', given_name: John}` |
| filter_free_text  | [OData](https://www.odata.org/getting-started/basic-tutorial/) query string in double quotes, `"`. Property names are in camel case, refer to [Microsoft's query parameters documentation](https://docs.microsoft.com/en-us/graph/query-parameters#filter-parameter) for more information. | `"startswith(displayName,'J') and surname eq 'Doe'"` or `"userType eq 'Guest'"` |

It is advised to use these parameters to narrow down the targeted resources at the server side, Azure Graph API, for a more efficient test.

## Properties

| Property              | Description                                                      | Filter Criteria<superscript>*</superscript> |
|-----------------------|------------------------------------------------------------------|---------------------------------------------|
| ids                   | A list of fully qualified names of the domain.                   | `id`                                        |
| authentication_types  | A list of the configured authentication types for the domain.    | `authenticationType`                        |
| availability_statuses | A list of domain entities when verify action is set.             | `availabilityStatus`                        |
| is_admin_manageds     | A list of admin managed configuration.                          | `isAdminManaged`                            |
| is_defaults           | A list of flags to indicate if they are default domains.        | `isDefault`                                 |
| is_initials           | A list of flags to indicate if they are initial domains created by Microsoft Online Services.| `isInitial`    |
| is_roots              | A list of flags to indicate if they are verified root domains.  | `isRoot`                                    |
| is_verifieds          | A list of flags to indicate if the domains have completed domain ownership verification.| `isVerified`        |
| password_notification_window_in_days | A list of password notification window days.      | `passwordNotificationWindowInDays`          |
| password_validity_period_in_days | A list of password validity periods in days.          | `passwordValidityPeriodInDays`              |
| supported_services    | A list of capabilities assigned to the domain.                  | `supportedServices`                         |
| states                | A list of asynchronous operations scheduled.                    | `state`                                     |

<superscript>*</superscript> For information on how to use filter criteria on plural resources refer to [FilterTable usage](https://github.com/inspec/inspec/blob/master/dev-docs/filtertable-usage.md).

## Examples

The following examples show how to use this InSpec audit resource.

### Check domains with some filtering parameters applied at server side using `filter`

```ruby
describe azure_active_directory_domain_services(filter: {authenticationType: "authenticationType-value"}) do
  it { should exist }
end
```

### Check domains with some filtering parameters applied at server side using `filter_free_text`

```ruby
describe azure_active_directory_domain_services(filter_free_text: "startswith(authenticationType,'authenticationType-value')") do
  it { should exist }
end
```

### Ensure there are supported services using client-side filtering

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
  it { should_not exist }
end
```

## Azure Permissions

Graph resources require specific privileges granted to your service principal.
Please refer to the [Microsoft Documentation](https://docs.microsoft.com/en-us/azure/active-directory/develop/active-directory-integrating-applications#updating-an-application) for information on how to grant these permissions to your application.
