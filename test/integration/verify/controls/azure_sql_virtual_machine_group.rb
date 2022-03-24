location = input(:location, value: '')
rg = input(:resource_group, value: '')

control 'test the properties of an Azure SQL Virtual Machine Group' do
  describe azure_sql_virtual_machine_group(resource_group: rg, name: 'inspec-sql-vm-group') do
    it { should exist }
    its('name') { should eq 'inspec-sql-vm-group' }
    its('properties.sqlImageSku') { should eq 'Enterprise' }
    its('location') { should eq location.downcase.gsub("\s", '') }
    its('properties.wsfcDomainProfile.domainFqdn') { should eq 'testdomain.com' }
    its('properties.provisioningState') { should eq 'Succeeded' }
  end
end
