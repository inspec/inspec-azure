require 'azure_generic_resources'

class AzureServiceBusNamespaces < AzureGenericResources
  name 'azure_service_bus_namespaces'
  desc 'Verifies settings for a collection of Azure Service Bus Namespaces in a Resource Group'
  example <<-EXAMPLE
    describe azure_service_bus_namespaces(resource_group: 'migrated_vms') do
        it { should exist }
    end
  EXAMPLE

  def initialize(opts = {})
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    opts[:resource_provider] = specific_resource_constraint('Microsoft.ServiceBus/namespaces', opts)
    super(opts, true)
    return if failed_resource?

    populate_filter_table_from_response
  end

  def to_s
    super(AzureServiceBusNamespaces)
  end

  private

  def populate_table
    @resources.each do |resource|
      resource = resource.merge(resource[:properties])
      skus = resource[:sku].each_with_object({}) { |(k, v), hash| hash["sku_#{k}".to_sym] = v }
      @table << resource.merge(skus)
    end
  end
end
