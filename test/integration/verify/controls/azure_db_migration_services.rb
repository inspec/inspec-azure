service_name = attribute(:inspec_db_migration_service_name, default: nil)
sku_name = attribute(:inspec_db_migration_service_sku_name, default: nil)
location = attribute(:location, default: nil)

control 'azure_db_migration_services' do
  describe azure_db_migration_services do
    it { should exist }
    its('names') { should include service_name }
    its('sku_names') { should include sku_name }
    its('locations') { should include location.downcase.gsub("\s", '') }
  end
end
