---
title: About the azure_active_directory_domain_service Resource
platform: azure
---

# azure_active_directory_domain_service

Use the `azure_active_directory_domain_service` InSpec audit resource to test properties of an Azure Active Directory Service within a Tenant.

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
describe azure_active_directory_domain_service(id: 'contoso.com') do
  it { should exist }
end
```
## Parameters

Either one of the following parameters is mandatory.

| Name               | Description | Example |
|--------------------|-------------|---------|
| id                  | Domain ID | `abcd-1234-efabc-5678` | 

## Properties

| Property                      | Description |
|-------------------------------|-------------|
| id                            | The user's globally unique ID. |
| authenticationType               | Whether the account is enabled. |
| availabilityStatus                          | The user's city. |
| isAdminManaged                       | The user's country. |
| isDefault                    | The user's department. |
| isInitial                  | The display name of the user. |
| isRoot    | The user's facsimile (fax) number. |
| isVerified                    | The given name for the user. |
| passwordNotificationWindowInDays                     | The user's job title. |      
| passwordValidityPeriodInDays                          | The primary email address of the user. |
| supportedServices                 | The mail alias for the user. |
| state                        | The user's mobile (cell) phone number. |

## Examples

### Test If an Active Directory Domain is Referenced with a Valid ID
```ruby
describe azure_active_directory_domain_service(id: 'someValidId')
  it { should exist }
end
```
### Test If an Active Directory Domain is Referenced with an Invalid ID
```ruby
describe azure_active_directory_domain_service(id: 'someInvalidId')
  it { should_not exist }
end
```
## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](https://www.inspec.io/docs/reference/matchers/).

### exists
```ruby
describe azure_active_directory_domain_service(id: 'domain_id') do
  it { should exist }
end
```
## Azure Permissions

Graph resources require specific privileges granted to your service principal.
Please refer to the [Microsoft Documentation](https://docs.microsoft.com/en-us/azure/active-directory/develop/active-directory-integrating-applications#updating-an-application) for information on how to grant these permissions to your application.