sql_vm = input(:inspec_sql_virtual_machine, value: '')
location = input(:location, value: '')

control 'Verify settings of all Azure SQL Virtual Machines' do
  describe azure_sql_virtual_machines do
    it { should exist }
    its('names') { should include sql_vm }
    its('location') { should include location.downcase.gsub("\s", '') }
    its('provisioningStates') { should include 'Succeeded' }
    its('sqlImageSkus') { should include 'Enterprise' }
    its('sqlServerLicenseTypes') { should include 'PAYG' }
  end
end
