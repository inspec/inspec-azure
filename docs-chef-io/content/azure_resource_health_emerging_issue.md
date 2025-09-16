+++
title = "azure_resource_health_emerging_issue resource"

draft = false


[menu.azure]
title = "azure_resource_health_emerging_issue"
identifier = "inspec/resources/azure/azure_resource_health_emerging_issue resource"
parent = "inspec/resources/azure"
+++

Use the `azure_resource_health_emerging_issue` InSpec audit resource to test the properties related to an Azure Resource Health Emerging issue.

## Azure REST API version, endpoint, and HTTP client parameters

{{< readfile file="content/reusable/md/inspec_azure_common_parameters.md" >}}

## Syntax

`name` is a required parameter.

```ruby
describe azure_resource_health_emerging_issue(name: 'EMERGING_ISSUE_NAME') do
  it                                      { should exist }
  its('properties.statusActiveEvents') { should be_empty }
end
```

```ruby
describe azure_resource_health_emerging_issue(name: 'EMERGING_ISSUE_NAME') do
  it  { should exist }
end
```

## Parameters

`name`
: Name of the Azure Resource Health emerging issue to test.

## Properties

`id`
: Fully qualified resource ID for the resource.

`name`
: The name of the resource.

`type`
: The type of resource.

`properties.statusActiveEvents`
: The list of emerging issues of the active event type.

`properties.statusBanners`
: The list of emerging issues of banner type.

`properties.refreshTimestamp`
: Timestamp for when last time refreshed for ongoing emerging issue.

For properties applicable to all resources, such as `type`, `name`, `id`, and `properties`, refer to [`azure_generic_resource`](azure_generic_resource#properties).

Also, see the [Azure documentation](https://docs.microsoft.com/en-us/rest/api/resourcehealth/emerging-issues/get) for other available properties.
You can access any attribute in the response with the key names separated by dots (`.`).

## Examples

Test that there are emerging issues with an active event type:

```ruby
describe azure_resource_health_emerging_issue(name: 'default') do
  its('properties.statusActiveEvents') { should_not be_empty }
end
```

## Matchers

{{< readfile file="content/reusable/md/inspec_matchers_link.md" >}}

### exists

```ruby
# If an emerging issue is found, it will exist.
describe azure_resource_health_emerging_issue(name: 'default') do
  it { should exist }
end
```

### not_exists

```ruby
# If no emerging issues are found, it will not exist.
describe azure_resource_health_emerging_issue(name: 'default') do
  it { should_not exist }
end
```

## Azure permissions

{{% inspec-azure/azure_permissions_service_principal role="contributor" %}}
