---
title: About the azure_power_bi_embedded_capacities Resource
platform: azure
---

## azure_power_bi_embedded_capacities

Use the `azure_power_bi_embedded_capacities` InSpec audit resource to test the properties related to all Azure Power BI Embedded Capacities within a project.

## Azure REST API version, Endpoint, and HTTP Client Parameters

This resource interacts with API versions supported by the resource provider. The `api_version` is defined as a resource parameter. If not provided, the latest version is used. For more information, refer to [`azure_generic_resource`](azure_generic_resource.md).

Unless defined, `azure_cloud` global endpoint and default values for the HTTP client are used. For more information, refer to the resource pack [README](../../README.md).

## Availability

### Installation

This resource is available in the [InSpec Azure resource pack](https://github.com/inspec/inspec-azure). For an example, `inspec.yml` file and how to set up your Azure credentials, refer to resource pack [README](../../README.md#Service-Principal).

## Syntax

An `azure_power_bi_embedded_capacities` resource block returns all Azure Power BI Embedded Capacities within a project.

```ruby
describe azure_power_bi_embedded_capacities do
  #...
end
```

## Parameters

| Name           | Description                                                                      |
|----------------|----------------------------------------------------------------------------------|
| account_name   | The Azure Storage account name.                                                  |
| dns_suffix     | The DNS suffix for the Azure Data Lake Storage endpoint.                         |

The following parameters are optional,`account_name` and `dns_suffix`.

## Properties

|Property                        | Description                                       | Filter Criteria<superscript>*</superscript> |
|--------------------|---------------------------------------------------------------|------------------|
| ids                | A list of PowerBI Dedicated resources.                        | `id`             |
| names              | The names of all the PowerBI Dedicated resource.              | `name`           |
| locations          | A location list of all the PowerBI Dedicated resource.        | `location`       |
| modes              | A list of all the capacity modes.                             | `mode`           |
| provisioningStates | A list of all provisioning states.                            |`provisioningState`|
| states             | The current state of all PowerBI Dedicated resources.         | `state`          |
| sku_names          | The SKU name of the PowerBI Dedicated resource.               | `sku_name`       |
| sku_tiers          | The SKU tier of the PowerBI Dedicated resource.               | `sku_tier`       |
| sku_capacities     | The SKU capacities of the PowerBI Dedicated resource.         | `sku_capacity`   |
| administration_members | A collection of dedicated capacity administrators.        | `administration_members` |

<superscript>*</superscript> For information on how to use filter criteria on plural resources refer to [FilterTable usage](https://github.com/inspec/inspec/blob/master/dev-docs/filtertable-usage.md). Also, refer to [Azure documentation](https://docs.microsoft.com/en-us/rest/api/power-bi-embedded/capacities/list) for other properties available.

## Examples

### Loop through Power BI Embedded Capacities by their names

```ruby
azure_power_bi_embedded_capacities.names.each do |name|
  describe azure_power_bi_embedded_capacity(resource_group: 'RESOURCE_GROUP', name: name) do
    it { should exist }
  end
end
```

### Test to ensure Power BI Embedded Capacities where sku_capacities greater than 1

```ruby
describe azure_power_bi_embedded_capacities.where(sku_capacity > 1 ) do
  it { should exist }
end
```

## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](https://www.inspec.io/docs/reference/matchers/).

### exists

```ruby
# Should exist if the filter returns at least one Migrate Assessment in the project and in the resource group
describe azure_power_bi_embedded_capacities do
  it { should exist }
end

# Should not exist if no Power BI Embedded Capacities are present in the project and in the resource group
describe azure_power_bi_embedded_capacities do
  it { should_not exist }
end
```

## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be set up with a `contributor` role on the subscription you wish to test.
