
title 'Check Azure Resources'

control 'azure-generic-resource-group-resources-1.0' do

  impact 1.0
  title 'Check that the resource group has the correct resources'

  # Ensure that the expected resources have been deployed
  describe azure_generic_resource(group_name: 'Inspec-Azure') do
    its('total') { should eq 13 }
    its('Microsoft.Compute/virtualMachines') { should eq 3 }
    its('Microsoft.Network/networkInterfaces') { should eq 3 }
    its('Microsoft.Network/publicIPAddresses') { should eq 1 }
    its('Microsoft.Network/networkSecurityGroups') { should eq 1 }
    its('Microsoft.Storage/storageAccounts') { should eq 1 }
    its('Microsoft.Network/virtualNetworks') { should eq 1 }
    its('Microsoft.Compute/disks') { should eq 3 }

    # Within the resources that have been found, find the Linux-Internal-VM and perform
    # tests against it.
    # These are a subset of the tests as found in 'internal_vm.rb' but shows how it can be done
    # using the filter table functionailty
    describe described_class.where { name == 'Linux-Internal-VM' } do
      its('location') { should cmp 'westeurope' }
      its('type') { should cmp 'Microsoft.Compute/virtualMachines' }

      # check the machine publisher etc
      # Another describe block is required here to get around an issue where everything in a FilterTable
      # is returned as an array even if there is only one item.
      # check the machine publisher etc
      describe described_class.properties.first do
        its('storageProfile.imageReference.publisher') { should cmp 'Canonical' }
        its('storageProfile.imageReference.offer') { should cmp 'UbuntuServer' }
        its('storageProfile.imageReference.sku') { should cmp '16.04.0-LTS' }
      end
    end
  end
end