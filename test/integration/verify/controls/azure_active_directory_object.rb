control 'azure active directory object' do
  describe azure_active_directory_object(id: 'test id') do
    it { should exist }
  end
end
