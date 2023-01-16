require "azure_generic_resources"

class AzurePowerBiEmbeddedCapacities < AzureGenericResources
  name "azure_power_bi_embedded_capacities"
  desc "Retrieves and verifies the settings of all Azure Power BI Embedded Capacities."
  example <<-EXAMPLE
    describe azure_power_bi_embedded_capacities do
      it { should exist }
    end
  EXAMPLE

  def initialize(opts = {})
    raise ArgumentError, "Parameters must be provided in an Hash object." unless opts.is_a?(Hash)

    opts[:resource_provider] = specific_resource_constraint("Microsoft.PowerBIDedicated/capacities", opts)
    super(opts, true)
    return if failed_resource?

    populate_filter_table_from_response
  end

  def to_s
    super(AzurePowerBiEmbeddedCapacities)
  end

  private

  def populate_table
    @resources.each do |resource|
      props = resource[:properties]
      sku_hash = concat_keys(resource[:sku], "sku")
      administration_attrs = concat_keys(props[:administration], "administration")
      @table << resource.merge(resource[:properties])
        .merge(sku_hash)
        .merge(administration_attrs)
    end
  end

  def concat_keys(props, concat_prefix = nil)
    return unless concat_prefix

    props.each_with_object({}) { |(key, value), hash| hash["#{concat_prefix}_#{key}".to_sym] = value }
  end
end
