# frozen_string_literal: true

require "azurerm_resource"

class AzurermIotHubEventHubConsumerGroups < AzurermSingularResource
  name "azurerm_iothub_event_hub_consumer_groups"
  desc "Verifies settings for Iot Hub Event Hub Consumer Groups"
  example <<-EXAMPLE
    describe azurerm_iothub_event_hub_consumer_groups(resource_group: 'my-rg', resource_name 'my-iot-hub', event_hub_endpoint: 'myeventhub') do
      its(name) { should eq 'name'}
    end
  EXAMPLE

  attr_reader :table

  FilterTable.create
    .register_column(:ids,        field: :id)
    .register_column(:names,      field: :name)
    .register_column(:types,      field: :type)
    .register_column(:etags,      field: :etag)
    .register_column(:properties, field: :properties)
    .install_filter_methods_on_resource(self, :table)

  def initialize(resource_group: nil, resource_name: nil, event_hub_endpoint: nil)
    consumer_groups = management.iothub_event_hub_consumer_groups(resource_group, resource_name, event_hub_endpoint)
    return if has_error?(consumer_groups)

    @table = consumer_groups
  end

  def to_s
    "IoT Hub Event Hub Consumer Groups"
  end
end
