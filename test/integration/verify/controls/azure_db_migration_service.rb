resource_group_name = attribute(:resource_group, default: nil)
service_name = attribute(:inspec_db_migration_service_name, default: nil)
sku_name = attribute(:inspec_db_migration_service_sku_name, default: nil)
location = attribute(:location, default: nil)

control 'azure_db_migration_service' do

  impact 1.0
  title 'Testing the singular resource of azure_db_migration_service.'
  desc 'Testing the singular resource of azure_db_migration_service.'

  describe azure_db_migration_service(resource_group: resource_group_name, service_name: service_name) do
    it { should exist }
    its('sku.name') { should eq sku_name }
    its('location') { should eq location.downcase.gsub("\s", '') }
    its('properties.provisioningState') { should eq 'Succeeded' }
  end
end
