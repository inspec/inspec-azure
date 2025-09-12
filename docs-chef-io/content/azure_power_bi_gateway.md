+++
title = "azure_power_bi_gateway resource"
platform = "azure"
draft = false
gh_repo = "inspec-azure"

[menu.azure]
title = "azure_power_bi_gateway"
identifier = "inspec/resources/azure/azure_power_bi_gateway resource"
parent = "inspec/resources/azure"
+++

Use the `azure_power_bi_gateway` InSpec audit resource to test the properties related to an Azure Power BI gateway.

## Azure REST API version, endpoint, and HTTP client parameters

{{< readfile file="content/reusable/md/inspec_azure_common_parameters.md" >}}

## Syntax

The `gateway_id` is a required parameter.

```ruby
describe azure_power_bi_gateway(gateway_id: 'GATEWAY_ID') do
  it  { should exist }
end
```

## Parameters

`gateway_id` _(required)_
: The gateway ID.

## Properties

`id`
: The gateway ID.

`name`
: The gateway name.

`type`
: The gateway type.

`publicKey.exponent`
: The public key exponent.

`publicKey.modulus`
: The public key modulus.

For properties applicable to all resources, such as `type`, `name`, `id`, and `properties`, refer to [`azure_generic_resource`](azure_generic_resource#properties).

Also, see the [Azure documentation](https://docs.microsoft.com/en-us/rest/api/power-bi/gateways/get-gateway) for other available properties.

## Examples

### Test that the Power BI gateway's exponent is 'AQAB'

```ruby
describe azure_power_bi_gateway(gateway_id: 'GATEWAY_ID')  do
  its('publicKey.exponent') { should eq 'AQAB' }
end
```

## Matchers

{{< readfile file="content/reusable/md/inspec_matchers_link.md" >}}

### exists

```ruby
# If the Azure Power BI gateway is found, it will exist.

describe azure_power_bi_gateway(gateway_id: 'GATEWAY_ID')  do
  it { should exist }
end
```

### not_exists

```ruby
# if the Azure Power BI gateway is not found, it will not exist.

describe azure_power_bi_gateway(gateway_id: 'GATEWAY_ID')  do
  it { should_not exist }
end
```

## Azure permissions

Your [service principal](https://learn.microsoft.com/en-us/entra/identity-platform/howto-create-service-principal-portal) must have the `Dataset.Read.All` role on the Azure Power BI Workspace you wish to test.
