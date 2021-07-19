---
title: About the azure_bastion_hosts_resource Resource
platform: azure
---

# azure_bastion_hosts_resource

Use the `azure_bastion_hosts_resource` InSpec audit resource to test properties related to a bastion hosts resource.

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

`resource_group` and bastion hosts resource `name` or the `resource_id` must be given as a parameter.
```ruby
describe azure_bastion_hosts_resource(resource_group: 'MyResourceGroup', name: 'bastion_name') do
  it { should exist }
end
```
## Parameters

| Name                           | Description                                                                      |
|--------------------------------|----------------------------------------------------------------------------------|
| resource_group                 | Azure resource group that the targeted resource resides in. `MyResourceGroup`    |
| name                           | Name of the Azure resource to test. `MyBastionHostName`                          |
| type                           | type of BastionHostName                                                          |
| provisioning_state             | State of BastionHostName creation                                                |

Either one of the parameter sets can be provided for a valid query:
- `resource_group` and `name`


Also, refer to [Azure documentation](https://docs.microsoft.com/en-us/rest/api/virtualnetwork/bastion-hosts/get) for other properties available. 
Any attribute in the response may be accessed with the key names separated by dots (`.`).


## Examples

### Ensure that the bastion hosts resource has is from same type
```ruby
describe azure_bastion_hosts_resource(resource_group: 'MyResourceGroup', name: 'bastion_name') do
  its('type') { should eq 'Microsoft.Network/bastionHosts' }
end
```
### Ensure that the bastion hosts resource is in successful state
```ruby
describe azure_bastion_hosts_resource(resource_group: 'MyResourceGroup', name: 'bastion_name') do
  its('provisioning_state') { should include('Succeeded') }
end
```

### Ensure that the bastion hosts resource is from same location
```ruby
describe azure_bastion_hosts_resource(resource_group: 'MyResourceGroup', name: 'bastion_name') do
  its('location') { should include df_location }
end
```
## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](/inspec/matchers/).

### exists
```ruby
# If a bastion hosts resource is found it will exist
describe azure_bastion_hosts_resource(resource_group: 'MyResourceGroup', name: 'MyBastionHostName') do
  it { should exist }
end

# bastion hosts resources that aren't found will not exist
describe azure_bastion_hosts_resource(resource_group: 'MyResourceGroup', name: 'DoesNotExist') do
  it { should_not exist }
end
```

## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be setup with a `contributor` role on the subscription you wish to test.
