control 'azure_virtual_machine_disk' do
  impact 1.0
  title 'Testing the singular resource of azure_virtual_machine_disk.'
  desc 'Testing the singular resource of azure_virtual_machine_disk.'

  describe azure_virtual_machine_disk(resource_group: 'ESAKKI-WIN-2016', name: 'esakki-win-2016-dc_disk1_c3cab48e26ec4b0fa65635d38828c17c') do
    it { should exist }
  end

  describe azure_virtual_machine_disk(resource_group: 'ESAKKI-WIN-2016', name: 'esakki-win-2016-dc_disk1_c3cab48e26ec4b0fa65635d38828c17c') do
    its('id') { should eq '/subscriptions/80b824de-ec53-4116-9868-3deeab10b0cd/resourceGroups/ESAKKI-WIN-2016/providers/Microsoft.Compute/disks/esakki-win-2016-dc_disk1_c3cab48e26ec4b0fa65635d38828c17c' }
    its('name') { should eq 'esakki-win-2016-dc_disk1_c3cab48e26ec4b0fa65635d38828c17c' }
    its('type') { should eq 'Microsoft.Compute/disks' }
    its('location') { should eq 'southeastasia' }
  end
end
