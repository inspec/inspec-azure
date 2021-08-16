require 'azure_generic_resource'

class AzureMigrateAssessmentMachine < AzureGenericResource
  name 'azure_migrate_assessment_machine'
  desc 'Verifies settings for a collection of Azure Migrate Assessments in a project'
  example <<-EXAMPLE
    describe azure_migrate_assessment_machine(resource_group: 'migrated_vms', project_name: 'zoneA_migrate_assessment_project', name: '') do
        it { should exist }
    end
  EXAMPLE

  def initialize(opts = {})
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    opts[:resource_provider] = specific_resource_constraint('Microsoft.Migrate/assessmentProjects', opts)
    opts[:required_parameters] = %i(project_name)
    opts[:resource_path] = [opts[:project_name], 'machines'].join('/')
    super(opts, true)
  end

  def to_s
    super(AzureMigrateAssessmentMachines)
  end
end
