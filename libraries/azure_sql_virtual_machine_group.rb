require 'azure_generic_resource'

class AzureSQLVirtualMachineGroup < AzureGenericResource
  name 'azure_sql_virtual_machine_group'
  desc 'Retrieves and verifies the settings of an Azure SQL Virtual Machine Group.'
  example <<-EXAMPLE
    describe azure_sql_virtual_machine_group(resource_group: 'inspec-def-rg', name: 'fabric-app') do
      it { should exist }
    end
  EXAMPLE

  def initialize(opts = {})
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    opts[:resource_provider] = specific_resource_constraint('Microsoft.SqlVirtualMachine/sqlVirtualMachineGroups', opts)
    super(opts, true)
  end

  def to_s
    super(AzureSQLVirtualMachineGroup)
  end
end
