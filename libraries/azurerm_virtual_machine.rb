# frozen_string_literal: true

require 'azurerm_resource'

class AzurermVirtualMachine < AzurermSingularResource
  name 'azurerm_virtual_machine'
  desc 'Verifies settings for an Azure Virtual Machine'
  example <<-EXAMPLE
    describe azurerm_virtual_machine(resource_group: 'example', name: 'vm-name') do
      it { should have_monitoring_agent_installed }
    end
  EXAMPLE

  ATTRS = %i(
    id
    name
    location
    properties
    resources
    tags
    type
    zones
  ).freeze

  attr_reader(*ATTRS)

  def initialize(resource_group: nil, name: nil)
    resp = client.virtual_machine(resource_group, name)
    return if resp.nil? || resp.key?('error')

    ATTRS.each do |field|
      instance_variable_set("@#{field}", resp[field.to_s])
    end

    @exists = true
  end

  def to_s
    "'#{name}' Virtual Machine"
  end

  def installed_extensions_types
    @installed_extensions_types ||= Array(resources).map do |extension|
      extension['properties']['type']
    end
  end

  def has_only_approved_extensions?(approved_extensions)
    (installed_extensions_types - approved_extensions).empty?
  end

  def has_endpoint_protection_installed?(endpoint_protection_extensions)
    installed_extensions_types.any? { |extension| endpoint_protection_extensions.include?(extension) }
  end

  def installed_extensions_names
    @installed_extensions_names ||= Array(resources).map do |extension|
      extension['name']
    end
  end

  def has_monitoring_agent_installed?
    return false unless properties['osProfile']['windowsConfiguration']

    Array(resources).any? do |extension|
      status = extension['properties']['provisioningState']
      type = extension['properties']['type']

      type == 'MicrosoftMonitoringAgent' && status == 'Succeeded'
    end
  end

  def os_disk_name
    properties['storageProfile']['osDisk']['name']
  end

  def data_disk_names
    Array(properties.dig('storageProfile', 'dataDisks')).map { |disk| disk['name'] }
  end
end
