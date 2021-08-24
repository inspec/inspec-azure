---
title: About the azure_webapp Resource
platform: azure
---

# azure_webapp

Use the `azure_webapp` InSpec audit resource to test properties and configuration of an Azure webapp.

## Azure REST API Version, Endpoint, and HTTP Client Parameters

This resource interacts with API versions supported by the resource provider.
The `api_version` can be defined as a resource parameter.
If not provided, the latest version will be used.
For more information, refer to [`azure_generic_resource`](azure_generic_resource.md).

Unless defined, `azure_cloud` global endpoint and default values for the HTTP client will be used.
For more information, refer to the resource pack [README](../../README.md).

## Availability

### Installation

This resource is available in the [InSpec Azure resource pack](https://github.com/inspec/inspec-azure). 
For an example `inspec.yml` file and how to set up your Azure credentials, refer to resource pack [README](../../README.md#Service-Principal).

## Syntax

`resource_group` and `name` or the `resource_id` must be given as a parameter.
```ruby
describe azure_webapp(resource_group: 'inspec-rg', name: 'my_app') do
  it { should exist }
end
```
```ruby
describe azure_webapp(resource_id: '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/sites/{name}') do
  it { should exist }
end
```
## Parameters

| Name                                  | Description                                                                       |
|---------------------------------------|-----------------------------------------------------------------------------------|
| resource_group                        | Azure resource group that the targeted resource resides in. `MyResourceGroup`     |
| name                                  | Name of the webapp to test. `my_webapp`                                    |
| resource_id                           | The unique resource ID. `/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/sites/{name}` |
| auth_settings_api_version             | The endpoint api version for the `auth_settings` property. The latest version will be used unless provided. |
| configuration_api_version             | The endpoint api version for the `configuration` property. The latest version will be used unless provided. |
| supported_stacks_api_version          | The endpoint api version for the `supported_stacks` property. The latest version will be used unless provided. |

Either one of the parameter sets can be provided for a valid query along with the optional ones:
- `resource_id`
- `resource_group` and `name`

## Properties

| Property          | Description |
|-------------------|-------------|
| auth_settings     | Authentication/Authorization settings of the interrogated app with [these](https://docs.microsoft.com/en-us/rest/api/appservice/webapps/getauthsettings#siteauthsettings) properties. |
| configuration     | Configuration of an app, such as platform version, default documents, virtual applications, always on, etc. For more see [here](https://docs.microsoft.com/en-us/rest/api/appservice/webapps/getconfiguration#siteconfigresource). |
| supported_stacks  | Available application frameworks and their versions with [these](https://docs.microsoft.com/en-us/rest/api/appservice/provider/getavailablestacks#applicationstackcollection) properties. |

For properties applicable to all resources, such as `type`, `name`, `id`, `properties`, refer to [`azure_generic_resource`](azure_generic_resource.md#properties).

Also, refer to [Azure documentation](https://docs.microsoft.com/en-us/rest/api/appservice/webapps/get#site) for other properties available. 
Any attribute in the response may be accessed with the key names separated by dots (`.`), eg. `properties.<attribute>`.

## Examples

### Test that a Resource Group has the Specified Webapp and Verify it's Authentication Settings and Platform-specific Security Token Storing are Enabled 
```ruby
describe azure_webapp(resource_group: 'example', name: 'webapp_name') do
  it { should exist }
  its('auth_settings.properties') { should have_attributes(enabled: true ) }
  its('configuration.properties') { should have_attributes(tokenStoreEnabled: true) }
end
```

## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](https://www.inspec.io/docs/reference/matchers/).

### Test Webapp to Ensure it's Using the Latest Supported Version of .NET
```ruby
describe azure_webapp(resource_group: 'example', name: 'webapp_name') do
  it { should be_using_latest('aspnet') }
end
```    
### Test Webapp to Ensure it's Using the Latest Supported Version of Python
```ruby
describe azure_webapp(resource_group: 'example', name: 'webapp_name') do
  it { should be_using_latest('python') }
end
```  
### exists
```ruby
# If we expect a resource to always exist
describe azure_webapp(resource_group: 'inspec-rg', name: 'webapp_name') do
  it { should exist }
end
# If we expect a resource to never exist
describe azure_webapp(resource_group: 'inspec-rg', name: 'webapp_name') do
  it { should_not exist }
end
```
## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be setup with a `contributor` role on the subscription you wish to test.
