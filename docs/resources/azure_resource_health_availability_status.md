---
title: About the azure_resource_health_availability_status Resource
platform: azure
---

# azure_resource_health_availability_status

Use the `azure_resource_health_availability_status` InSpec audit resource to test properties related to a Azure Resource Health availability status.

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

`resource_group`, `resource_type` and `name` are required parameters.

```ruby
describe azure_resource_health_availability_status(resource_group: 'AZURE_RESOURCE_GROUP', resource_type: 'AZURE_RESOURCE_TYPE', name: 'RESOURCE_NAME') do
  it                                      { should exist }
  its('name')                             { should cmp 'current' }
  its('type')                             { should cmp 'Microsoft.ResourceHealth/AvailabilityStatuses' }
  its('location')                         { should cmp 'ukwest' }
  its('properties.availabilityState')     { should cmp 'Available' }
  its('properties.reasonChronicity')      { should cmp 'Persistent' }
end
```

## Parameters

| Name           | Description                                                                      |
|----------------|----------------------------------------------------------------------------------|
| name           | Name of the Azure resource to test.                                              |
| resource_group | Azure resource group that the targeted resource resides in.                      |
| resource_type  | Azure resource type of the targeted resource.                                    |

The parameter set should be provided for a valid query:
- `resource_group`, `resource_type` and `name`

## Properties

| Property                      | Description                                                      |
|-------------------------------|------------------------------------------------------------------|
| id                            | Azure Resource Manager Identity for the availabilityStatuses resource. |
| name                          | current.                                                         |
| type                          | `Microsoft.ResourceHealth/AvailabilityStatuses`.                   |
| location                      | Azure Resource Manager geo location of the resource.             |
| properties                    | Properties of availability state.                                |

For properties applicable to all resources, such as `type`, `name`, `id`, `properties`, refer to [`azure_generic_resource`](azure_generic_resource.md#properties).

Also, refer to [Azure documentation](https://docs.microsoft.com/en-us/rest/api/resourcehealth/availability-statuses/get-by-resource) for other properties available.
Any attribute in the response may be accessed with the key names separated by dots (`.`).

## Examples

### Test availability status of a resource.

```ruby
describe azure_resource_health_availability_status(resource_group: 'AZURE_RESOURCE_GROUP', resource_type: 'AZURE_RESOURCE_TYPE', name: 'RESOURCE_NAME') do
  its('properties.availabilityState') { should eq 'Available' }
end
```
### Test the chronicity type of a resource.

```ruby
describe azure_resource_health_availability_status(resource_group: 'AZURE_RESOURCE_GROUP', resource_type: 'AZURE_RESOURCE_TYPE', name: 'RESOURCE_NAME') do
  its('properties.reasonChronicity') { should include 'Persistent' }
end
```
## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](/inspec/matchers/).

### exists
```ruby
# If a resource status is found it will exist
describe azure_resource_health_availability_status(resource_group: 'AZURE_RESOURCE_GROUP', resource_type: 'AZURE_RESOURCE_TYPE', name: 'RESOURCE_NAME') do
  it { should exist }
end
```

## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be setup with a `contributor` role on the subscription you wish to test.