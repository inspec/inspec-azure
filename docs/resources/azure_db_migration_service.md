---
title: About the azure_db_migration_service Resource
platform: azure
---

# azure_db_migration_service

Use the `azure_db_migration_service` InSpec audit resource to test properties related to a Azure DB Migration Service.

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

`resource_group` and `service_name` must be given as a parameter.
```ruby
describe azure_db_migration_service(resource_group: 'inspec-group', service_name: 'inspec-cloud-pack-test') do
  it                                      { should exist }
  its('name')                             { should cmp 'inspec-cloud-pack-test' }
  its('type')                             { should cmp 'Microsoft.DataMigration/services' }
  its('sku.name')                         { should cmp 'Basic_1vCore' }
  its('sku.size')                         { should cmp '1 vCore' }
  its('location')                         { should cmp 'southcentralus' }
end
```
```ruby
describe azure_db_migration_service(resource_group: 'inspec-group', service_name: 'inspec-cloud-pack-test') do
  it            { should exist }
end
```
## Parameters

| Name                            | Description                                                                      |
|---------------------------------|----------------------------------------------------------------------------------|
| resource_group                  | Azure resource group that the targeted resource resides in. `MyResourceGroup`    |
| service_name                    | Name of the Azure DB Migration service to test.                                  |

The parameter set should be provided for a valid query:
- `resource_group` and `service_name`

## Properties

| Property                      | Description                                                      |
|-------------------------------|------------------------------------------------------------------|
| id                            | Resource ID.                                                     |
| name                          | DB Migration Service Name.                                       |
| location                      | DB Migration Service Location.                                   |
| type                          | Resource type.                                                   |
| kind                          | The resource kind.                                               |
| etag                          | HTTP strong entity tag value. Ignored if submitted.              |
| sku.name                      | The unique name of the SKU, such as 'P3'.                        |
| sku.size                      | The size of the SKU, used when the name alone does not denote a service size or when a SKU has multiple performance classes within a family, e.g. 'A1' for virtual machines. |
| sku.tier                      | The tier of the SKU, such as 'Free', 'Basic', 'Standard', or 'Premium'. |
| tags                          | Resource tags.                                                   |
| properties.provisioningState  | The resource's provisioning state.                               |
| properties.virtualSubnetId    | The ID of the Microsoft.Network/virtualNetworks/subnets resource to which the service should be joined.|
| properties.virtualNicId       | The ID of the Azure Network Interface.                           |

For properties applicable to all resources, such as `type`, `name`, `id`, `properties`, refer to [`azure_generic_resource`](azure_generic_resource.md#properties).

Also, refer to [Azure documentation](https://docs.microsoft.com/en-us/rest/api/datamigration/services/get) for other properties available.
Any attribute in the response may be accessed with the key names separated by dots (`.`).

## Examples

### Test <>
```ruby
describe azure_db_migration_service(resource_group: 'MyResourceGroup', service_name: 'dbbackup_to_uat_migration_service') do
  its('properties.provisioningState') { should eq 'Succeeded' }
end
```
### Test <>
```ruby
describe azure_db_migration_service(resource_group: 'MyResourceGroup', service_name: 'dbbackup_to_uat_migration_service') do
  its('sku.name') { should 'Standard_1vCores' }
end
```
## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](/inspec/matchers/).

### exists
```ruby
# If a key vault is found it will exist
describe azure_db_migration_service(resource_group: 'MyResourceGroup', service_name: 'dbbackup_to_uat_migration_service') do
  it { should exist }
end

# Key vaults that aren't found will not exist
describe azure_db_migration_service(resource_group: 'MyResourceGroup', service_name: 'dbbackup_to_uat_migration_service') do
  it { should_not exist }
end
```
## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be setup with a `contributor` role on the subscription you wish to test.
