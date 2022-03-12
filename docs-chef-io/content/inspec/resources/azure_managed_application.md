+++
title = "azure_managed_application Resource"
platform = "azure"
draft = false
gh_repo = "inspec-azure"

[menu.inspec]
title = "azure_managed_application"
identifier = "inspec/resources/azure/azure_managed_application Resource"
parent = "inspec/resources/azure"
+++

Use the `azure_managed_application` InSpec audit resource to test properties related to an Azure managed application.

## Azure REST API Version, Endpoint, and HTTP Client Parameters

{{% inspec_azure_common_parameters %}}

## Installation

{{% inspec_azure_install %}}

## Syntax

`name`, `resource_group` is a required parameter.

```ruby
describe azure_managed_application(resource_group: 'RESOURCE_GROUP', name: 'MANAGED_APPLICATION_NAME') do
  it                                      { should exist }
  its('type')                             { should eq 'Microsoft.ServiceBus/Namespaces' }
  its('location')                         { should eq 'East US' }
end
```

```ruby
describe azure_managed_application(resource_group: 'RESOURCE_GROUP', name: 'MANAGED_APPLICATION_NAME') do
  it  { should exist }
end
```

## Parameters

`name` _(required)_
: Name of the Azure managed applications to test.

`resource_group` _(required)_
: Azure resource group that the targeted resource resides in.

## Properties

`id`
: Resource Id.

`name`
: Resource name.

`type`
: Resource type. `Microsoft.Solutions/applications`.

`location`
: Resource location.

`properties`
: The properties of the managed application.

`properties.plan`
: The plan information.

`properties.identity`
: The identity of the resource.

`properties.provisioningState`
: Provisioning state of the namespace.


For properties applicable to all resources, such as `type`, `name`, `id`, `properties`, refer to [`azure_generic_resource`]({{< relref "azure_generic_resource.md#properties" >}}).

Also, refer to [Azure documentation](https://docs.microsoft.com/en-us/rest/api/managedapplications/applications/get) for other properties available.

## Examples

**Test that the managed applications is provisioned successfully.**

```ruby
describe azure_managed_application(resource_group: 'RESOURCE_GROUP', name: 'MANAGED_APPLICATION_NAME') do
  its('properties.provisioningState') { should eq 'Succeeded' }
end
```

## Matchers

{{% inspec_matchers_link %}}

### exists

```ruby
# If a managed application is found it will exist

describe azure_managed_application(resource_group: 'RESOURCE_GROUP', name: 'MANAGED_APPLICATION_NAME') do
  it { should exist }
end
# if managed application is not found it will not exist

describe azure_managed_application(resource_group: 'RESOURCE_GROUP', name: 'MANAGED_APPLICATION_NAME') do
  it { should_not exist }
end
```

## Azure Permissions

{{% azure_permissions_service_principal role="reader" %}}
