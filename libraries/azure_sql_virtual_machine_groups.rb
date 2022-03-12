require 'azure_generic_resources'

class AzureSQLVirtualMachineGroups < AzureGenericResources
  name 'azure_sql_virtual_machine_groups'
  desc 'Verifies settings for a collection of Azure SQL Virtual Machine Groups'
  example <<-EXAMPLE
    describe azure_sql_virtual_machine_groups do
        it { should exist }
    end
  EXAMPLE

  def initialize(opts = {})
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    opts[:resource_provider] = specific_resource_constraint('Microsoft.SqlVirtualMachine/sqlVirtualMachineGroups', opts)
    super(opts, true)
    return if failed_resource?

    populate_filter_table_from_response
  end

  def to_s
    super(AzureSQLVirtualMachineGroups)
  end

  private

  def populate_table
    @resources.each do |resource|
      @table << resource.merge(resource[:properties]).merge(resource.dig(:properties, :wsfcDomainProfile))
    end
  end
end
