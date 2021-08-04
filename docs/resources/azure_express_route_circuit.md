---
title: About the azure_express_route_circuit Resource
platform: azure
---

# azure_express_route_circuit

Use the `azure_express_route_circuit` InSpec audit resource to test properties related to a express circuit resource.

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

`resource_group` and express circuit resource `name` or the `resource_id` must be given as a parameter.
```ruby
describe azure_express_route_circuit(resource_group: 'MyResourceGroup', name: 'express circuit_name') do
  it { should exist }
end
```
## Parameters

| Name                           | Description                                                                      |
|--------------------------------|----------------------------------------------------------------------------------|
| resource_group                 | The name of the resource group in which to create the ExpressRoute circuit. Changing this forces a new resource to be created. `MyResourceGroup`    |
| name                           | The name of the ExpressRoute circuit. Changing this forces a new resource to be created. `Myexpress circuitHostName`                          |
| type                           | type of express ExpressRoute circuit                                                          |
| provisioning_state             | State of express ExpressRoute circuit creation                                                |
| location             | Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created.                                              |
| service_provider_properties_bandwidth_in_mbps             | The bandwidth in Mbps of the circuit being created on the Service Provider.                                                |
| service_provider_properties_peering_location             | The name of the peering location and not the Azure resource location. Changing this forces a new resource to be created.                                              |
| service_provider_properties_name             | The name of the ExpressRoute Service Provider. Changing this forces a new resource to be created.                                                |
| service_provider_provisioning_state             | The ExpressRoute circuit provisioning state from your chosen service provider. Possible values are "NotProvisioned", "Provisioning", "Provisioned", and "Deprovisioning".                                                |
| service_key             | State of express circuitHostName creation                                                |
| stag             | The identifier of the circuit traffic. Outer tag for QinQ encapsulation.                                              |
| global_reach_enabled             | ExpressRoute circuit allowGlobalReachEnable   `boolean`                                          |
| allow_global_reach             | ExpressRoute circuit Flag denoting global reach status. `boolean`                                          |
| gateway_manager_etag             | The GatewayManager Etag.                                                |
| allow_classic_operations             | Allow classic operations. `boolean`                                                |
| circuit_provisioning_state             | State of express circuitHostName creation                                                |
| sku_name             | Name sku block for the ExpressRoute circuit as documented below.                                               |
| sku_tier             | The service tier. Possible values are Basic, Local, Standard or Premium.                                               |
| sku_family             | The billing mode for bandwidth. Possible values are MeteredData or UnlimitedData.                                             |
Both of the parameter sets should be provided for a valid query:
- `resource_group` and `circuit_name`


Also, refer to [Azure documentation](https://docs.microsoft.com/en-us/rest/api/expressroute/express-route-circuits/get) for other properties available.
Any attribute in the response may be accessed with the key names separated by dots (`.`).


## Examples

### Ensure that the express circuit resource has is from same type
```ruby
describe azure_express_route_circuit(resource_group: 'MyResourceGroup', name: 'express circuit_name') do
  its('type') { should eq 'Microsoft.Network/express circui' }
end
```
### Ensure that the express circuit resource is in successful state
```ruby
describe azure_express_route_circuit(resource_group: 'MyResourceGroup', name: 'express circuit_name') do
  its('provisioning_state') { should include('Succeeded') }
end
```

### Ensure that the express circuit resource is from same location
```ruby
describe azure_express_route_circuit(resource_group: 'MyResourceGroup', name: 'circuit_name') do
  its('location') { should include df_location }
end
```
## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](/inspec/matchers/).

### exists
```ruby
# If a express circuit resource is found it will exist
describe azure_express_route_circuit(resource_group: 'MyResourceGroup', name: 'mycircuit_name') do
  it { should exist }
  its('name') { should eq circuitName }
  its('type') { should eq 'Microsoft.Network/expressRouteCircuits' }
  its('provisioning_state') { should include('Succeeded') }
  its('location') { should include location }
  its('service_provider_properties_bandwidth_in_mbps') { should eq bandwidthInMbps }
  its('service_provider_properties_peering_location') { should include peeringLocation }
  its('service_provider_properties_name') { should include serviceProviderName }
  its('service_provider_provisioning_state') { should include serviceProviderProvisioningState }
  its('service_key') { should include serviceKey }
  its('stag') { should eq stag }
  its('global_reach_enabled') { should eq globalReachEnabled }
  its('allow_global_reach') { should eq allowGlobalReach }
  its('gateway_manager_etag') { should include gatewayManagerEtag }
  its('allow_classic_operations') { should eq allowClassicOperations }
  its('circuit_provisioning_state') { should include circuitProvisioningState }
  its('sku_name') { should include sku_name }
  its('sku_tier') { should include sku_tier }
  its('sku_family') { should include sku_family }
end

# express circuit resources that aren't found will not exist
describe azure_express_route_circuit(resource_group: 'MyResourceGroup', name: 'DoesNotExist') do
  it { should_not exist }
end
```

## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be setup with a `contributor` role on the subscription you wish to test.