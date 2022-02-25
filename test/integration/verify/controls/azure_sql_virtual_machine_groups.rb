location = input(:location, value: '')

control 'test the properties of all Azure SQL Virtual Machine Groups' do
  describe azure_sql_virtual_machine_groups do
    it { should exist }
    its('names') { should include 'inspec-sql-vm-group' }
    its('sqlImageSkus') { should include 'Enterprise' }
    its('locations') { should include location.downcase.gsub("\s", '') }
    its('domainFqdns') { should include 'testdomain.com' }
    its('provisioningStates') { should include 'Succeeded' }
  end
end
