control 'azure_active_directory_domain_service' do

  title 'Testing the singular resource of azure_active_directory_domain_service.'
  desc 'Testing the singular resource of azure_active_directory_domain_service.'

  azure_active_directory_domain_services.ids.each do |domain_service_id|
    describe azure_active_directory_domain_service(id: domain_service_id) do
      it { should exist }
      its('isVerified') { should eq true }
    end
  end

  describe azure_active_directory_domain_service(id: 'dummy') do
    it { should_not exist }
  end
end
