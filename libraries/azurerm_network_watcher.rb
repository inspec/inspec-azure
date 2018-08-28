# frozen_string_literal: true

require 'azurerm_resource'

class AzurermNetworkWatcher < AzurermSingularResource
  name 'azurerm_network_watcher'
  desc 'Verifies settings for Network Watchers'
  example <<-EXAMPLE
    describe azurerm_network_watcher(resource_group: 'example', name: 'name') do
      its(name) { should eq 'name'}
    end
  EXAMPLE

  ATTRS = %i(
    name
    id
    etag
    type
    location
    tags
    properties
  ).freeze

  attr_reader(*ATTRS)

  def initialize(resource_group: nil, name: nil)
    resp = management.network_watcher(resource_group, name)
    return if has_error?(resp)

    assign_fields(ATTRS, resp)

    @exists = true
  end

  def to_s
    "'#{name}' Network Watcher"
  end

  def provisioning_state
    @provisioning_state ||= properties.provisioningState
  end
end
