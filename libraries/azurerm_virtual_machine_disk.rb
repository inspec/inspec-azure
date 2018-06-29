# frozen_string_literal: true

# TODO: we will have a name collision with the existing implementation

require 'azurerm_resource'

class AzurermVirtualMachineDisk < AzurermResource
  name 'azurerm_virtual_machine_disk'
  desc 'Verifies settings for Azure Virtual Machine Disks'
  example "
    describe azurerm_virtual_machine_disk(resource_group: 'example', name: 'vm-name') do
    end
  "

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
    resp = client.virtual_machine_disk(resource_group, name)
    return if resp.nil? || resp.key?('error')

    ATTRS.each do |field|
      instance_variable_set("@#{field}", resp[field.to_s])
    end

    @exists = true
  end

  def to_s
    "'#{name}' Disk"
  end

  def encryption_enabled
    return nil unless properties
    !!properties.dig('encryptionSettings', 'enabled')
  end
end
