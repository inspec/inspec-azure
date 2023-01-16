require "azure_generic_resource"

class AzureIotHub < AzureGenericResource
  name "azure_iothub"
  desc "Verifies settings for Iot Hub"
  example <<-EXAMPLE
    describe azure_iothub(resource_group: 'example', name: 'my-iot-hub') do
      its(name) { should eq 'my-iot-hub'}
    end
  EXAMPLE

  def initialize(opts = {})
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, "Parameters must be provided in an Hash object." unless opts.is_a?(Hash)

    opts[:resource_provider] = specific_resource_constraint("Microsoft.Devices/IotHubs", opts)

    opts[:resource_identifiers] = %i(resource_name)

    # static_resource parameter must be true for setting the resource_provider in the backend.
    super(opts, true)
  end

  def to_s
    super(AzureIotHub)
  end
end

# Provide the same functionality under the old resource name.
# This is for backward compatibility.
class AzurermIotHub < AzureIotHub
  name "azurerm_iothub"
  desc "Verifies settings for Iot Hub"
  example <<-EXAMPLE
    describe azurerm_iothub(resource_group: 'example', resource_name: 'my-iot-hub') do
      its(name) { should eq 'my-iot-hub'}
    end
  EXAMPLE

  def initialize(opts = {})
    Inspec::Log.warn Helpers.resource_deprecation_message(@__resource_name__, AzureIotHub.name)
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, "Parameters must be provided in an Hash object." unless opts.is_a?(Hash)

    # For backward compatibility.
    opts[:api_version] ||= "2018-04-01"
    super
  end
end
