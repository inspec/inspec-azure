location = input(:location, value: "")

control "Verify settings of an Azure HPC ASC Operation" do
  describe azure_hpc_asc_operation(location: location, operation_id: "testoperation") do
    it { should exist }
    its("name") { should eq "testoperation" }
    its("status") { should eq "Succeeded" }
  end
end
