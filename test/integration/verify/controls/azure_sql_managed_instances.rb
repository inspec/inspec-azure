resource_group = input(:resource_group, value: '')
sql_managed_instance_name = input(:inspec_sql_managed_instance_name, value: '')
location = input(:location, value: '')

control 'test the properties of all Azure SQL Managed Instances in the resource group' do
  describe azure_sql_managed_instances(resource_group: resource_group) do
    it { should exist }
    its('names') { should include sql_managed_instance_name }
    its('sku_names') { should include 'GP_Gen5' }
    its('locations') { should include location.downcase.gsub(' ', '') }
    its('types') { should include 'Microsoft.Sql/managedInstances' }
    its('provisioningStates') { should include 'Succeeded' }
  end
end
