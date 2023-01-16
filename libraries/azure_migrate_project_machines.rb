require "azure_generic_resources"

class AzureMigrateProjectMachines < AzureGenericResources
  name "azure_migrate_project_machines"
  desc "Verifies settings for a collection of Azure Migrate Project Machines for a Azure Migrate Project in a Resource Group"
  example <<-EXAMPLE
    describe azure_migrate_project_machines(resource_group: 'migrated_vms', project_name: 'zoneA_migrate_project') do
        it { should exist }
    end
  EXAMPLE

  def initialize(opts = {})
    raise ArgumentError, "Parameters must be provided in an Hash object." unless opts.is_a?(Hash)

    opts[:resource_provider] = specific_resource_constraint("Microsoft.Migrate/migrateProjects", opts)
    opts[:required_parameters] = %i(project_name)
    opts[:resource_path] = [opts[:project_name], "machines"].join("/")
    super(opts, true)
    return if failed_resource?

    populate_filter_table_from_response
  end

  def to_s
    super(AzureMigrateProjectMachines)
  end

  private

  def populate_table
    @resources.each do |resource|
      @table << resource.merge(resource[:properties])
    end
  end
end
