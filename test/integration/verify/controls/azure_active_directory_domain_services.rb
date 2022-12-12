control 'azure_active_directory_domain_services' do

  title 'Testing the plural resource of azure_active_directory_domain_services.'
  desc 'Testing the plural resource of azure_active_directory_domain_services.'

  describe azure_active_directory_domain_services do
    it { should exist }
  end
end
