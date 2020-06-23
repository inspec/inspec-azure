---
title: About the azurerm_mariadb_server Resource
platform: azure
---


# azurerm\_mariadb\_server


Use the `azurerm_mariadb_server` InSpec audit resource to test properties and configuration of
an Azure MariaDB Server.
<br />

## Azure REST API version

This resource interacts with version `2018-06-01-preview ` of the Azure Management API. For more
information see the [Official Azure Documentation](https://docs.microsoft.com/en-us/rest/api/mariadb/databases/get).

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

### Version


## Syntax

The `resource_group` and `server_name` must be given as a parameter.

    describe azurerm_mariadb_server(resource_group: 'inspec-resource-group-9', server_name: 'example_server') do
      it { should exist }
    end

<br />

## Examples

If a SQL Server is referenced with a valid `Resource Group` and `Server Name`

    describe azurerm_mariadb_server(resource_group: 'my-rg', server_name: 'sql-server-1') do
      it { should exist }
    end

If a SQL Server is referenced with an invalid `Resource Group` or `Server Name`

    describe azurerm_mariadb_server(resource_group: 'invalid-rg', server_name: 'i-dont-exist') do
      it { should_not exist }
    end

<br />

## Parameters

  - `resource_group` - The resource Group to which the SQL Server belongs.
  - `server_name` - The unique name of the SQL Server.

## Attributes

- `id`
- `name`
- `sku`
- `location`
- `properties`
- `tags`
- `type`

### id
Azure resource ID.

### name
MariaDB Server name, e.g. `mariadb-server`.

### sku
SKU of MariaDB server. This is billing information related properties of a server.

### location
Resource location, e.g. `eastus`.

### properties
A collection of additional configuration properties related to the MariaDB Server, e.g. `administratorLogin`.

### tags
Resource tags applied to the MySQL Server.

### type
The type of Resource, typically `Microsoft.DBforMariaDB/servers`.

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

    describe azurerm_mariadb_server(resource_group: 'my-rg', server_name: 'server-name-1') do
      it { should exist }
    end

## Azure Permissions

Your [Service
Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal)
must be setup with a `contributor` role on the subscription you wish to test.
