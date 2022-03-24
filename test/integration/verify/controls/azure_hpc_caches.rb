name = input(:inspec_hpc_cache_name, value: '')
location = input(:location, value: '')

describe azure_hpc_caches do
  it { should exist }
  its('names') { should include name }
  its('locations') { should include location }
  its('provisioningStates') { should include 'Succeeded' }
  its('cacheSizeGBs') { should include 3072 }
end
