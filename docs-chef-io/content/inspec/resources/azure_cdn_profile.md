+++
title = "azure_cdn_profile Resource"
platform = "azure"
draft = false
gh_repo = "inspec-azure"

[menu.inspec]
title = "azure_cdn_profile"
identifier = "inspec/resources/azure/azure_cdn_profile Resource"
parent = "inspec/resources/azure"
+++

Use the `azure_cdn_profile` InSpec audit resource to test properties and configuration of an Azure CDN Profile.

## Azure REST API Version, Endpoint, and HTTP Client Parameters

{{% inspec_azure_common_parameters %}}

## Installation

{{% inspec_azure_install %}}

## Syntax

`resource_group` and `name` or the `resource_id` must be given as a parameter.
```ruby
describe azure_cdn_profile(resource_group: 'RESOURCE_GROUP', name: 'NAME') do
  it { should exist }
end
```
```ruby
describe azure_cdn_profile(resource_id: '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}') do
  it { should exist }
end
```

## Parameters

`resource_group`
: Azure resource group that the targeted resource resides in. `MyResourceGroup`.

`name`
: The unique name of the CDN profile name. `CDN profile name`.

`resource_id`
: The unique resource ID. `/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}`.

Either one of the parameter sets can be provided for a valid query:
- `resource_id`
- `resource_group` and `name`

## Properties

`properties.frontDoorId`
: The Id of the frontdoor.

For properties applicable to all resources, such as `type`, `name`, `id`, `properties`, refer to [`azure_generic_resource`]({{< relref "azure_generic_resource.md#properties" >}}).

Also, refer to [Azure documentation](https://docs.microsoft.com/en-us/rest/api/cdn/profiles/get#profile) for other properties available.
Any attribute in the response may be accessed with the key names separated by dots (`.`).

## Examples

**Test if a profile has Any Inbound Nat Rules.**

```ruby
describe azure_cdn_profile(resource_group: 'RESOURCE_GROUP', name: 'NAME') do
  its('properties.resourceState') { should eq 'Active' }
end
```

**Loop through All CDN profiles in a Subscription via `resource_id`.**

```ruby
azure_cdn_profiles.ids.each do |id|
    describe azure_cdn_profile(resource_id: id) do
      its('properties.resourceState') { should eq 'Active' }
    end
end 
```

## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](https://docs.chef.io/inspec/matchers/).

### exists

```ruby
# If we expect the resource to always exist

describe azure_cdn_profile(resource_group: 'RESOURCE_GROUP', name: 'NAME') do
  it { should exist }
end

# If we expect the resource to never exist

describe azure_cdn_profile(resource_group: 'RESOURCE_GROUP', name: 'NAME') do
  it { should_not exist }
end
```

## Azure Permissions

{{% azure_permissions_service_principal role="reader" %}}
