title 'Resource Group Type Counts'

control 'azure-resource-group-resource-counts-1.0' do
  impact 1.0
  title 'Ensure that the specified resource group has the correct number of Azure resources'

  # Obtain counts for all resources in the resource group
  describe azure_resource_group_resource_counts(name: 'Inspec-Azure') do
    its('total') { should eq 13 }
    its('vm_count') { should eq 3 }
    its('nic_count') { should eq 3 }
    its('public_ip_count') { should eq 1 }
    its('nsg_count') { should eq 1 }
    its('sa_count') { should eq 1 }
    its('vnet_count') { should eq 1 }
    its('managed_disk_count') { should eq 3 }
    its('managed_disk_image_count') { should eq 0 }
  end
end