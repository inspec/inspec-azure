---
title: About the azure_express_route_circuits Resource
platform: azure
---

# azure_express_route_circuits

Use the `azure_express_route_circuits` InSpec audit resource to test properties of Azure ExpressRoute circuits for a resource group or the entire subscription.

## Azure Rest API Version, Endpoint, And HTTP Client Parameters

This resource interacts with API versions supported by the resource provider.
The `api_version` can be defined as a resource parameter.
If not provided, the latest version will be used.
For more information, refer to [`azure_generic_resource`](azure_generic_resource.md).

Unless defined, `azure_cloud` global endpoint, and default values for the HTTP client will be used.
For more information, refer to the resource pack [README](../../README.md).

## Availability

### Installation

This resource is available in the [InSpec Azure resource pack](https://github.com/inspec/inspec-azure).
For an example `inspec.yml` file and how to set up your Azure credentials, refer to resource pack [README](../../README.md#Service-Principal).

Also, refer to [Azure documentation](https://docs.microsoft.com/en-us/rest/api/expressroute/express-route-circuits/list) for the available properties.
Any attribute in the response may be accessed with the key names separated by dots (`.`).

## Syntax

An `azure_express_route_circuits` resource block returns all Azure ExpressRoute circuits, either within a resource group or a subscription.

```ruby
describe azure_express_route_circuits(resource_group: 'RESOURCE_GROUP') do
  #...
end
```

or

```ruby
describe azure_express_route_circuits do
  #...
end
```

## Parameters

|Property        | Description                                                                          |
|----------------|--------------------------------------------------------------------------------------|
| resource_group | The Azure resource group that the targeted resources reside in.                      |

## Properties

|Property       | Description                                                                          | Filter Criteria<superscript>*</superscript> |
|---------------|--------------------------------------------------------------------------------------|-----------------|
| names         | A list of name the resource group in which to create the ExpressRoute circuit.       | `name`          |
| ids           | A list of the ExpressRoute circuit IDs.                                              | `id`            |
| tags          | A list of `tag:value` pairs of the ExpressRoute circuit resources.                   | `tags`          |
| provisioning_states | The provisioning states of the ExpressRoute circuit resources.                 | `provisioning_state` |
| types         | The types of all the ExpressRoute circuit resources.                                 | `type`          |
| locations     | The locations of the ExpressRoute circuit resources.                                 | `location`      |
| service_provider_bandwidth_in_mbps | A list of the bandwidths in Mbps of the circuits when a circuit is provisioned on an ExpressRoutePort resource. | `service_provider_bandwidth_in_mbps` |
| service_provider_peering_locations | A list of The name of the peering location and not the Azure resource location.                                 | `service_provider_peering_location`  |
| service_provider_names             |   The name of the ExpressRoute Service Provider.                | `service_provider_name` |
| service_keys  | The ServiceKeys of the ExpressRoute circuit resources.                               | `service_key`   |
| stags         | The identifiers of the circuit traffic. Outer tag for QinQ encapsulation.            | `stag`          |
| global_reach_enabled               | A list of The ExpressRoute circuit allowGlobalReachEnable       | `global_reach_enabled` |
| gateway_manager_etags              | A list of The GatewayManager Etags in the ExpressRoute circuit resources.                                       | `gateway_manager_etag`               |
| allow_classic_operations           | A list of indicating whether "Allow Classic Operations" in the ExpressRoute circuit resources is set to `true` or `false`.  | `allow_classic_operation`|
| circuit_provisioning_states        | A list of State of express circuitHostName creation. Valid values are: `Enabled` or `Disabled`.                 | `circuit_provisioning_state`         |
| sku_names     | A list of the SKU names of the ExpressRoute circuits.                                | `sku_name`      |
| sku_tiers     | A list of the SKU tiers of the ExpressRoute circuits. Possible values are `Basic`, `Local`, `Standard`, or `Premium`.                | `sku_tier`                           |
| sku_family    | A list of the SKU families of the ExpressRoute circuits. Possible values are: `UnlimitedData` and `MeteredData`.                     | `sku_family`                         |

<superscript>*</superscript> For information on how to use filter criteria on plural resources refer to [FilterTable usage](https://github.com/inspec/inspec/blob/master/dev-docs/filtertable-usage.md).

## Examples

### Ensure that an ExpressRoute circuit has a `Succeeded` provisioning state

```ruby
describe azure_express_route_circuits(resource_group: 'RESOURCE_GROUP') do
  its('provisioning_states') { should include 'Succeeded' }
end
```

### Test than an ExpressRoute circuit has a specific location

```ruby
describe azure_express_route_circuits(resource_group: 'RESOURCE_GROUP') do
  its('location') { should include 'EXPRESS_ROUTE_CIRCUIT_LOCATION' }
end
```

## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](https://www.inspec.io/docs/reference/matchers/).

### exists

```ruby
# Should  exist if express_route_circuits are in the resource group
describe azure_express_route_circuits(resource_group: 'RESOURCE_GROUP') do
  it { should exist }
end
# Should not exist if no express_route_circuits are in the resource group
describe azure_express_route_circuits(resource_group: 'RESOURCE_GROUP') do
  it { should_not exist }
end
```
## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be setup with a `contributor` role on the subscription you wish to test.
