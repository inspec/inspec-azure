
title 'External Virtual Machine Properties'

control 'azure-vm-external-2.0' do

  impact 1.0
  title 'Ensure External VM was built with the correct Image and has the correct properties'

  # Ensure that the virtual machine has been created with the correct attributes
  describe azure_resource(group_name: 'Inspec-Azure',
                          name: 'Linux-External-VM') do

    its('location') { should cmp 'westeurope' }

    # check the storage profile for the machine
    # This can be accomplished in two ways, using dotted notation or by going into
    # the class(es) with nested describe block
    # METHOD 1
    its('properties.storageProfile.imageReference.publisher') { should cmp 'Canonical' }
    its('properties.storageProfile.imageReference.offer') { should cmp 'UbuntuServer' }
    its('properties.storageProfile.imageReference.sku') { should cmp '16.04.0-LTS' }

    # METHOD 2
    # The `described_class` object is what is being tested and it can be used with 
    # more describe block to perform more tests. In this case it has been assigned to
    # another variable to make it easier to read
    vm = described_class
    describe vm.properties.storageProfile.imageReference do 
      its('publisher') { should cmp 'Canonical' }
      its('offer') { should cmp 'UbuntuServer' }
      its('sku') { should cmp '16.04.0-LTS' }
    end

    # Check the disk for the machine
    its('properties.storageProfile.osDisk.osType') { should cmp 'Linux' }
    its('properties.storageProfile.osDisk.createOption') { should cmp 'FromImage' }
    its('properties.storageProfile.osDisk.name') { should cmp 'linux-external-osdisk' }
    its('properties.storageProfile.osDisk.caching') { should cmp 'ReadWrite' }

    # Esnure that the machine has no data disks attached
    its('properties.storageProfile.dataDisks.count') { should eq 1 }
    describe vm.properties.storageProfile.dataDisks[0] do
      its('name') { should cmp 'linux-datadisk-1' }
    end

    # Check the hardwareProfile
    its('properties.hardwareProfile.vmSize') { should cmp 'Standard_DS2_v2' }

    # Check the network interfaces
    its('properties.networkProfile.networkInterfaces.count') { should eq 1 }

    # Check that this machine is connected to the correct NIC
    # This needs to use a nested describe as the network interfaces are set in 
    # and array and this needs to check the first one
    describe vm.properties.networkProfile.networkInterfaces.first do
      # Use a `match` matcher here as the ID is a a long reference to the item in Azure
      # and very last section of it contains the name of the nic
      its('id') { should match 'Inspec-NIC-2' }
    end

    # Determine the authentication and OS type
    describe vm.properties.osProfile do
      its('computerName') { should eq 'linux-external-1' }
      its('adminUsername') { should eq 'azure' }
      its('linuxConfiguration.disablePasswordAuthentication') { should be false }
    end
  end

end
