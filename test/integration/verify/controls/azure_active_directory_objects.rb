directory_object = input(:sample_directory_object, value: '')

control 'azure active directory objects' do
  describe azure_active_directory_objects do
    it { should exist }
    its('values') { should include directory_object }
  end
end
