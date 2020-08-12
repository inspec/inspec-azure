---
title: About the azurerm_public_ip Resource
platform: azure
---

# azurerm\_public\_ip

Use the `azurerm_public_ip` InSpec audit resource to test properties of an Azure Public IP address.

<br />

## Azure REST API version

This resource interacts with version `2020-05-01` of the Azure Management API.
For more information see the [official Azure documentation](https://docs.microsoft.com/en-us/rest/api/virtualnetwork/publicipaddresses/get).

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
      - name: inspec-azure
        git: https://github.com/inspec/inspec-azure.git

You'll also need to setup your Azure credentials; see the resource pack
[README](https://github.com/inspec/inspec-azure#inspec-for-azure).

## Syntax

An `azurerm_public_ip` resource block identifies a public IP address by name and Resource Group.

    describe azurerm_public_ip(resource_group: 'example', name: 'addressName') do
      ...
    end

<br />

## Examples

### Test that an example Resource Group has the specified IP address

    describe azurerm_public_ip(resource_group: 'example', name: 'public_ip_address') do
      it { should exist }
    end

### Test that a specified IP address IP is correct 

    describe azurerm_public_ip(resource_group: 'example', name: 'ClusterName') do
      its('properties.ipAddress') { should cmp '51.224.11.75' }
    end

<br />

## Parameters

  - `name`
  - `resource_group`

## Parameter Examples

The Resource Group as well as the IP address name.

    describe azurerm_public_ip(resource_group: 'example', name: 'public_ip_address') do
      it { should exist }
    end

## Attributes

All of the attributes are avialable via dot notation. This is an example of the currently available attributes.

```
control 'azurerm_public_ip' do
  describe azurerm_public_ip(resource_group: 'example', name: 'address_name') do
    it { should exist }
    its('location') { should cmp 'westeurope' }
    its('properties.publicIPAddressVersion') { should eq 'IPv4' }
    its('sku.name') { should eq 'Standard' }
  end
end
```


### Other Attributes

There are additional attributes that may be accessed that we have not
documented. Please take a look at the [Azure documentation](#-Azure-REST-API-version).
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

The control will pass if the resource returns a result. Use `should_not` if you expect
zero matches.

    # If we expect 'AddressName' to always exist
    describe azurerm_public_ip(resource_group: 'example', name: 'AddressName') do
      it { should exist }
    end

    # If we expect 'AddressName' to never exist
    describe azurerm_public_ip(resource_group: 'example', name: 'AddressName') do
      it { should_not exist }
    end

## Azure Permissions

Your [Service
Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal)
must be setup with a `contributor` role on the subscription you wish to test.
