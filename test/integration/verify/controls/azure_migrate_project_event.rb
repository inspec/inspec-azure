resource_group = input(:resource_group, value: "")
project_name = input(:project_name, value: "inspec-migrate-integ")
event_name = "c042be9e-3d93-42cf-917f-b92c68318ded"

control "Test the properties of an azure migrate project event" do

  title "Testing the singular resource of azure_migrate_project_machine."
  desc "Testing the singular resource of azure_migrate_project_machine."

  describe azure_migrate_project_machine(resource_group: resource_group, project_name: project_name, name: event_name) do
    it { should exist }
    its("type") { should eq "Microsoft.Migrate/MigrateProjects/MigrateEvents" }
    its("properties.instanceType") { should eq "Servers" }
  end
end
