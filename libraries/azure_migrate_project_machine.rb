require 'azure_generic_resource'

class AzureMigrateProjectMachine < AzureGenericResource
  name 'azure_migrate_project_machine'
  desc 'Retrieves and verifies the settings of an Azure Migrate Project Machine.'
  example <<-EXAMPLE
    describe azure_migrate_project_machine(resource_group: 'RESOURCE_GROUP_NAME', project_name: 'MIGRATE_PROJ_NAME', name: 'MIGRATE_PROJ_MACHINE_NAME') do
      it { should exist }
    end
  EXAMPLE

  def initialize(opts = {})
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    opts[:resource_provider] = specific_resource_constraint('Microsoft.Migrate/migrateProjects', opts)
    opts[:required_parameters] = %i(project_name)
    opts[:resource_path] = [opts[:project_name], 'machines'].join('/')
    super(opts, true)
  end

  def to_s
    super(AzureMigrateProjectMachine)
  end
end
