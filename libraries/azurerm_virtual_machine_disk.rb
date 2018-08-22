# frozen_string_literal: true

require 'azurerm_resource'

class AzurermVirtualMachineDisk < AzurermSingularResource
  name 'azurerm_virtual_machine_disk'
  desc 'Verifies settings for Azure Virtual Machine Disks'
  example <<-EXAMPLE
    describe azurerm_virtual_machine_disk(resource_group: 'example', name: 'vm-name') do
      it{ should exist }
    end
  EXAMPLE

  ATTRS = %i(
    managedBy
    sku
    properties
    type
    location
    tags
    id
    name
  ).freeze

  attr_reader(*ATTRS)

  def initialize(resource_group: nil, name: nil)
    @name = name
    resp = management.virtual_machine_disk(resource_group, name)
    return if has_error?(resp)

    assign_fields(ATTRS, resp)

    @exists = true
  end

  def to_s
    "'#{name}' Disk"
  end

  def encryption_enabled
    return nil unless !!properties
    return false unless properties.key?(:encryptionSettings)

    !!properties.encryptionSettings.enabled
  end
end
