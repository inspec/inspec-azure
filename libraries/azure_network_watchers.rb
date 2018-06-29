# frozen_string_literal: true

require 'azurerm_resource'

class AzureNetworkWatchers < AzurermResource
  name 'azure_network_watchers'
  desc 'Verifies settings for Network Watchers'
  example <<-EXAMPLE
    azure_network_watchers(resource_group: 'example') do
      it{ should exist }
    end
  EXAMPLE

  attr_reader :table

  FilterTable.create
             .add_accessor(:entries)
             .add_accessor(:where)
             .add(:exists?) { |obj| !obj.entries.empty? }
             .add(:names, field: 'name')
             .connect(self, :table)

  def initialize(resource_group:)
    resp = client.network_watchers(resource_group)
    return if resp.nil? || (resp.is_a?(Hash) && resp.key?('error'))

    @table = resp
  end

  def to_s
    'Network Watchers'
  end
end
