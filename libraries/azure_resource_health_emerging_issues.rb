require 'azure_generic_resources'

class AzureResourceHealthEmergingIssues < AzureGenericResources
  name 'azure_resource_health_emerging_issues'
  desc "Lists and verifies Azure services' emerging issues"
  example <<-EXAMPLE
    describe azure_resource_health_emerging_issues do
      it { should exist }
    end
  EXAMPLE

  def initialize(opts = {})
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    opts[:resource_provider] = specific_resource_constraint('Microsoft.ResourceHealth/emergingIssues', opts)
    opts[:resource_uri] = ['providers', opts[:resource_provider]].join('/')
    opts[:add_subscription_id] = false
    super(opts, true)

    return if failed_resource?

    table_schema = [
      { column: :ids, field: :id },
      { column: :names, field: :name },
      { column: :properties, field: :properties },
      { column: :types, field: :type },
    ]
    AzureGenericResources.populate_filter_table(:table, table_schema)
  end

  def to_s
    super(AzureResourceHealthEmergingIssues)
  end
end
