require 'azure_generic_resources'

class AzureSQLVirtualMachines < AzureGenericResources
  name 'azure_sql_virtual_machines'
  desc 'Verifies settings for a collection of Azure SQL Virtual Machines'
  example <<-EXAMPLE
    describe azure_sql_virtual_machines do
        it { should exist }
    end
  EXAMPLE

  def initialize(opts = {})
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    opts[:resource_provider] = specific_resource_constraint('Microsoft.SqlVirtualMachine/sqlVirtualMachines', opts)
    super(opts, true)
    return if failed_resource?

    populate_filter_table_from_response
  end

  def to_s
    super(AzureSQLVirtualMachines)
  end

  private

  def populate_table
    @resources.each do |resource|
      @table << resource.merge(resource[:properties])
    end
  end
end
