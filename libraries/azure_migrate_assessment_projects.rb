require 'azure_generic_resources'

class AzureMigrateAssessmentProjects < AzureGenericResources
  name 'azure_migrate_assessment_projects'
  desc 'Verifies settings for a collection of Azure Migrate Assessment Projects in a subscription'
  example <<-EXAMPLE
    describe azure_migrate_assessment_projects do
        it { should exist }
    end
  EXAMPLE

  def initialize(opts = {})
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    opts[:resource_provider] = specific_resource_constraint('Microsoft.Migrate/assessmentProjects', opts)
    super(opts, true)
    return if failed_resource?

    table_schema = @table.first.keys.map { |key| { column: key.to_s.pluralize.to_sym, field: key, style: :simple } }
    AzureGenericResources.populate_filter_table(:table, table_schema)
  end

  private

  def populate_table
    @resources.each do |resource|
      @table << resource.merge(resource[:properties])
    end
  end
end