snapshot_id = input('snapshot_id', value: '', desc: '')
snapshot_name = input('snapshot_name', value: '', desc: '')
snapshot_location = input('snapshot_location', value: '', desc: '')
snapshot_source_resource_id = input('snapshot_source_resource_id', value: '', desc: '')
snapshot_disk_size_gb = input('snapshot_disk_size_gb', value: '', desc: '')

control 'azure_snapshot' do
  impact 1.0
  title 'Testing the singular resource of azure_snapshot.'
  desc 'Testing the singular resource of azure_snapshot.'

  describe azure_snapshot(resource_group: 'jfm-Dhaka-Bangladesh-RG', name: 'jfm-vm-8-snapshot') do
    it { should exist }
  end

  describe azure_snapshot(resource_group: 'jfm-Dhaka-Bangladesh-RG', name: 'jfm-vm-8-snapshot') do
    its('id') { should eq snapshot_id }
    its('name') { should eq snapshot_name }
    its('type') { should eq 'Microsoft.Compute/snapshots' }
    its('location') { should eq snapshot_location }

    its('sku.name') { should eq 'Standard_LRS' }
    its('sku.tier') { should eq 'Standard' }

    its('properties.osType') { should eq 'Windows' }
    its('properties.creationData.createOption') { should eq 'Copy' }
    its('properties.creationData.sourceResourceId') { should eq snapshot_source_resource_id }
    its('properties.diskSizeGB') { should eq snapshot_disk_size_gb }
    its('properties.timeCreated') { should_not be_empty }
    its('properties.provisioningState') { should eq 'Succeeded' }
    its('properties.diskState') { should eq 'Unattached' }
  end
end
