service_name = attribute(:inspec_db_migration_service_name, value: nil)
sku_name = attribute(:inspec_db_migration_service_sku_name, value: nil)
location = attribute(:location, value: nil)

control 'azure_db_migration_services' do

  title 'Testing the plural resource of azure_db_migration_services.'
  desc 'Testing the plural resource of azure_db_migration_services.'

  describe azure_db_migration_services do
    it { should exist }
    its('names') { should include service_name }
    its('sku_names') { should include sku_name }
    its('locations') { should include location.downcase.gsub("\s", '') }
  end
end
