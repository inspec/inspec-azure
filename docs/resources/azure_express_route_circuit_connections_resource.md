---
title: About the azure_express_route_circuit_connections_resource Resource
platform: azure
---

# azure_express_route_circuit_connections_resource

Use the `azure_express_route_circuit_connections_resource` InSpec audit resource to test properties related to a express circuit resource.

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



Also, refer to [Azure documentation](https://docs.microsoft.com/en-us/rest/api/expressroute/express-route-circuit-connections/get) for  properties available.
Any attribute in the response may be accessed with the key names separated by dots (`.`).
## Syntax

```ruby
describe azure_express_route_circuit_connections_resource(resource_group: 'example', circuit_name: 'cn', peering_name: 'pn', connection_name: 'cn') do
  it { should exist }
end
```
## Parameters

| Name                           | Description                                                                      |
|--------------------------------|----------------------------------------------------------------------------------|
| resource_group                 | Azure resource group that the targeted resource resides in. `MyResourceGroup`     |
| circuit_name                           | Name of the Express route circuit to test. `circuit_name`                                 |
| peering_name                           | Name of the peering to test. `peering_name`                                 |
| connection_name                           | The name of the express route circuit connection. `connection_name`                                 |

All of the parameter sets should be provided for a valid query:
- `resource_group`, `circuit_name`, `peering_name`, `connection_name`

## Properties

| Name                           | Description                                                                      |
|--------------------------------|----------------------------------------------------------------------------------|
| resource_group                 | The name of the resource group in which to create the ExpressRoute circuit. Changing this forces a new resource to be created. `MyResourceGroup`    |
| name                           | The name of the ExpressRoute circuit. Changing this forces a new resource to be created. `Myexpress circuitHostName`                          |
| type                           | type of express ExpressRoute circuit                                                          |
| provisioning_state             | State of express ExpressRoute circuit creation                                                |
| location             | Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created.                                              | 
| circuit_connection_status  | Express Route Circuit connection state. |
| ipv6_circuit_connection_config_status | IPv6 Address PrefixProperties of the express route circuit connection i.e Express Route Circuit connection state. |


Also, refer to [Azure documentation](https://docs.microsoft.com/en-us/rest/api/expressroute/express-route-circuits/get) for other properties available.
Any attribute in the response may be accessed with the key names separated by dots (`.`).


## Examples

### Ensure that the express circuit resource has is from same type
```ruby
describe azure_express_route_circuit_connections_resource(resource_group: 'example', circuit_name: 'cn', peering_name: 'pn', connection_name: 'cn') do
  its('type') { should eq 'Microsoft.Network/expressRouteCircuits' }
end
```
### Ensure that the express circuit resource is in successful state
```ruby
describe azure_express_route_circuit_connections_resource(resource_group: 'example', circuit_name: 'cn', peering_name: 'pn', connection_name: 'cn') do
  its('provisioning_state') { should include('Succeeded') }
end
```

### Ensure that the express circuit resource is from same location
```ruby
describe azure_express_route_circuit_connections_resource(resource_group: 'example', circuit_name: 'cn', peering_name: 'pn', connection_name: 'cn') do
  its('location') { should include df_location }
end
```
## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](/inspec/matchers/).
```ruby
describe azure_express_route_circuit_connections_resource(resource_group: 'example', circuit_name: 'cn', peering_name: 'pn', connection_name: 'cn') do
  its('provisioning_state') { should eq 'Succeeded' }
  its('ipv6_circuit_connection_config_status') { should eq 'Connected' }
  its('circuit_connection_status') { should eq 'Connected' }
end
```

### exists
```ruby
# If a express circuit resource is found it will exist
describe azure_express_route_circuit_connections_resource(resource_group: 'example', circuit_name: 'cn', peering_name: 'pn', connection_name: 'cn') do
  it { should exist }
end

# express circuit resources that aren't found will not exist
describe azure_express_route_circuit_connections_resource(resource_group: 'example', circuit_name: 'cn', peering_name: 'pn', connection_name: 'does_not_exist') do
  it { should_not exist }
end
```

## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be setup with a `contributor` role on the subscription you wish to test.