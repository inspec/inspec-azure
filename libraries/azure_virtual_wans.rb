require 'azure_generic_resources'

class AzureVirtualWans < AzureGenericResources
  name 'azure_virtual_wans'
  desc 'Lists and verifies all Azure Virtual WANs.'
  example <<-EXAMPLE
    describe azure_virtual_wans do
      it { should exist }
    end
  EXAMPLE

  def initialize(opts = {})
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    opts[:resource_provider] = specific_resource_constraint('Microsoft.Network/virtualWans', opts)
    super(opts, true)

    return if failed_resource?

    table_schema = [
      { column: :ids, field: :id },
      { column: :names, field: :name },
      { column: :etags, field: :etag },
      { column: :locations, field: :location },
      { column: :types, field: :type },
      { column: :properties, field: :properties },
    ]
    AzureGenericResources.populate_filter_table(:table, table_schema)
  end

  def to_s
    super(AzureVirtualWans)
  end
end
