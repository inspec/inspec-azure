control 'azure_virtual_machine_disks' do
  impact 1.0
  title 'Testing the plural resource of azure_virtual_machine_disks.'
  desc 'Testing the plural resource of azure_virtual_machine_disks.'

  describe azure_virtual_machine_disks do
    it { should exist }
  end

  describe azure_virtual_machine_disks do
    its('ids') { should include '/subscriptions/80b824de-ec53-4116-9868-3deeab10b0cd/resourceGroups/ESAKKI-WIN-2016/providers/Microsoft.Compute/disks/esakki-win-2016-dc_disk1_c3cab48e26ec4b0fa65635d38828c17c' }
    its('names') { should include 'esakki-win-2016-dc_disk1_c3cab48e26ec4b0fa65635d38828c17c' }
    its('types') { should include 'Microsoft.Compute/disks' }
    its('locations') { should include 'southeastasia' }
  end
end
