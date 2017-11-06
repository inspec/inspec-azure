title 'Public IP Address Properties'

control 'azure-public-ip-address-1.0' do

  impact 1.0
  title 'Ensure that the Public IP Address has been configured correctly'

  describe azure_resource(group_name: 'Inspec-Azure', name: 'Inspec-PublicIP-1') do

    its('type') { should cmp 'Microsoft.Network/publicIPAddresses' }
    its('location') { should cmp 'westeurope' }

    its('properties.provisioningState') { should cmp 'Succeeded' }

    # The IP address should be dynamically assigned
    its('properties.publicIPAllocationMethod') { should cmp 'Dynamic' }

    its('properties.dnsSettings.domainNameLabel') { should match 'linux-external-1' }

    # Ensure that this Public IP is assigned to the Nic that is assigned to the external vm
    its('properties.ipConfiguration.id') { should match 'Inspec-NIC-2' }
  end
end