require "azure_generic_resources"

class AzureMigrateProjectSolutions < AzureGenericResources
  name "azure_migrate_project_solutions"
  desc "Verifies settings for a collection of Azure Migrate Project Solutions for a Azure Migrate Project in a Resource Group"
  example <<-EXAMPLE
    describe azure_migrate_project_solutions(resource_group: 'migrated_vms', project_name: 'zoneA_migrate_project') do
        it { should exist }
    end
  EXAMPLE

  def initialize(opts = {})
    raise ArgumentError, "Parameters must be provided in an Hash object." unless opts.is_a?(Hash)

    opts[:resource_provider] = specific_resource_constraint("Microsoft.Migrate/migrateProjects", opts)
    opts[:required_parameters] = %i(project_name)
    opts[:resource_path] = [opts[:project_name], "solutions"].join("/")
    super(opts, true)
    return if failed_resource?

    populate_filter_table_from_response
  end

  def to_s
    super(AzureMigrateProjectSolutions)
  end

  private

  def populate_table
    @resources.each do |resource|
      props = resource[:properties]
      @table << resource.merge(props).merge(props[:summary]).merge(props[:details])
    end
  end
end
