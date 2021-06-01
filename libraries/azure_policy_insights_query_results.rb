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

    table_schema = [
      { column: :resourceIds, field: :resourceId, style: :simple },
      { column: :policyAssignmentIds, field: :policyAssignmentId, style: :simple },
      { column: :policyDefinitionIds, field: :policyDefinitionId, style: :simple },
      { column: :isCompliant, field: :isCompliant, style: :simple },
      { column: :subscriptionIds, field: :subscriptionId, style: :simple },
      { column: :resourceTypes, field: :resourceType, style: :simple },
      { column: :resourceLocations, field: :resourceLocation, style: :simple },
      { column: :resourceGroups, field: :resourceGroup, style: :simple },
      { column: :resourceTags, field: :resourceTags, style: :simple },
      { column: :policyAssignmentNames, field: :policyAssignmentName, style: :simple },
      { column: :policyDefinitionNames, field: :policyDefinitionName, style: :simple },
      { column: :policyAssignmentScopes, field: :policyAssignmentScope, style: :simple },
      { column: :policyDefinitionActions, field: :policyDefinitionAction, style: :simple },
      { column: :policyDefinitionCategories, field: :policyDefinitionCategory, style: :simple },
      { column: :managementGroupIds, field: :managementGroupIds, style: :simple },
      { column: :complianceStates, field: :complianceState, style: :simple },
    ]

    AzureGenericResources.populate_filter_table(:table, table_schema)
  end

  def to_s
    super(AzurePolicyInsightsQueryResults)
  end
end

# Provide the same functionality under the old resource name.
# This is for backward compatibility.
class AzurermPolicyInsightsQueryResults < AzurePolicyInsightsQueryResults
  name 'azurerm_policy_insights_query_results'
  desc 'Verifies settings for an Azure Container Registry'
  example <<-EXAMPLE
    describe azurerm_policy_insights_query_results(policy_definition: '') do
      it { should exist }
    end
  EXAMPLE

  def initialize(opts = {})
    Inspec::Log.warn Helpers.resource_deprecation_message(@__resource_name__, AzurePolicyInsightsQueryResults.name)
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    # For backward compatibility.
    opts[:api_version] ||= '2019-05-01'
    super
  end
end
