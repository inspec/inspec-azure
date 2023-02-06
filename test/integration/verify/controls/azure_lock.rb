resource_group = input("resource_group", value: nil)
resource_name = input("windows_vm_name", value: nil)

control "azure_lock_test" do
  title "Testing the singular resource of azure_lock."
  desc "Testing the singular resource of azure_lock."

  vm_id = azure_virtual_machine(resource_group: resource_group, name: resource_name).id

  describe azure_locks(resource_id: vm_id).ids.each do |lock_id|
    describe azure_lock(resource_id: lock_id) do
      it("properties.notes") { should_not be_empty }
    end
  end
end
