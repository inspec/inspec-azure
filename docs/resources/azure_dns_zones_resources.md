---
title: About the azure_dns_zones_resources Resource
platform: azure
  ---

# azure_dns_zones_resources

Use the `azure_dns_zones_resources` InSpec audit resource to test properties related to azure dns zones for a resource group or the entire subscription.

## Azure REST API version, endpoint, and HTTP client parameters

This resource interacts with API versions supported by the resource provider.
The `api_version` can be defined as a resource parameter.
If not provided, the latest version will be used.
For more information, refer to [`azure_generic_resource`](azure_generic_resource.md).

Unless defined, the `azure_cloud` global endpoint, and default values for the HTTP client will be used.
For more information, refer to the resource pack [README](../../README.md).

## Availability

### Installation

This resource is available in the [InSpec Azure resource pack](https://github.com/inspec/inspec-azure).
For an example `inspec.yml` file and how to set up your Azure credentials, refer to resource pack [README](../../README.md#Service-Principal).


Also, refer to [Azure documentation](https://docs.microsoft.com/en-us/rest/api/dns/zones/get) for  properties available.
Any attribute in the response may be accessed with the key names separated by dots (`.`).

## Syntax

An `azure_dns_zones_resources` resource block returns all Azure DNS Zones within within a resource group.

```ruby
describe azure_dns_zones_resources do
  #...
end
```

## Parameters

This resource does not accept any parameters.

## Properties

|Property       | Description                                                                         | Filter Criteria<superscript>*</superscript> |
|---------------|-------------------------------------------------------------------------------------|------------------|
| name          | A list of the unique resource names.                                                | `name`            |
| ids           | A list of dns_zones ids .                                                           | `id`              |
| tags          | A list of `tag:value` pairs defined on the resources.                               | `tags`            |
| types         | The types of all the dns_zones.                                                     | `type`            |
| properties    | properties of Azure resource group                                                  | `properties`      |
| max_number_of_recordsets   | The maximum number of records per record set that can be created in this DNS zone. | `max_number_of_recordsets` |
| number_of_record_sets| The current number of record sets in this DNS zone.                          | `number_of_record_sets` |
| name_servers | The name servers for this DNS zone.                                                  | `name_servers` |

<superscript>*</superscript> For information on how to use filter criteria on plural resources refer to [FilterTable usage](https://github.com/inspec/inspec/blob/master/dev-docs/filtertable-usage.md).


## Examples

### Test that a DNS zone has has the correct type

```ruby
describe azure_dns_zones_resources do
  its('type') { should include 'Microsoft.Network/dnszones' }
end
```
### Test that a DNS zone resource has a `Succeeded` provisioning state

```ruby
describe azure_dns_zones_resources do
  its('provisioning_states') { should include 'Succeeded' }
end
```

### Test that a DNS zone has the `global` location

```ruby
describe azure_dns_zones_resources do
  its('location') { should include 'global' }
end
```
### Test if any Azure DNS zone exists in the resource group

```ruby
describe azure_dns_zones_resources do
  it { should exist }
end
```

## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](https://www.inspec.io/docs/reference/matchers/).

### exists

Test that there aren't any Azure DNS zones in the resource group.

```ruby
describe azure_dns_zones_resources do
  it { should_not exist }
end
```

## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be setup with a `contributor` role on the subscription you wish to test.
