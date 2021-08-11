---
title: About the azure_express_route_circuit_connections_resources Resource
platform: azure
---

# azure_express_route_circuit_connections_resources

Use the `azure_express_route_circuit_connections_resources` InSpec audit resource to test properties related to express_route_circuits for a resource group or the entire subscription.

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


Also, refer to [Azure documentation](https://docs.microsoft.com/en-us/rest/api/expressroute/express-route-circuit-connections/list) for  properties available.
Any attribute in the response may be accessed with the key names separated by dots (`.`).
## Syntax

An `azure_express_route_circuit_connections_resources` resource block returns all Azure express route circuits, either within a Resource Group (if provided)
```ruby
describe azure_express_route_circuit_connections_resources(resource_group: 'rg', circuit_name: 'cn', peering_name: 'pn') do
  
end
```
## Parameters

| Name                           | Description                                                                      |
|--------------------------------|----------------------------------------------------------------------------------|
| resource_group                 | Azure resource group that the targeted resource resides in. `MyResourceGroup`     |
| circuit_name                           | The name of the express route circuit to test. `circuit_name`                                 |
| peering_name                           | Name of the peering to test. `peering_name`                                 |


All of the parameter sets should be provided for a valid query:
- `resource_group`, `circuit_name`, `peering_name`

## Properties

|Property       | Description                                                                          | Filter Criteria<superscript>*</superscript> |
|---------------|--------------------------------------------------------------------------------------|-----------------|
| names          | A list of name  the resource group in which to create the ExpressRoute circuit. Changing this forces a new resource to be created. `MyResourceGroup`                                                 | `name`            |
| ids            | A list of id the ExpressRoute circuit. Changing this forces a new resource to be created. `Myexpress circuitHostName                                                       | `id`              |
| tags           | A list of `tag:value` pairs defined on the resources.                               | `tags`             |
| provisioning_states             | State of express_route_circuits creation                                      | `provisioning_state`         |
| types             |   Types of all the express_route_circuits | `type` |
| locations           | Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created.                                                 | `location`            |
| circuit_connection_status| Express Route Circuit connection state. | `circuit_connection_status`|
| ipv6_circuit_connection_config_status |IPv6 Address PrefixProperties of the express route circuit connection.| `ipv6_circuit_connection_config_status` |
| properties| The properties of Resource. | `properties` |
<superscript>*</superscript> For information on how to use filter criteria on plural resources refer to [FilterTable usage](https://github.com/inspec/inspec/blob/master/dev-docs/filtertable-usage.md).


## Examples

### Ensure that the express_route_circuits resource is in successful state
```ruby
describe azure_express_route_circuit_connections_resources(resource_group: 'rg', circuit_name: 'cn', peering_name: 'pn') do
  its('provisioning_states') { should include('Succeeded') }
end
```

### Ensure that the express_route_circuits resource is from same location
```ruby
describe azure_express_route_circuit_connections_resources(resource_group: 'rg', circuit_name: 'cn', peering_name: 'pn') do
  its('location') { should include df_location }
end
```

## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](https://www.inspec.io/docs/reference/matchers/).
```ruby
describe azure_express_route_circuit_connections_resources(resource_group: 'rg', circuit_name: 'cn', peering_name: 'pn') do
  its('names') { should include circuitName }
  its('locations') { should include location }
  its('types') { should include 'Microsoft.Network/expressRouteCircuits' }
  its('provisioning_states') { should include('Succeeded') }
  its('circuit_connection_status') { should include('Connected') }
  its('ipv6_circuit_connection_config_status') { should include('Connected') }
end
```


### exists
```ruby
# Should  exist if express_route_circuits are in the resource group
describe azure_express_route_circuit_connections_resources(resource_group: 'rg', circuit_name: 'cn', peering_name: 'pn') do
  it { should exist }
end
# Should not exist if no express_route_circuits are in the resource group
describe azure_express_route_circuit_connections_resources(resource_group: 'rg', circuit_name: 'cn', peering_name: 'should_not_exist') do
  it { should_not exist }
end
```
## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be setup with a `contributor` role on the subscription you wish to test.