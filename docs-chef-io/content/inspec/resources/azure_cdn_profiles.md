+++
title = "azure_cdn_profiles Resource"
platform = "azure"
draft = false
gh_repo = "inspec-azure"

[menu.inspec]
title = "azure_cdn_profiles"
identifier = "inspec/resources/azure/azure_cdn_profiles Resource"
parent = "inspec/resources/azure"
+++

Use the `azure_cdn_profiles` InSpec audit resource to test properties and configuration of Azure CDN Profiles.

## Azure REST API Version, Endpoint, and HTTP Client Parameters

{{% inspec_azure_common_parameters %}}

## Installation

{{% inspec_azure_install %}}

## Syntax

An `azure_cdn_profiles` resource block returns all Azure CDN Profiles, either within a Resource Group (if provided), or within an entire Subscription.
```ruby
describe azure_cdn_profiles do
  #...
end
```
or
```ruby
describe azure_cdn_profiles(resource_group: 'RESOURCE_GROUP') do
  #...
end
```

## Parameters

`resource_group` _(optional)_

: The name of the resource group.

## Properties

`ids`
: A list of the unique resource ids.

: **Field**: `id`

`locations`
: A list of locations for all the resources being interrogated.

: **Field**: `location`

`names`
: A list of names of all the resources being interrogated.

: **Field**: `name`

`tags`
: A list of `tag:value` pairs defined on the resources being interrogated.

: **Field**: `tags`

`types`
: A list of the types of resources being interrogated.

: **Field**: `type`

`properties`
: A list of properties for all the resources being interrogated.

: **Field**: `properties`

`skus`
: A list of the SKUs of the resources being interrogated.

: **Field**: `sku`

{{% inspec_filter_table %}}

## Examples

**Check CDN Profiles are Present.**

````ruby
describe azure_cdn_profiles do
    it            { should exist }
    its('names')  { should include 'my-cdn-profile' }
end
````

**Filter the Results to Include Only those with Names Match the Given String Value.**

```ruby
describe azure_cdn_profiles.where{ name.eql?('cdn-prod') } do
  it { should exist }
end
```

**Filter the Results to Include Only those with Location Match the Given String Value.**

```ruby
describe azure_cdn_profiles.where{ location.eql?('eastus-2') } do
  it { should exist }
end
```

## Matchers

{{% inspec_matchers_link %}}

### exists

The control will pass if the filter returns at least one result. Use `should_not` if you expect zero matches.
```ruby
# If we expect Resource Group to have CDN Profiles
describe azure_cdn_profiles(resource_group: 'RESOURCE_GROUP') do
  it { should exist }
end

# If we expect Resource Group to not have CDN Profiles
describe azure_cdn_profiles(resource_group: 'RESOURCE_GROUP') do
  it { should_not exist }
end
```

## Azure Permissions

{{% azure_permissions_service_principal role="reader" %}}
