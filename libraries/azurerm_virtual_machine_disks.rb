# frozen_string_literal: true

require "azurerm_resource"
require "json"

class AzurermVirtualMachineDisks < AzurermPluralResource
  name "azurerm_virtual_machine_disks"
  desc "Verifies settings for a collection of Azure VM Disks"
  example <<-EXAMPLE
    describe azurerm_virtual_machine_disks do
        it  { should exist }
    end
  EXAMPLE

  attr_reader :table

  FilterTable.create
    .register_column(:ids,            field: :id)
    .register_column(:names,          field: :name)
    .register_column(:properties,     field: :properties)
    .register_column(:tags,           field: :tags)
    .register_column(:locations,      field: :location)
    .register_column(:attached,       field: :attached)
    .register_column(:resource_group, field: :resource_group)
    .install_filter_methods_on_resource(self, :table)

  def initialize
    resp = management.virtual_machine_disks
    return if has_error?(resp)

    resp.map!(&:to_h).each do |disk|
      disk[:attached]       = disk[:properties][:diskState].eql?("Attached")
      disk[:resource_group] = id_to_h(disk[:id])[:resource_groups]
    end

    @table = resp
  end

  def to_s
    "Azure VM Disks"
  end
end
