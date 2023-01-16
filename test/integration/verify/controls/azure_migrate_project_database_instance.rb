resource_group = input(:resource_group, value: "")
project_name = input(:project_name, value: "inspec-migrate-integ")

control "Test the properties of an azure migrate project database" do

  title "Testing the singular resource of azure_migrate_project_database_instance."
  desc "Testing the singular resource of azure_migrate_project_database_instance."

  describe azure_migrate_project_database_instance(resource_group: resource_group, project_name: project_name, name: "my_db_instance") do
    it { should exist }
    its("name") { should eq "my_db_instance" }
    its("type") { should eq "Microsoft.Migrate/MigrateProjects/DatabaseInstances" }
    its("instanceIds") { should include "instance-1" }
    its("instanceTypes") { should include "SQL" }
  end
end
