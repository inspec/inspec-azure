require 'azure_generic_resource'

class AzureMigrateAssessment < AzureGenericResource
  name 'azure_migrate_assessment'
  desc 'Retrieves and verifies the settings of a container group instance.'
  example <<-EXAMPLE
    describe azure_migrate_assessment(resource_group: 'migrated_vms', project_name: 'zoneA_migrate_assessment_project', group_name: 'zoneA_machines_group', name: 'zoneA_machines_migrate_assessment') do
      it { should exist }
    end
  EXAMPLE

  def initialize(opts = {})
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    opts[:resource_provider] = specific_resource_constraint('Microsoft.Migrate/assessmentProjects', opts)
    opts[:required_parameters] = %i(project_name group_name name)
    opts[:resource_path] = [opts[:project_name], 'groups', opts[:group_name], 'assessments'].join('/')
    super(opts, true)
  end
end
