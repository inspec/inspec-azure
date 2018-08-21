resource_group        = attribute('resource_group',          default: nil)
location              = attribute('encrypted_disk_location', default: nil)
unencrypted_disk_name = attribute('unencrypted_disk_name',   default: nil)
encrypted_disk_name   = attribute('encrypted_disk_name',     default: nil)
unmanaged_disk_name   = attribute('unamaged_disk_name',      default: nil)

control 'azurerm_virtual_machine_disk' do
  describe azurerm_virtual_machine_disk(resource_group: resource_group, name: encrypted_disk_name) do
    it                        { should exist }
    its('id')                 { should eq "/subscriptions/#{ENV['AZURE_SUBSCRIPTION_ID']}/resourceGroups/#{resource_group}/providers/Microsoft.Compute/disks/#{encrypted_disk_name}" }
    its('name')               { should eq(encrypted_disk_name) }
    its('tags')               { should eq({}) }
    its('location')           { should eq(location) }
    its('type')               { should eq('Microsoft.Compute/disks') }
    its('sku.name')           { should eq('Standard_LRS') }
    its('sku.tier')           { should eq('Standard') }
    its('encryption_enabled') { should be true }
    its('properties')         { should_not be_nil }
  end

  describe azurerm_virtual_machine_disk(resource_group: resource_group, name: unencrypted_disk_name) do
    its('encryption_enabled') { should be false }
  end

  describe azurerm_virtual_machine_disk(resource_group: resource_group, name: unmanaged_disk_name) do
    it                        { should_not exist }
    its('encryption_enabled') { should be_nil }
  end
end
