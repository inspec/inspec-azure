---
title: About the azure_express_route_circuits Resource
platform: azure
---

# azure_express_route_circuits

Use the `azure_express_route_circuits` InSpec audit resource to test properties related to express_route_circuits for a resource group or the entire subscription.

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


Also, refer to [Azure documentation](https://docs.microsoft.com/en-us/rest/api/expressroute/express-route-circuits/list) for  properties available.
Any attribute in the response may be accessed with the key names separated by dots (`.`).
## Syntax

An `azure_express_route_circuits` resource block returns all Azure express route circuits, either within a Resource Group (if provided)
```ruby
describe azure_express_route_circuits(resource_group: 'my-rg') do
  
end
```

## Properties

|Property       | Description                                                                          | Filter Criteria<superscript>*</superscript> |
|---------------|--------------------------------------------------------------------------------------|-----------------|
| names          | A list of name  the resource group in which to create the ExpressRoute circuit. Changing this forces a new resource to be created. `MyResourceGroup`                                                 | `name`            |
| ids            | A list of id the ExpressRoute circuit. Changing this forces a new resource to be created. `Myexpress circuitHostName                                                       | `id`              |
| tags           | A list of `tag:value` pairs defined on the resources.                               | `tags`             |
| provisioning_states             | State of express_route_circuits creation                                      | `provisioning_state`         |
| types             |   Types of all the express_route_circuits | `type` |
| locations           | Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created.                                                 | `location`            |
| service_provider_bandwidth_in_mbps            | A list of The bandwidth in Mbps of the circuit being created on the Service Provider.                                                        | `service_provider_bandwidth_in_mbps`              |
| service_provider_peering_locations           | A list of The name of the peering location and not the Azure resource location. Changing this forces a new resource to be created.                               | `service_provider_peering_location`             |
| service_provider_names             |   The name of the ExpressRoute Service Provider. Changing this forces a new resource to be created.   | `service_provider_name` |
| service_keys            | State of express circuitHostName creation                                                              | `service_key`              |
| stags           | The identifier of the circuit traffic. Outer tag for QinQ encapsulation.                         `Number` | `stag`             |
| global_reach_enabled             | A list of The ExpressRoute circuit allowGlobalReachEnable   `boolean`                                   `boolean`| `global_reach_enabled`         |
| gateway_manager_etags           | A list of The GatewayManager Etag.                                              | `gateway_manager_etag`            |
| allow_classic_operations            | A list of Allow classic operations. `boolean`                                                     | `allow_classic_operation`            |
| circuit_provisioning_states           | A list of State of express circuitHostName creation              `Enabled` or `Disabled`                |     `circuit_provisioning_state`         |
| sku_names             | A List of Name sku block for the ExpressRoute circuit as documented below.                                      | `sku_name`         |
| sku_tiers             | A List of  The service tier. Possible values are Basic, Local, Standard or Premium.      | `sku_tier` |
| sku_family             | A List of  The billing mode for bandwidth. Possible values are MeteredData or UnlimitedData. | `sku_family` |
<superscript>*</superscript> For information on how to use filter criteria on plural resources refer to [FilterTable usage](https://github.com/inspec/inspec/blob/master/dev-docs/filtertable-usage.md).


## Examples

### Ensure that the express_route_circuits resource is in successful state
```ruby
describe azure_express_route_circuits(resource_group: 'MyResourceGroup') do
  its('provisioning_states') { should include('Succeeded') }
end
```

### Ensure that the express_route_circuits resource is from same location
```ruby
describe azure_express_route_circuits(resource_group: 'MyResourceGroup') do
  its('location') { should include df_location }
end
```

## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](https://www.inspec.io/docs/reference/matchers/).
```ruby
describe azure_express_route_circuits(resource_group: 'MyResourceGroup') do
  its('names') { should include circuitName }
  its('locations') { should include location }
  its('types') { should include 'Microsoft.Network/expressRouteCircuits' }
  its('provisioning_states') { should include('Succeeded') }
  its('service_provider_properties_bandwidth_in_mbps') { should include bandwidthInMbps }
  its('service_provider_properties_peering_locations') { should include peeringLocation }
  its('service_provider_properties_names') { should include serviceProviderName }
  its('service_provider_provisioning_states') { should include serviceProviderProvisioningState }
  its('service_keys') { should include serviceKey }
  its('stags') { should include stag }
  its('global_reach_enabled') { should include globalReachEnabled }
  its('allow_global_reach') { should include allowGlobalReach }
  its('gateway_manager_etags') { should include gatewayManagerEtag }
  its('allow_classic_operations') { should include allowClassicOperations }
  its('circuit_provisioning_states') { should include circuitProvisioningState }
  its('sku_names') { should include sku_name }
  its('sku_tiers') { should include sku_tier }
  its('sku_families') { should include sku_family }
end
```


### exists
```ruby
# Should  exist if express_route_circuits are in the resource group
describe azure_express_route_circuits(resource_group: 'MyResourceGroup') do
  it { should exist }
end
# Should not exist if no express_route_circuits are in the resource group
describe azure_express_route_circuits(resource_group: 'MyResourceGroup') do
  it { should_not exist }
end
```
## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be setup with a `contributor` role on the subscription you wish to test.