require "azure_generic_resources"

class AzureIotHubEventHubConsumerGroups < AzureGenericResources
  name "azure_iothub_event_hub_consumer_groups"
  desc "Verifies settings for Iot Hub Event Hub Consumer Groups"
  example <<-EXAMPLE
    describe azure_iothub_event_hub_consumer_groups(resource_group: 'RESOURCE_GROUP_NAME', resource_name: 'RESOURCE_NAME', event_hub_endpoint: 'EVENT_HUB_ENDPOINT') do
      it { should exist }
    end
  EXAMPLE

  attr_reader :table

  def initialize(opts = {})
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, "Parameters must be provided in an Hash object." unless opts.is_a?(Hash)

    opts[:resource_provider] = specific_resource_constraint("Microsoft.Devices/IotHubs", opts)
    opts[:required_parameters] = %i(resource_group resource_name event_hub_endpoint)
    opts[:resource_path] = [opts[:resource_name], "eventHubEndpoints", opts[:event_hub_endpoint], "ConsumerGroups"].join("/")

    # static_resource parameter must be true for setting the resource_provider in the backend.
    super(opts, true)

    # Check if the resource is failed.
    # It is recommended to check that after every usage of inherited methods or making API calls.
    return if failed_resource?

    # Define the column and field names for FilterTable.
    # In most cases, the `column` should be the pluralized form of the `field`.
    # @see https://github.com/inspec/inspec/blob/master/docs/dev/filtertable-usage.md
    table_schema = [
      { column: :names, field: :name },
      { column: :ids, field: :id },
      { column: :tags, field: :tags },
      { column: :etags, field: :etag },
      { column: :types, field: :type },
      { column: :locations, field: :location },
      { column: :properties, field: :properties },
    ]

    # FilterTable is populated at the very end due to being an expensive operation.
    AzureGenericResources.populate_filter_table(:table, table_schema)
  end

  def to_s
    super(AzureIotHubEventHubConsumerGroups)
  end
end

# Provide the same functionality under the old resource name.
# This is for backward compatibility.
class AzurermIotHubEventHubConsumerGroups < AzureIotHubEventHubConsumerGroups
  name "azurerm_iothub_event_hub_consumer_groups"
  desc "Verifies settings for Iot Hub Event Hub Consumer Groups"
  example <<-EXAMPLE
    describe azurerm_iothub_event_hub_consumer_groups(resource_group: 'my-rg', resource_name: 'my-iot-hub', event_hub_endpoint: 'myeventhub') do
      it { should exist }
    end
  EXAMPLE

  def initialize(opts = {})
    Inspec::Log.warn Helpers.resource_deprecation_message(@__resource_name__, AzureIotHubEventHubConsumerGroups.name)
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, "Parameters must be provided in an Hash object." unless opts.is_a?(Hash)

    # For backward compatibility.
    opts[:api_version] ||= "2018-04-01"
    super
  end
end
