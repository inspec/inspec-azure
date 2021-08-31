directory_object = input(:sample_directory_object, value: '')

control 'azure active directory object' do
  describe azure_active_directory_object(id: directory_object) do
    it { should exist }
    its('displayName') { should eq 'MyApps_AliBabaCloud' }
    its('visibility') { should be_empty }
    its('mailEnabled') { should be_falsey }
  end
end
