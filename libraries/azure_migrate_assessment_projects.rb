require "azure_generic_resources"

class AzureMigrateAssessmentProjects < AzureGenericResources
  name "azure_migrate_assessment_projects"
  desc "Verifies settings for a collection of Azure Migrate Assessment Projects in a subscription"
  example <<-EXAMPLE
    describe azure_migrate_assessment_projects do
        it { should exist }
    end
  EXAMPLE

  def initialize(opts = {})
    raise ArgumentError, "Parameters must be provided in an Hash object." unless opts.is_a?(Hash)

    opts[:resource_provider] = specific_resource_constraint("Microsoft.Migrate/assessmentProjects", opts)
    super(opts, true)
    return if failed_resource?

    populate_filter_table_from_response
  end

  def to_s
    super(AzureMigrateAssessmentProjects)
  end

  private

  def populate_table
    @resources.each do |resource|
      @table << resource.merge(resource[:properties])
    end
  end
end
