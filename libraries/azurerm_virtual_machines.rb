# frozen_string_literal: true

require 'azurerm_resource'

class AzurermVirtualMachines < AzurermResource
  name 'azurerm_virtual_machines'
  desc 'Verifies settings for Azure Virtual Machines'
  example <<-EXAMPLE
    azurerm_virtual_machines(resource_group: 'example') do
      it{ should exist }
    end
  EXAMPLE

  FilterTable.create
             .add_accessor(:entries)
             .add_accessor(:where)
             .add(:exists?) { |obj| !obj.entries.empty? }
             .add(:os_disks,   field: 'os_disk')
             .add(:data_disks, field: 'data_disks')
             .add(:vm_names,   field: 'name')
             .connect(self, :table)

  attr_reader :table

  def initialize(resource_group: nil)
    resp = client.virtual_machines(resource_group)
    return if resp.nil? || (resp.is_a?(Hash) && resp.key?('error'))

    @table = resp.collect(&with_platform)
                 .collect(&with_os_disk)
                 .collect(&with_data_disks)

    @exists = @table.any?
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
