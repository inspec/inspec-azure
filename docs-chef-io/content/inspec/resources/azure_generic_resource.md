+++
title = "azure_generic_resource Resource"
platform = "azure"
draft = false
gh_repo = "inspec-azure"

[menu.inspec]
title = "azure_generic_resource"
identifier = "inspec/resources/azure/azure_generic_resource Resource"
parent = "inspec/resources/azure"
+++

Use the `azure_generic_resource` Inspec audit resource to test any valid Azure resource available through Azure Resource Manager.

## Installation

{{% inspec_azure_install %}}

## Syntax

```ruby
describe azure_generic_resource(resource_group: 'RESOURCE_GROUP', name: 'RESOURCE_GROUP_NAME') do
  its('property') { should eq 'value' }
end
```

> Where
>
> - Resource parameters are used to query the Azure Resource Manager endpoint for the resource to be tested.
> - `property` is the generic resource that dynamically creates the properties on the fly based on the resource type targeted.
> - `value` is the expected output from the chosen property.

## Parameters

The following parameters can be passed for targeting a specific Azure resource.

`resource_group`
: Azure resource group where the targeted resource has been created.

`name`
: Name of the Azure resource to test.

`resource_provider`
: Azure resource provider of the resource to be tested. `Microsoft.Compute/virtualMachines`.

`resource_path`
: Relative path to the resource if it is defined on another resource. The resource path of a subnet in a virtual network would be `{virtualNetworkName}/subnets`.

`resource_id`
: Unique ID of Azure resource to be tested. `/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.Compute/virtualMachines/{vmName}`.

`resource_uri`
: Azure REST API URI of the resource to be tested. This parameter should be used when a resource does not reside in a resource group. It requires `add_subscription_id` and `name` parameters to be provided together. `/providers/Microsoft.Authorization/policyDefinitions/`.

`add_subscription_id`
: Indicates whether the `resource_uri` contains the subscription id. Valid values are`true` or `false`.

`tag_name<superscript>*</superscript>`
: Tag name defined on the Azure resource. `name`.

`tag_value`
: Tag value of the tag defined with the `tag_name`. `external_linux`.

`api_version`
: API version to use when interrogating the resource. If not set or the resource provider does not support the provided API version, then the latest version for the resource provider is used. Valid values are `2017-10-9`, `latest`, `default`.

<superscript>*</superscript> When resources are filtered by a tag name and value, the tags for each resource are not returned in the results.

Either one of the parameter sets can be provided for a valid query:

- `resource_id`
- `resource_group` and `name`
- `name`
- `resource_group`, `resource_provider` and `name`
- `resource_group`, `resource_provider`, `resource_path` and `name`
- `add_subscription_id`, `resource_uri` and `name`
- `tag_name` and `tag_value`.

Different parameter combinations can be tried. If it is not supported, the InSpec resource or the Azure Rest API raises an error.

If the Azure Resource Manager endpoint returns multiple resources for a given query, this singular generic resource fails. In that case, the [plural generic resource]({{< relref "azure_generic_resources.md" >}}) should be used.

## Properties

The properties that can be tested are dependent on the Azure Resource that is tested. Check their API pages to see what properties can be tested. For example, for virtual machines, see [here](https://docs.microsoft.com/en-us/rest/api/compute/virtualmachines/get).

Also, the [Azure Resources Portal](https://resources.azure.com) can be used to select the resource you are interested in and see what can be tested.

The following properties apply to almost all resources.

`id`
: The unique resource identifier.

`name`
: The name of the resource.

`type`
: The resource type.

`location`
: The location of the resource.

`tags`
: The tag `key:value pairs` if defined on the resource.

`properties`
: The resource properties.

For more properties, refer to specific Azure documents for the tested resource.

## Examples

### Test to ensure properties of a virtual machine and the Endpoint API Version

```ruby
describe azure_generic_resource(resource_group: 'RESOURCE_GROUP', name: 'RESOURCE_GROUP_NAME) do
  its('properties.storageProfile.osDisk.osType') { should cmp 'Linux' }
  its('properties.storageProfile.osDisk.createOption') { should cmp 'FromImage' }
  its('properties.storageProfile.osDisk.name') { should cmp 'linux-external-osdisk' }
  its('properties.storageProfile.osDisk.caching') { should cmp 'ReadWrite' }

  its('api_version_used_for_query_state') { should eq 'latest' }
end
```

### Test to ensure that the API Version is used for the query

```ruby
describe azure_generic_resource(resource_id: '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.Compute/virtualMachines/{vmName}', api_version: '2017-01-01') do
  its('api_version_used_for_query_state') { should eq 'user_provided' }
  its('api_version_used_for_query') { should eq '2017-01-01' }
end
```

### Test to ensure that the tags include specific values

```ruby
describe azure_generic_resource(resource_group: 'RESOURCE_GROUP', name: 'RESOURCE_GROUP_NAME') do
  its('tags') { should include(name: 'MyVM') }

The tag key name can be tested in **String** or **Symbol** regardless of the values.

end
```

### Test to ensure properties of a virtual machine resides in an Azure development test Lab

```ruby
describe azure_generic_resource(resource_provider: 'Microsoft.DevTestLab/labs', resource_path: '{labName}/virtualmachines', resource_group: 'my_group', name: 'my_VM') do
  its('properties.userName') { should cmp 'admin' }
  its('properties.allowClaim') { should cmp false }
end
```

### Test to ensure a resource group

```ruby
describe azure_generic_resource(add_subscription_id: true, resource_uri: '/resourcegroups/', name: 'RESOURCE_GROUP') do
  it { should exist }
  its('tags') { should include(:owner) }
  its('tags') { should include(owner: 'John Doe') }
end
```

### Test to ensure a policy definition

```ruby
describe azure_generic_resource(add_subscription_id: true, resource_uri: 'providers/Microsoft.Authorization/policyDefinitions', name: 'my_policy') do
  it { should exist }
  its('properties.policyRule.then.effect') { should cmp 'deny' }
  its('properties.policyType') { should cmp 'Custom' }
end
```

For more examples, please see the [integration tests](/test/integration/verify/controls/azure_generic_resource.rb).

## Matchers

{{% inspec_matchers_link %}}

### Exists

```ruby
# Should not exist if there is no resource with a given name

describe azure_generic_resource(name: 'NAME') do
  it { should_not exist }
end
```

### Not Exists

```ruby
# Should exist if there is one resource with a given name

describe azure_generic_resource(name: 'a_very_unique_name_within_subscription') do
  it { should exist }
end
```

## Azure Permissions

{{% azure_permissions_service_principal role="contributor" %}}
