name = input(:cdn_profile_name, value: '')
resource_group = input(:resource_group, value: '')
location = input(:location, value: '')

describe azure_cdn_profile(resource_group: resource_group, name: name) do
  it { should exist }
  its('location') { should eq location }
  its('provisioningState') { should eq 'Succeeded' }
  its('resourceState') { should eq 'Active' }
end
