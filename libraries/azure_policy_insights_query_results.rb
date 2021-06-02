require 'azure_generic_resources'

class AzurePolicyInsightsQueryResults < AzureGenericResources
  name 'azure_policy_insights_query_results'
  desc 'Lists a collection of Azure Policy Insights Query Results'
  example <<-EXAMPLE
    describe azure_policy_insights_query_results(policy_definition: 'de875639-505c-4c00-b2ab-bb290dab9a54') do
      it { should exist }
    end
  EXAMPLE
  attr_reader :table

  def initialize(opts = {})
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    # this is set so that we can run validations
    # new @opts will be set inside parent classes
    @opts = opts
    validate_parameters(required: %i(policy_definition), allow: %i(filter_free_text))
    resource_provider = specific_resource_constraint('Microsoft.Authorization/policyDefinitions', opts)
    opts[:resource_uri] = ['providers',  resource_provider, opts.delete(:policy_definition),
                           'providers/Microsoft.PolicyInsights/policyStates/latest/queryResults'].join('/')
    opts[:add_subscription_id] = true
    opts[:method] = 'post'

    super

    return if failed_resource?

    @table.map! do |row|
      row.transform_keys! { |col| col.to_s.snakecase.to_sym }
      row[:timestamp] = Time.parse(row[:timestamp])
      row
    end

    table_schema = [
      { column: :resource_ids, field: :resource_id, style: :simple },
      { column: :policy_assignment_ids, field: :policy_assignment_id, style: :simple },
      { column: :policy_definition_ids, field: :policy_definition_id, style: :simple },
      { column: :is_compliant, field: :is_compliant, style: :simple },
      { column: :subscription_ids, field: :subscription_id, style: :simple },
      { column: :resource_types, field: :resource_type, style: :simple },
      { column: :resource_locations, field: :resource_location, style: :simple },
      { column: :resource_groups, field: :resource_group, style: :simple },
      { column: :resource_tags, field: :resource_tags, style: :simple },
      { column: :policy_assignment_names, field: :policy_assignment_name, style: :simple },
      { column: :policy_definition_names, field: :policy_definition_name, style: :simple },
      { column: :policy_assignment_scopes, field: :policy_assignment_scope, style: :simple },
      { column: :policy_definition_actions, field: :policy_definition_action, style: :simple },
      { column: :policy_definition_categories, field: :policy_definition_category, style: :simple },
      { column: :policy_assignment_parameters, field: :policy_assignment_parameters, style: :simple },
      { column: :management_group_ids, field: :management_group_ids, style: :simple },
      { column: :compliance_states, field: :compliance_state, style: :simple },
      { column: :compliance_reason_codes, field: :compliance_reason_code, style: :simple },
      { column: :timestamps, field: :timestamp, style: :simple },
    ]

    AzureGenericResources.populate_filter_table(:table, table_schema)
  end

  def to_s
    super(AzurePolicyInsightsQueryResults)
  end
end
