require 'azure_generic_resources'

class AzureSQLManagedInstances < AzureGenericResources
  name 'azure_sql_managed_instances'
  desc 'Verifies settings for a collection of Azure SQL Managed Instances'
  example <<-EXAMPLE
    describe azure_sql_managed_instances(resource_group: 'migrated_vms') do
        it { should exist }
    end
  EXAMPLE

  def initialize(opts = {})
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    opts[:resource_provider] = specific_resource_constraint('Microsoft.Sql/managedInstances', opts)
    super(opts, true)
    return if failed_resource?

    populate_filter_table_from_response
  end

  def to_s
    super(AzureSQLManagedInstances)
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
