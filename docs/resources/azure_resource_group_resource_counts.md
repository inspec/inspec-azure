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

## Matchers

This InSpec audit resource has the following matchers:

### eq

Use the `eq` matcher to test the equality of two values: `its('Port') { should eq '22' }`.

Using `its('Port') { should eq 22 }` will fail because `22` is not a string value! Use the `cmp` matcher for less restrictive value comparisons.

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

 - [Resource Group Counts](../../test/integration/verify/controls/resource_group_counts.rb)

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