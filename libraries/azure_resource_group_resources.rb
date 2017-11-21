# frozen_string_literal: true

require 'azure_backend'

class AzureResourceGroupResourceCounts < AzureResourceBase
  name 'azure_resource_group_resource_counts'

  desc '
    Inspec resource to return the counts of the different types of resources in a resource group
  '

  attr_accessor :total, :counts

  # Constructor for the resource. This calls the parent constructor which gets information
  # about all the Azure resource in a resource group
  #
  # It will remove any :name, :type and :apiversion from the options as this will detrimentally
  # filter the result
  #
  def initialize(opts = {})
    opts.key?(:name) ? opts[:group_name] = opts[:name] : false
    # Ensure that the opts only have the name of the resource group set
    opts.select! { |k, _v| k == :group_name }
    super(opts)
  end

  # Method to parse the resources that have been returned
  # This allows the calculations of the amount of resources to be determined
  def parse_resource(resource)
    # return a hash of information
    parsed = {
      'name' => resource.name,
      'type' => resource.type,
    }

    parsed
  end

  # Method to catch the count calls.
  #
  # In this resource these are satically defined
  #
  # rubocop:disable Style/MethodMissing
  def method_missing(method_id)
    # define a hash table to map the method_id values that are accepted to the Azure Resource type
    mapping = {
      nic_count: 'Microsoft.Network/networkInterfaces',
      vm_count: 'Microsoft.Compute/virtualMachines',
      extension_count: 'Microsoft.Compute/virtualMachines/extensions',
      nsg_count: 'Microsoft.Network/networkSecurityGroups',
      vnet_count: 'Microsoft.Network/virtualNetworks',
      managed_disk_count: 'Microsoft.Compute/disks',
      managed_disk_image_count: 'Microsoft.Compute/images',
      sa_count: 'Microsoft.Storage/storageAccounts',
      public_ip_count: 'Microsoft.Network/publicIPAddresses',
    }

    if mapping.key?(method_id)
      # based on the method id get the
      namespace, type_name = mapping[method_id].split(/\./)

      # check that the type_name is defined, if not return 0
      if send(namespace).methods.include?(type_name.to_sym)
        # return the count for the method id
        send(namespace).send(type_name)
      else
        0
      end
    else
      msg = format('undefined method `%s` for %s', method_id, self.class)
      raise NoMethodError, msg
    end
  end
end
