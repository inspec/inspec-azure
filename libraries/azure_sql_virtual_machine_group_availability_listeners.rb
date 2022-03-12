require 'azure_generic_resources'

class AzureSQLVirtualMachineGroupAvailabilityListeners < AzureGenericResources
  name 'azure_sql_virtual_machine_group_availability_listeners'
  desc 'Verifies settings for a collection of Azure SQL Virtual Machine Group Availability Listeners'
  example <<-EXAMPLE
    describe azure_sql_virtual_machine_group_availability_listeners(resource_group: 'inspec-def-rg', sql_virtual_machine_group_name: 'inspec-sql-vm-group') do
        it { should exist }
    end
  EXAMPLE

  def initialize(opts = {})
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    opts[:resource_provider] = specific_resource_constraint('Microsoft.SqlVirtualMachine/sqlVirtualMachineGroups', opts)
    opts[:required_parameters] = %i(sql_virtual_machine_group_name)
    opts[:resource_path] = "#{opts[:sql_virtual_machine_group_name]}/availabilityGroupListeners"
    super(opts, true)
    return if failed_resource?

    populate_filter_table_from_response
  end

  def to_s
    super(AzureSQLVirtualMachineGroupAvailabilityListeners)
  end

  private

  def populate_table
    @resources.each do |resource|
      @table << resource.merge(resource[:properties])
    end
  end
end
