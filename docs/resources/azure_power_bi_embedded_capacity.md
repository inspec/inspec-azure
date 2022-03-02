---
title: About the azure_power_bi_embedded_capacity Resource
platform: azure
---

# azure_power_bi_embedded_capacity

Use the `azure_power_bi_embedded_capacity` InSpec audit resource to test the properties related to Azure Power BI Embedded Capacity.

## Azure REST API version, Endpoint, and HTTP Client Parameters

This resource interacts with API versions supported by the resource provider. The `api_version` is defined as a resource parameter.
If not provided, the latest version is used. For more information, refer to [`azure_generic_resource`](azure_generic_resource.md).

Unless defined, `azure_cloud` global endpoint and default values for the HTTP client are used. For more information, refer to the resource pack [README](../../README.md).

## Availability

### Installation

This resource is available in the [InSpec Azure resource pack](https://github.com/inspec/inspec-azure). For an example, `inspec.yml` file and how to set up your Azure credentials, refer to resource pack [README](../../README.md#Service-Principal).

## Syntax

`name` and `resource_group` is a required parameter.

```ruby
describe azure_power_bi_embedded_capacity(resource_group: 'RESOURCE_GROUP', name: 'POWER_BI_EMBEDDED') do
  it  { should exist }
end
```

```ruby
describe azure_power_bi_embedded_capacity(resource_group: 'RESOURCE_GROUP', name: 'POWER_BI_EMBEDDED')  do
  it  { should exist }
end
```

## Parameters

| Name           | Description                                                                      |
|----------------|----------------------------------------------------------------------------------|
| name           | Name of the Power BI Embedded Capacity to test.                                  |
| resource_group | Azure Resource Group.                                                            |

The parameter set should be provided for a valid query:

- `name` and `account_name`

## Properties

| Property                   | Description                                                      |
|----------------------------|------------------------------------------------------------------|
| id                         | An identifier that represents the PowerBI Dedicated resource.    |
| location                   | Location of the PowerBI Dedicated resource.                      |
| name                       | The name of the PowerBI Dedicated resource.                      |
| properties.administration  | A collection of Dedicated capacity administrators.               |
| properties.mode            | The capacity mode.                                               |
| properties.state           | The current state of PowerBI Dedicated resource. The state is to indicate more states outside of resource provisioning.|
| sku                        | The SKU of the PowerBI Dedicated resource.                       |
| tags                       | Key-value pairs of additional resource provisioning properties.  |
| type                       | The type of the PowerBI Dedicated resource.                      |


For properties applicable to all resources, such as `type`, `name`, `id`, and `properties`, refer to [`azure_generic_resource`](azure_generic_resource.md#properties).

Also, refer to [Azure documentation](https://docs.microsoft.com/en-us/rest/api/power-bi-embedded/capacities/get-details) for other properties available.

## Examples

### Test that the Power BI Embedded Capacity

```ruby
describe azure_power_bi_embedded_capacity(resource_group: 'RESOURCE_GROUP', name: 'POWER_BI_EMBEDDED')  do
  its('count') { should eq 1.0 }
end
```

## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](/inspec/matchers/).

### exists

```ruby
# If the Power BI Embedded Capacity is found, it will exist
describe azure_power_bi_embedded_capacity(resource_group: 'RESOURCE_GROUP', name: 'POWER_BI_EMBEDDED')  do
  it { should exist }
end
# if the Power BI Embedded Capacity is not found, it will not exist
describe azure_power_bi_embedded_capacity(resource_group: 'RESOURCE_GROUP', name: 'POWER_BI_EMBEDDED')  do
  it { should_not exist }
end
```

## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be set up with a `contributor` role on the subscription you wish to test.