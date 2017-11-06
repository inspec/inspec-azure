title 'Network Security Group Properties'

control 'azure-network-security-group-1.0' do

  impact 1.0
  title 'Ensure that the NSG has been setup as expected'

  describe azure_resource(group_name: 'Inspec-Azure',
                          name: 'Inspec-NSG') do

    # Check that the NSG is in the correct location
    its('location') { should cmp 'westeurope' }

    # It has been provisionned successfully
    its('properties.provisioningState') { should eq 'Succeeded' }

    # Make sure that there is a rule called 'SSH-22' in the NSG and that it has
    # the correct properties
    describe described_class.properties.securityRules.find { |r| r.name == 'SSH-22' } do
      its('properties.destinationPortRange') { should cmp 22 }
      its('properties.access') { should cmp 'Allow'}
      its('properties.direction') { should cmp 'Inbound' }
      its('properties.priority') { should cmp 100 }
    end

    # Ensure that the NSG is connected to the subnet
    describe described_class.properties.subnets[0] do
      its('id') { should match 'Inspec-Subnet' }
    end
  end
end