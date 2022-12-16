require "azure_generic_resource"

class AzureMigrateProjectEvent < AzureGenericResource
  name "azure_migrate_project_event"
  desc "Retrieves and verifies the settings of an Azure Migrate Project Machine."
  example <<-EXAMPLE
    describe azure_migrate_project_event(resource_group: 'migrate_vms', project_name: 'zoneA_migrate_project', name: 'MigrateEvent01') do
      it { should exist }
    end
  EXAMPLE

  def initialize(opts = {})
    raise ArgumentError, "Parameters must be provided in an Hash object." unless opts.is_a?(Hash)

    opts[:resource_provider] = specific_resource_constraint("Microsoft.Migrate/migrateProjects", opts)
    opts[:required_parameters] = %i(project_name)
    opts[:resource_path] = [opts[:project_name], "migrateEvents"].join("/")
    super(opts, true)
  end

  def to_s
    super(AzureMigrateProjectEvents)
  end
end
