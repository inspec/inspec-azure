# frozen_string_literal: true

require 'azurerm_resource'

class AzurermVirtualMachines < AzurermPluralResource
  name 'azurerm_virtual_machines'
  desc 'Verifies settings for Azure Virtual Machines'
  example <<-EXAMPLE
    azurerm_virtual_machines(resource_group: 'example') do
      it{ should exist }
    end
  EXAMPLE

  FilterTable.create
             .register_column(:os_disks,   field: 'os_disk')
             .register_column(:data_disks, field: 'data_disks')
             .register_column(:vm_names,   field: 'name')
             .install_filter_methods_on_resource(self, :table)

  attr_reader :table

  def initialize(resource_group: nil)
    resp = management.virtual_machines(resource_group)
    return if resp.nil? || (resp.is_a?(Hash) && resp.key?('error'))

    @table = resp.collect(&with_platform)
                 .collect(&with_os_disk)
                 .collect(&with_data_disks)
  end

  def to_s
    'Azure Virtual Machines'
  end

  def with_platform
    lambda do |vm|
      os_profile = vm.dig('properties', 'osProfile')

      platform = \
        if os_profile.key?('windowsConfiguration')
          'windows'
        elsif os_profile.key?('linuxConfiguration')
          'linux'
        else
          'unknown'
        end

      vm.merge('platform' => platform)
    end
  end

  def with_os_disk
    lambda do |vm|
      os_disk = vm.dig('properties', 'storageProfile', 'osDisk')

      vm.merge('os_disk' => os_disk.fetch('name', ''))
    end
  end

  def with_data_disks
    lambda do |vm|
      disk_name = ->(disk) { disk['name'] }
      disks = Array(vm.dig('properties', 'storageProfile', 'dataDisks'))
      disks = disks.reject { |disk| disk['managedDisk'].nil? }

      vm.merge('data_disks' => disks.collect(&disk_name))
    end
  end
end
