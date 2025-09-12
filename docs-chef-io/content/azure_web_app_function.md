+++
title = "azure_web_app_function resource"
platform = "azure"
draft = false
gh_repo = "inspec-azure"

[menu.azure]
title = "azure_web_app_function"
identifier = "inspec/resources/azure/azure_web_app_function resource"
parent = "inspec/resources/azure"
+++

Use the `azure_web_app_function` InSpec audit resource to test the properties related to an Azure function.

## Azure REST API version, endpoint, and HTTP client parameters

{{< readfile file="content/reusable/md/inspec_azure_common_parameters.md" >}}

## Syntax

`resource_group` and `site_name` and `function_name` or the `resource_id` are required parameters.

```ruby
describe azure_web_app_function(resource_group: resource_group, site_name: site_name, function_name: function_name) do
  it                                      { should exist }
  its('name')                             { should cmp "#{site_name}/#{function_name}" }
  its('type')                             { should cmp 'Microsoft.Web/sites/functions' }
  its('properties.name')                  { should cmp function_name }
  its('properties.language')              { should cmp 'Javascript' }
end
```

```ruby
describe azure_web_app_function(resource_id: '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.Web/sites/{siteName}/functions/{functionName}') do
  it            { should exist }
end
```

## Parameters

`resource_group`
: Azure resource group where the targeted resource resides.

`name`
: Name of the Azure function app to test. `FunctionApp`.

`site_name`
: Name of the Azure function app to test (for backward compatibility). `FunctionApp`.

`function_name`
: Name of the Azure function to test `Function`.

`resource_id`
: The unique resource ID. `/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.Web/sites/{siteName}/functions/{functionName}`.

Either one of the parameter sets can be provided for a valid query:

- `resource_id`
- `resource_group` and `name` and `function_name`
- `resource_group` and `site_name` and `function_name`

## Properties

`config_href`
: Config URI.

`function_app_id`
: Function app ID.

`language`
: The function language.

`isDisabled`
: Gets or sets a value indicating whether the function is disabled.

For properties applicable to all resources, such as `type`, `name`, `id`, and `properties`, refer to [`azure_generic_resource`](azure_generic_resource#properties).

Also, see the [Azure documentation](https://docs.microsoft.com/en-us/rest/api/appservice/webapps/getfunction#functionenvelope) for other available properties. You can access any attribute in the response with the key names separated by dots (`.`).

## Examples

```ruby
describe azure_web_app_function(resource_group: 'RESOURCE_GROUP', site_name: 'functions-http', function_name: 'HttpTrigger1') do
  its('properties.language') { should eq 'Javascript' }
end
```

```ruby
describe azure_web_app_function(resource_group: 'RESOURCE_GROUP', site_name: 'functions-http', function_name: 'HttpTrigger1') do
  its('properties.isDisabled') { should be_false }
end
```

## Matchers

{{< readfile file="content/reusable/md/inspec_matchers_link.md" >}}

### exists

```ruby
# If a key vault is found, it will exist.

describe azure_web_app_function(resource_group: 'RESOURCE_GROUP', site_name: 'functions-http', function_name: 'HttpTrigger1') do
  it { should exist }
end
```

### not_exists

```ruby
# Key vaults that are not found, will not exist.

describe azure_web_app_function(resource_group: 'RESOURCE_GROUP', site_name: 'functions-http', function_name: 'HttpTrigger1') do
  it { should_not exist }
end
```

## Azure permissions

{{% inspec-azure/azure_permissions_service_principal role="contributor" %}}
