title 'Managed Disk'

control 'azure-managed-disk-1.0' do

  impact 1.0
  title 'A managed disk was created for on the of machines, ensure that it is configured correctly'

  # Ensure that the virtual machine has been created with the correct attributes
  describe azure_resource(group_name: 'Inspec-Azure', name: 'Linux-Internal-OSDisk-MD') do

    # Ensure that it is attached, or 'managedBy' the correct machine
    its('managed_by') { should match 'Linux-Internal-VM' }

    # Check some of the properties
    its('properties.osType') { should cmp 'Linux' }

    # This disk should have been created from an image
    # Ensure that it is the correct one
    describe described_class.properties.creationData do
      its('createOption') { should eq 'FromImage' }

      # This disk should be an ubuntu image
      its('imageReference.id') { should match 'Canonical' }
      its('imageReference.id') { should match 'UbuntuServer' }
      its('imageReference.id') { should match '16.04.0-LTS' }
    end

    its('properties.diskSizeGB') { should be > 25 }

    # ensure the disk is attached
    its('properties.diskState') { should cmp 'Attached' }
  end

end