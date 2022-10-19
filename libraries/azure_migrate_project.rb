require 'azure_generic_resource'

class AzureMigrateProject < AzureGenericResource
  name 'azure_migrate_project'
  desc 'Retrieves and verifies the settings of an Azure Migrate Project.'
  example <<-EXAMPLE
    describe azure_migrate_project(resource_group: 'RESOURCE_GROUP_NAME', name: 'MIGRATE_PROJ_NAME') do
      it { should exist }
    end
  EXAMPLE

  def initialize(opts = {})
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    opts[:resource_provider] = specific_resource_constraint('Microsoft.Migrate/migrateProjects', opts)
    super(opts, true)
  end

  def to_s
    super(AzureMigrateProject)
  end
end
