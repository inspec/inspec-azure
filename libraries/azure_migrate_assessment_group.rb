require 'azure_generic_resource'

class AzureMigrateAssessmentGroup < AzureGenericResource
  name 'azure_migrate_assessment_group'
  desc 'Retrieves and verifies the settings of a container group instance.'
  example <<-EXAMPLE
    describe azure_migrate_assessment_groups(resource_group: 'RESOURCE_GROUP_NAME', project_name: 'MIGRATE_PROJ_NAME', name: 'MIGRATE_ASSESSMENT_GROUP_NAME') do
      it { should exist }
    end
  EXAMPLE

  def initialize(opts = {})
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    opts[:resource_provider] = specific_resource_constraint('Microsoft.Migrate/assessmentProjects', opts)
    opts[:required_parameters] = %i(project_name name)
    opts[:resource_path] = [opts[:project_name], 'groups'].join('/')
    super(opts, true)
  end

  def to_s
    super(AzureMigrateAssessmentGroup)
  end
end
