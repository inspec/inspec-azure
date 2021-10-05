---
title: About the azure_power_bi_gateways Resource
platform: azure
---

# azure_power_bi_gateways

Use the `azure_power_bi_gateways` InSpec audit resource to test the properties related to all AzurePower BI Gateways.

## Azure REST API version, Endpoint, and HTTP Client Parameters

This resource interacts with API versions supported by the resource provider. The `api_version` is defined as a resource parameter.
If not provided, the latest version is used. For more information, refer to [`azure_generic_resource`](azure_generic_resource.md).

Unless defined, `azure_cloud` global endpoint and default values for the HTTP client is used. For more information, refer to the resource pack [README](../../README.md).

## Availability

### Installation

This resource is available in the [InSpec Azure resource pack](https://github.com/inspec/inspec-azure). For an example, `inspec.yml` file and how to set up your Azure credentials, refer to resource pack [README](../../README.md#Service-Principal).

## Syntax

An `azure_power_bi_gateways` resource block returns all AzurePower BI Gateways.

```ruby
describe azure_power_bi_gateways do
  #...
end
```

## Parameters

## Properties

|Property                        | Description                                                            | Filter Criteria<superscript>*</superscript> |
|--------------------------------|------------------------------------------------------------------------|------------------|
| ids                            | List of all gateway IDs.                                               | `id`             |
| names                          | List of all the gateway names.                                         | `name`           |
| types                          | List of all the gateway types.                                         | `type`           |
| exponents                      | List of all public key exponents.                                      | `exponent`       |
| modulus                        | List of all public key modulus.                                        | `modulus`        |


<superscript>*</superscript> For information on how to use filter criteria on plural resources refer to [FilterTable usage](https://github.com/inspec/inspec/blob/master/dev-docs/filtertable-usage.md).
Also, refer to [Azure documentation](https://docs.microsoft.com/en-us/rest/api/power-bi/Gateways/get-Gateways) for other properties available.

## Examples

### Loop throughPower BI Gateways by their IDs

```ruby
azure_power_bi_gateways.ids.each do |id|
  describe azure_power_bi_gateway(gateway_id: id) do
    it { should exist }
  end
end
```

### Test to ensure all Power BI Gateways exponent is `AQAB`

```ruby
describe azure_power_bi_gateways.where(exponent: 'AQAB') do
  it { should exist }
end
```

## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](https://www.inspec.io/docs/reference/matchers/).

### exists

```ruby
# Should not exist if no Power BI Gateways are present
describe azure_power_bi_gateways do
  it { should_not exist }
end
# Should exist if the filter returns at least one Power BI Gateways
describe azure_power_bi_gateways do
  it { should exist }
end
```

## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be set up with a `Dataset.Read.All` role on the Azure Power BI Workspace you wish to test.