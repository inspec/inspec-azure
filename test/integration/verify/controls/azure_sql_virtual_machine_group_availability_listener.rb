rg = input(:resource_group, value: '')

control 'Verify the settings of an SQL VM Availability listener' do
  describe azure_sql_virtual_machine_group_availability_listener(resource_group: rg, sql_virtual_machine_group_name: 'inspec-sql-vm-group', name: 'inspec-avl') do
    it { should exist }
    its('type') { should eq 'Microsoft.SqlVirtualMachine/sqlVirtualMachineGroups/availabilityGroupListeners' }
    its('properties.provisioningState') { should eq ' Succeeded' }
  end
end
