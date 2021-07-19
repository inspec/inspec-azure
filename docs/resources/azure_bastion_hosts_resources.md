---
title: About the azure_bastion_hosts_resource Resource
platform: azure
---

# azure_bastion_hosts_resource

Use the `azure_bastion_hosts_resource` InSpec audit resource to test properties related to bastion hots for a resource group or the entire subscription.

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


Also, refer to [Azure documentation](https://docs.microsoft.com/en-us/rest/api/virtualnetwork/bastion-hosts/list) for  properties available.
Any attribute in the response may be accessed with the key names separated by dots (`.`).
## Syntax

An `azure_bastion_hosts_resource` resource block returns all Azure bastion hots, either within a Resource Group (if provided)
```ruby
describe azure_bastion_hosts_resource(resource_group: 'my-rg') do
  
end
```

## Examples

### Ensure that the bastion hosts resource has is from same type
```ruby
describe azure_bastion_hosts_resource(resource_group: 'MyResourceGroup', name: 'bastion_name') do
  its('type') { should eq 'Microsoft.Network/bastionHosts' }
end
```
### Ensure that the bastion hosts resource is in successful state
```ruby
describe azure_bastion_hosts_resource(resource_group: 'MyResourceGroup') do
  its('provisioning_states') { should include('Succeeded') }
end
```

### Ensure that the bastion hosts resource is from same location
```ruby
describe azure_bastion_hosts_resource(resource_group: 'MyResourceGroup') do
  its('location') { should include df_location }
end
```
### Test If Any bastion hots Exist in the Resource Group
```ruby
describe azure_bastion_hosts_resource(resource_group: 'MyResourceGroup') do
  it { should exist }
end
```

## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](https://www.inspec.io/docs/reference/matchers/).

### exists
```ruby
# Should not exist if no bastion hots are in the resource group
describe azure_bastion_hosts_resource(resource_group: 'MyResourceGroup') do
  it { should_not exist }
end
```
## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be setup with a `contributor` role on the subscription you wish to test.
