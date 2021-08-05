---
title: About the azure_virtual_wan Resource
platform: azure
---

## azure_virtual_wan

Use the `azure_virtual_wan` InSpec audit resource to test properties related to a Azure Virtual WAN in a given resource group.

## Azure REST API version, Endpoint, and HTTP Client Parameters

This resource interacts with API versions supported by the resource provider. You can define the `api_version` as a resource parameter. If not provided, the latest version is used. For more information, refer to [`azure_generic_resource`](azure_generic_resource.md).

Unless defined, `azure_cloud` global endpoint and default values for the HTTP client is used. For more information, refer to the resource pack [README](../../README.md).

## Availability

### Installation

This resource is available in the [InSpec Azure resource pack](https://github.com/inspec/inspec-azure). For an example, `inspec.yml` file and how to set up your Azure credentials, refer to resource pack [README](../../README.md#Service-Principal).

## Syntax

`name` is a required parameter.

```ruby
    describe azure_virtual_wan(resource_group: 'RESOURCE_GROUP', name: 'DEFAULT_WAN') do
     it { should exist }
     its('properties.provisioningState') { should eq 'Succeeded' }
    end
```

```ruby
    describe azure_virtual_wan(resource_group: 'RESOURCE_GROUP', name: 'DEFAULT_WAN') do
     it  { should exist }
    end
```

## Parameters

| Name           | Description                                                                      |
|----------------|----------------------------------------------------------------------------------|
| name           | Name of the Azure Virtual WAN to test.                                            |
| resource_group | The resource group name of the VirtualWan.                                       |

## Properties

| Property                      | Description                                                       |
|-------------------------------|-------------------------------------------------------------------|
| id                            | Resource ID.                                                      |
| name                          | Resource name.                                                    |
| type                          | Resource type.                                                    |
| etag                          | A unique read-only string that changes whenever the resource is updated. |
| location                      | Resource location.                                                |
| properties.provisioningState  | The provisioning state of the Virtual WAN resource.               |
| properties.disableVpnEncryption| VPN encryption to be disabled or not.                            |
| properties.allowBranchToBranchTraffic   | True if branch to branch traffic is allowed.            |
| properties.office365LocalBreakoutCategory| The office local breakout category.                    |
| properties.type               | The type of the Virtual WAN.                                      |

For properties applicable to all resources, such as `type`, `name`, `id`, `properties`, refer to [`azure_generic_resource`](azure_generic_resource.md#properties).

Also, refer to [Azure documentation](https://docs.microsoft.com/en-us/rest/api/virtualwan/virtual-wans/get) for other properties available.
Any attribute in the response may be accessed with the key names separated by dots (`.`).

## Examples

### Test that the Virtual WAN's Resource Group Encryption not equals 'be_falsey'

```ruby
    describe azure_virtual_wan(resource_group: 'RESOURCE_GROUP', name: 'DEFAULT_WAN') do
      its('properties.disableVpnEncryption') { should_not be_falsey }
    end
```

## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](/inspec/matchers/).

### exists

```ruby
# If a Virtual WAN is found, it will exist
    describe azure_virtual_wan(resource_group: 'RESOURCE_GROUP', name: 'DEFAULT_WAN') do
     it { should exist }
    end
# If no Virtual WAN's are found, it will not exist
    describe azure_virtual_wan(resource_group: 'RESOURCE_GROUP', name: 'DEFAULT_WAN') do
     it { should_not exist }
    end
```

## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be set up with a `contributor` role on the subscription you wish to test
