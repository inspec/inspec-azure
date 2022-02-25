control 'azure_active_directory_domain_service' do

  impact 1.0
  title 'Testing the singular resource of azure_active_directory_domain_service.'
  desc 'Testing the singular resource of azure_active_directory_domain_service.'

  azure_active_directory_domain_services.ids.each do |domain_service_id|
    describe azure_active_directory_domain_service(id: domain_service_id) do
      it { should exist }
      its('isVerified') { should eq true }
    end
  end
end
