---
title: About the azure_resource_group_resource_counts Resource
---

# azure_resource_group_resource_counts

Use the `azure_resource_group_resource_counts` InSpec audit resource to check the number of Azure resources in a resource group

## References

- [Azure Ruby SDK - Resources](https://github.com/Azure/azure-sdk-for-ruby/tree/master/management/azure_mgmt_resources)

## Syntax

The name of the resource group is specified as an attribute on the resource:

```ruby
describe azure_resource_group_resource_counts(name: 'MyResourceGroup') do
  its('attribute') { should eq 'value' }
end
```

where

* `MyResourceGroup` is the name of the resource group being interrogated
* `attribute` is one of 
  - `name`
  - `location`
  - `id`
  - `provisioning_state`
  - `subscription_id`
  - `total`
  - `nic_count`
  - `vm_count`
  - `extension_count`
  - `vnet_count`
  - `sa_count`
  - `public_ip_count`
  - `managed_disk_image_count`
  - `managed_disk_count`
* `value` is the expected output from the matcher

The options that can be passed to the resource are as follows.

| Name        | Description                                                                                                         | Required | Example                           |
|-------------|---------------------------------------------------------------------------------------------------------------------|----------|-----------------------------------|
| group_name: | Azure Resource Group to be tested                                                                                   | yes      | MyResourceGroup                   |
| name:       | Name of the Azure resource to test                                                                                  | no       | MyVM                              |

If both `group_name` and `name` is set then `name` will take priority

These options can also be set using the environment variables:

 - `AZURE_RESOURCE_GROUP_NAME`
 - `AZURE_RESOURCE_NAME`

When the options have been set as well as the environment variables, the environment variables take priority.

For example:

```ruby
describe azure_resource_group_resource_counts(name: 'ChefAutomate') do
  its('total') { should eq 7}
  its('nic_count') { should eq 1 }
  its('vm_count') { should eq 1 }
end
```

## 'have' Methods

This resource has a number of `have_xxxx` methods that provide a simple way to test of a specific Azure Resoure Type exists in the resource group. 

The following table shows the methods that are currently supported and what their associated Azure Resource Type is.

| Method Name | Azure Resource Type |
|-------------|---------------------|
| have_nics | Microsoft.Network/networkInterfaces |
| have_vms | Microsoft.Compute/virtualMachines |
| have_extensions | Microsoft.Compute/virtualMachines/extensions |
| have_nsgs | Microsoft.Network/networkSecurityGroups |
| have_vnets | Microsoft.Network/virtualNetworks |
| have_managed_disks | Microsoft.Compute/disks |
| have_managed_disk_images | Microsoft.Compute/images |
| have_sas | Microsoft.Storage/storageAccounts |
| have_public_ips | Microsoft.Network/publicIPAddresses |

With these methods the following tests are possible

```ruby
it { should have_nics }
it { should_not have_extensions }
```

## Attribute

This InSpec audit resource has the following matchers:

### name

Returns the name of the resource group.

### location

Returns where in Azure the resource group is located.

### id

Returns the full qualified ID of the resource group.

This is in the format `/subscriptions/<SUBSCRIPTION_ID>/resourceGroups/<RESOURCE_GROUP_NAME>`.

### provisioning_state

The provisioning state of the resource group.

### subscription_id

Returns the subscription ID which contains the resource group.

This is derived from the `id`.

### total

The total number of resources in the resource group

### nic_count

The number of network interface cards in the resource group

### vm_count

The number of virtual machines in the resource group

### vnet_count

The number of virtual networks in the resource group

### sa_count

The number of storage accounts in the resource group

### public_ip_count

The number of Public IP Addresses in the resource group

### managed_disk_image_count

The number of managed disk images that are in the resource group.

These are the items from which managed disks are created which are attached to machines. Generally the images are created from a base image or a custom image (e.g. Packer)

### managed_disk_count

The number of managed disks in the resource group.

If a resource group contains one virtual machine with an OS disk and 2 data disks that are all Managed Disks, then the count would be 3.

## Examples

The following examples show how to use this InSpec audit resource

Please refer the integration tests for more in depth examples:

 - [Resource Group](../../test/integration/verify/controls/resource_group.rb)

### Test Resource Group has the correct number of resources

```ruby
describe azure_resource_group_resource_counts(name: 'Inspec-Azure') do
  its('total') { should eq 7}
```

### Ensure that the Resource Group contains the correct resources

```ruby
describe azure_resource_group_resource_counts(name: 'Inspec-Azure') do
  its('total') { should eq 7 }
  its('vm_count') { should eq 2 }
  its('nic_count') { should eq 2 }
  its('public_ip_count') { should eq 1 }
  its('sa_count') { should eq 1 }
  its('vnet_count') { should eq 1 }
end
```