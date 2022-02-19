require 'azure_generic_resource'

class AzureSQLVirtualMachineGroupAvailabilityListener < AzureGenericResource
  name 'azure_sql_virtual_machine_group_availability_listener'
  desc 'Retrieves and verifies the settings of an Azure SQL Virtual Machine Group Availability Listener.'
  example <<-EXAMPLE
    describe azure_sql_virtual_machine_group_availability_listener(resource_group: 'inspec-def-rg', sql_virtual_machine_group_name: 'inspec-sql-vm-group', name: 'inspec-avl') do
      it { should exist }
    end
  EXAMPLE

  def initialize(opts = {})
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    opts[:resource_provider] = specific_resource_constraint('Microsoft.SqlVirtualMachine/sqlVirtualMachineGroups', opts)
    opts[:required_parameters] = %i(sql_virtual_machine_group_name)
    opts[:resource_path] = "#{opts[:sql_virtual_machine_group_name]}/availabilityGroupListeners"
    super(opts, true)
  end

  def to_s
    super(AzureSQLVirtualMachineGroupAvailabilityListener)
  end
end
