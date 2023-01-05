require "azure_generic_resource"

class AzureDBMigrationServices < AzureGenericResources
  name "azure_db_migration_services"
  desc "Verifies settings for a list of DB migration service resources in a resource group"
  example <<-EXAMPLE
    describe azure_db_migration_services(resource_group: 'RESOURCE_GROUP_NAME') do
      it { should exist }
    end
  EXAMPLE

  attr_reader :table

  def initialize(opts = {})
    raise ArgumentError, "Parameters must be provided in an Hash object." unless opts.is_a?(Hash)

    opts[:resource_provider] = specific_resource_constraint("Microsoft.DataMigration/services", opts)
    super
    return if failed_resource?

    @table.map! do |row|
      sku = row.delete(:sku)
      properties = row.delete(:properties)
      row[:sku_name] = sku[:name]
      row[:sku_size] = sku[:size]
      row[:sku_tier] = sku[:tier]
      row[:sku_capacity] = sku[:capacity]
      row[:sku_family] = sku[:family]
      row[:provisioning_state] = properties[:provisioningState]
      row[:virtual_nic_id] = properties[:virtualNicId]
      row[:virtual_subnet_id] = properties[:virtualSubnetId]
      row
    end

    table_schema = [
      { column: :ids, field: :id },
      { column: :names, field: :name },
      { column: :kinds, field: :kind },
      { column: :types, field: :type },
      { column: :etags, field: :etag },
      { column: :sku_names, field: :sku_name },
      { column: :sku_sizes, field: :sku_size },
      { column: :sku_tiers, field: :sku_tier },
      { column: :sku_capacities, field: :sku_capacity },
      { column: :sku_families, field: :sku_family },
      { column: :provisioning_states, field: :provisioning_state },
      { column: :virtual_nic_ids, field: :virtual_nic_id },
      { column: :virtual_subnet_ids, field: :virtual_subnet_id },
      { column: :locations, field: :location },
      { column: :tags, field: :tags },
    ]

    AzureGenericResources.populate_filter_table(:table, table_schema)
  end

  def to_s
    super(AzureDBMigrationServices)
  end
end
