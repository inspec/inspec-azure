name = input(:cdn_profile_name, value: '')
location = input(:location, value: '')

describe azure_cdn_profiles do
  it { should exist }
  its('locations') { should include location }
  its('names') { should include name }
  its('resourceStates') { should include 'Active' }
end
