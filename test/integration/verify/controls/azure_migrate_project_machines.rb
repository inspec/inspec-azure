resource_group = input(:resource_group, value: "")
project_name = input(:project_name, value: "inspec-migrate-integ")

control "test the properties of all azure migrate project machines" do

  title "Testing the plural resource of azure_migrate_project_machines."
  desc "Testing the plural resource of azure_migrate_project_machines."

  describe azure_migrate_project_machines(resource_group: resource_group, project_name: project_name) do
    it { should exist }
    its("types") { should include "Microsoft.Migrate/MigrateProjects/Machines" }
    its("discoveryData") { should_not be_empty }
    its("discoveryData.first") { should include({ osType: "windowsguest" }) }
  end
end
