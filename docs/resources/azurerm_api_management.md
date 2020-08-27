---
title: About the azurerm_api_management Resource
platform: azure
---

> <b>WARNING</b>  This resource will be deprecated in InSpec Azure Resource Pack version **2**. Please start using fully backward compatible [`azure_api_management`](azure_api_management.md) InSpec audit resource.

# azurerm\_\_api\_management

Use the `azurerm_api_management` InSpec audit resource to test properties and configuration of
an Azure Api Management Service.
<br />

## Azure REST API version
This resource interacts with version `2019-12-01` of the Azure Management API. For more
information see the [Official Azure Documentation](https://docs.microsoft.com/en-us/rest/api/apimanagement/2019-12-01/apimanagementservice/get).

At the moment, there doesn't appear to be a way to select the version of the
Azure API docs. If you notice a newer version being referenced in the official
documentation please open an issue or submit a pull request using the updated
version.

## Availability

### Installation

This resource is available in the `inspec-azure` [resource
pack](https://www.inspec.io/docs/reference/glossary/#resource-pack). To use it, add the
following to your `inspec.yml` in your top-level profile:

    depends:
      inspec-azure:
        git: https://github.com/inspec/inspec-azure.git

You'll also need to setup your Azure credentials; see the resource pack
[README](https://github.com/inspec/inspec-azure#inspec-for-azure).

## Syntax

The `resource_group` and `api_management_name` must be given as a parameter.

    describe azurerm_api_management(resource_group: 'inspec-resource-group-9', api_management_name: 'apim01') do
      it { should exist }
    end

<br />

## Examples

If a Api Management Service is referenced with a valid `Resource Group` and `Api Management Name`

    describe azurerm_api_management(resource_group: 'my-rg', api_management_name: 'apim01') do
      it { should exist }
    end

If a Api Management Service is referenced with an invalid `Resource Group` or `Api Management Name`

    describe azurerm_api_management(resource_group: 'invalid-rg', api_management_name: 'i-dont-exist') do
      it { should_not exist }
    end

<br />

## Parameters

  - `resource_group` - The resource Group to which the Api Management Service belongs.
  - `api_management_name` - The unique name of the Api Management Service.

## Attributes

- `id`
- `name`
- `location`
- `properties`
- `type`

### id
Azure resource ID.

### name
Api Management Service name, e.g. `apim01`.

### location
Resource location, e.g. `eastus`.

### properties
A collection of additional configuration properties related to the API Management Service, e.g. `publisherEmail`.

### type
The type of Resource, typically `Microsoft.ApiManagement/service`.

### Other Attributes

There are additional attributes that may be accessed that we have not
documented. Please take a look at the [Azure documentation](##-Azure-REST-API-version).
Any attribute in the response may be accessed with the key names separated by
dots (`.`).

The API may not always return keys that do not have any associated data. There
may be cases where the deeply nested property may not have the desired
attribute along your call chain. If you find yourself writing tests against
properties that may be nil, fork this resource pack and add an accessor to the
resource. Within that accessor you'll be able to guard against nil keys. Pull
requests are always welcome.

## Matchers

This InSpec audit resource has the following special matchers. For a full list of
available matchers, please visit our [Universal Matchers
page](https://www.inspec.io/docs/reference/matchers/).

### exists

describe azurerm_api_management(resource_group: 'my-rg', api_management_name: 'apim-1') do
  it { should exist }
end

## Azure Permissions

Your [Service
Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal)
must be setup with a `contributor` role on the subscription you wish to test.
