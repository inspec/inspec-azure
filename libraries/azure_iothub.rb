require 'azure_generic_resource'

class AzureIotHub < AzureGenericResource
  name 'azure_iothub'
  desc 'Verifies settings for Iot Hub'
  example <<-EXAMPLE
    describe azure_iothub(resource_group: 'example', name: 'my-iot-hub') do
      its(name) { should eq 'my-iot-hub'}
    end
  EXAMPLE

  def initialize(opts = {})
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    opts[:resource_provider] = specific_resource_constraint('Microsoft.Devices/IotHubs', opts)

    opts[:resource_identifiers] = %i(resource_name)

    # static_resource parameter must be true for setting the resource_provider in the backend.
    super(opts, true)
  end

  def to_s
    super(AzureIotHub)
  end
end
