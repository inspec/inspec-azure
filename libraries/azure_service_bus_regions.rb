require "azure_generic_resources"

class AzureServiceBusRegions < AzureGenericResources
  name "azure_service_bus_regions"
  desc "Verifies settings for a collection of Azure Service Bus regions in a Resource Group"
  example <<-EXAMPLE
    describe azure_service_bus_regions(sku: 'Standard') do
        it { should exist }
    end
  EXAMPLE

  def initialize(opts = {})
    raise ArgumentError, "Parameters must be provided in an Hash object." unless opts.is_a?(Hash)

    opts[:resource_provider] = specific_resource_constraint("Microsoft.ServiceBus/sku", opts)
    opts[:required_parameters] = %i(sku)
    opts[:resource_path] = "#{opts[:sku]}/regions"
    super(opts, true)
    return if failed_resource?

    populate_filter_table_from_response
  end

  def to_s
    super(AzureServiceBusRegions)
  end

  private

  def populate_table
    @resources.each do |resource|
      @table << resource.merge(resource[:properties])
    end
  end
end
