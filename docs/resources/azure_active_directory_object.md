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
describe azure_active_directory_object(id: '0bf29229-50d7-433c-b08e-2a5d8b293cb5') do
  it { should exist }
end
```
## Parameters

parameter `id` is mandatory.

| Name               | Description            | Example |
|--------------------|------------------------|---------|
| id                  | Directory Object ID   | `0bf29229-50d7-433c-b08e-2a5d8b293cb5` | 

## Properties

| Property                      | Description                                |
|-------------------------------|--------------------------------------------|
| id                            | The Directory Object's globally unique ID. |
| deletedDateTime               | Deleted Datetime of the AD object          |
| classification                | Classification of the AD object            |
| createdDateTime               | Created Datetime of the AD object          |
| creationOptions               | creationOptions of the AD object           |
| description                   | description of the AD object               |
| displayName                   | display name of the AD object              |
| expirationDateTime            | expiration Datetime of the AD object       |
| groupTypes                    | group types of the AD object group         |
| isAssignableToRole            | Roles assignable to AD object              |
| mail                          | configured mail for AD object              | 
| mailEnabled                   | mail enabled configuration parameter       |                 
| mailNickname                  | mail nick name configuration               |
| membershipRule                | membership rule for the AD object          |
| membershipRuleProcessingState | processing state of the membership rule    |
| onPremisesDomainName          | Domain name for the given on premises      |
| onPremisesLastSyncDateTime    | on-premises latest sync datetime           |
| onPremisesNetBiosName         | on-premises net bios name                  |
| onPremisesSamAccountName      | on-premises sam account name               |
| onPremisesSecurityIdentifier  | on-premises security identifier            |
| onPremisesSyncEnabled         | on-premises sync enabled configuration     |
| onPremisesProvisioningErrors  | on-premises provisioning errors            |
| preferredDataLocation         | preferred data location                    |
| preferredLanguage             | preferred language                         |
| proxyAddresses                | proxy addresses for the object             |
| renewedDateTime               | renewed date time of the AD object         |
| resourceBehaviorOptions       | behaviour options set for the resource     |
| resourceProvisioningOptions   | resource provisioning options set          |
| securityEnabled               | security enabled configured                | 
| securityIdentifier            | security identifier configured             |
| theme                         | theme of the Object                        |
| visibility                    | visibility status of the object            |

## Examples

### Test If an Active Directory Object is Referenced with a Valid ID
```ruby
describe azure_active_directory_object(id: '0bf29229-50d7-433c-b08e-2a5d8b293cb5') do
  it { should exist }
end
```
### Test If an Active Directory Object is Referenced with an Invalid ID
```ruby
describe azure_active_directory_object(id: '0bf29229-50d7-433c-b08e-2a5d8b293cb5') do
  it { should_not exist }
end
```
## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](https://www.inspec.io/docs/reference/matchers/).

### exists
```ruby
describe azure_active_directory_object(id: '0bf29229-50d7-433c-b08e-2a5d8b293cb5') do
  it { should exist }
end
```
## Azure Permissions

Graph resources require specific privileges granted to your service principal.
Please refer to the [Microsoft Documentation](https://docs.microsoft.com/en-us/azure/active-directory/develop/active-directory-integrating-applications#updating-an-application) for information on how to grant these permissions to your application.