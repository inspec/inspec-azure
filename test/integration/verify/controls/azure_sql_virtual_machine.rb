rg = input(:resource_group, value: '')
sql_vm = input(:inspec_sql_virtual_machine, value: '')
location = input(:location, value: '')

control 'Verify settings of an Azure SQL Virtual Machine' do
  describe azure_sql_virtual_machine(resource_group: rg, name: sql_vm) do
    it { should exist }
    its('location') { should eq location.downcase.gsub("\s", '') }
    its('properties.provisioningState') { should eq 'Succeeded' }
    its('properties.sqlImageSku') { should eq 'Enterprise' }
    its('properties.sqlServerLicenseType') { should eq 'PAYG' }
  end
end
