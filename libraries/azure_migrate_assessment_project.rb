require "azure_generic_resource"

class AzureMigrateAssessmentProject < AzureGenericResource
  name "azure_migrate_assessment_project"
  desc "Retrieves and verifies the settings of a Azure Migrate Assessment Project"
  example <<-EXAMPLE
    describe azure_migrate_assessment(resource_group: 'migrated_vms', name: 'zoneA_migrate_assessment_project') do
      it { should exist }
    end
  EXAMPLE

  def initialize(opts = {})
    raise ArgumentError, "Parameters must be provided in an Hash object." unless opts.is_a?(Hash)

    opts[:resource_provider] = specific_resource_constraint("Microsoft.Migrate/assessmentProjects", opts)
    super(opts, true)
  end

  def to_s
    super(AzureMigrateAssessmentProject)
  end
end
