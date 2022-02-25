rg = input(:resource_group, value: '')

control 'Verify the settings of a collection of all SQL VM Availability listeners' do
  describe azure_sql_virtual_machine_group_availability_listeners(resource_group: rg, sql_virtual_machine_group_name: 'inspec-sql-vm-group') do
    it { should exist }
    its('types') { should include 'Microsoft.SqlVirtualMachine/sqlVirtualMachineGroups/availabilityGroupListeners' }
    its('provisioningStates') { should include ' Succeeded' }
  end
end
