name = input(:cdn_profile_name, value: '')
location = input(:location, value: '')

control 'azure_cdn_profiles' do
  title 'Testing the plural resource of azure_cdn_profile.'
  desc 'Testing the plural resource of azure_cdn_profile.'

  describe azure_cdn_profiles do
    it { should exist }
    its('locations') { should include location }
    its('names') { should include name }
    its('resourceStates') { should include 'Active' }
  end
end
