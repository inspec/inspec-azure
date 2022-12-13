snapshot_id = input('snapshot_id', value: '', desc: '')
snapshot_name = input('snapshot_name', value: '', desc: '')
snapshot_location = input('snapshot_location', value: '', desc: '')

control 'azure_snapshots' do
  title 'Testing the plural resource of azure_snapshots.'
  desc 'Testing the plural resource of azure_snapshots.'

  describe azure_snapshots do
    it { should exist }
  end

  describe azure_snapshots do
    its('ids') { should include snapshot_id }
    its('names') { should include snapshot_name }
    its('types') { should include 'Microsoft.Compute/snapshots' }
    its('locations') { should include snapshot_location }
    its('tags') { should_not be_empty }
    its('skus') { should_not be_empty }
    its('properties') { should_not be_empty }
  end
end
