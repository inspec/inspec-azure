resource_group = input(:resource_group, value: '')
sql_managed_instance_name = input(:inspec_sql_managed_instance_name, value: '')
location = input(:location, value: '')

control 'test the properties of all Azure SQL Managed Instance in the resource group' do

  title 'Testing the singular resource of azure_sql_managed_instance.'
  desc 'Testing the singular resource of azure_sql_managed_instance.'

  describe azure_sql_managed_instance(resource_group: resource_group, name: sql_managed_instance_name) do
    it { should exist }
    its('sku.name') { should eq 'GP_Gen5' }
    its('location') { should eq location.downcase.gsub(' ', '') }
    its('type') { should eq 'Microsoft.Sql/managedInstances' }
    its('properties.provisioningState') { should eq 'Succeeded' }
  end
end
