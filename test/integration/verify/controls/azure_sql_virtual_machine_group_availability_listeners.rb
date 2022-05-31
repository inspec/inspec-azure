rg = input(:resource_group, value: '')

control 'Verify the settings of a collection of all SQL VM Availability listeners' do

  impact 1.0
  title 'Testing the plural resource of azure_sql_virtual_machine_group_availability_listeners.'
  desc 'Testing the plural resource of azure_sql_virtual_machine_group_availability_listeners.'

  describe azure_sql_virtual_machine_group_availability_listeners(resource_group: rg, sql_virtual_machine_group_name: 'inspec-sql-vm-group') do
    it { should exist }
    its('types') { should include 'Microsoft.SqlVirtualMachine/sqlVirtualMachineGroups/availabilityGroupListeners' }
    its('provisioningStates') { should include ' Succeeded' }
  end
end
