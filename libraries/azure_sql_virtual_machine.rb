require 'azure_generic_resource'

class AzureSQLVirtualMachine < AzureGenericResource
  name 'azure_sql_virtual_machine'
  desc 'Retrieves and verifies the settings of an Azure SQL Virtual Machine.'
  example <<-EXAMPLE
    describe azure_sql_virtual_machine(resource_group: 'inspec-def-rg', name: 'sql-machine') do
      it { should exist }
    end
  EXAMPLE

  def initialize(opts = {})
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    opts[:resource_provider] = specific_resource_constraint('Microsoft.SqlVirtualMachine/sqlVirtualMachines', opts)
    super(opts, true)
  end

  def to_s
    super(AzureSQLVirtualMachine)
  end
end
