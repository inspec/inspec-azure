require 'azure_backend'

class AzurePolicyInsightsQueryResult < AzureResourceBase
  name 'azure_policy_insights_query_result'
  desc 'Lists a collection of Azure Policy Insights Query Results'
  example <<-EXAMPLE
    describe azure_policy_insights_query_result(policy_definition: '', resource_id: '') do
      it { should exist }
    end
  EXAMPLE

  def initialize(opts = {})
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)
    super(opts)
    @resource_provider = specific_resource_constraint('Microsoft.Authorization/policyDefinitions', @opts)
    validate_parameters(required: %i(policy_definition resource_id))
    @azure_resource_id = @opts.delete(:resource_id)
    @policy_definition = @opts.delete(:policy_definition)
    build_resource_uri
    @display_name = @opts[:resource_uri]
    query_params = build_query_params
    catch_failed_resource_queries do
      @api_response = get_resource(query_params)
    end
    return if failed_resource?

    build_resource_methods
  end

  def to_s
    "#{AzurePolicyInsightsQueryResult.name.split('_').map(&:capitalize).join(' ')} : #{@display_name}"
  end

  def exists?
    !failed_resource?
  end

  def compliant?
    isCompliant
  end

  private

  attr_reader :azure_resource_id, :policy_definition, :resource_provider

  def build_query_params
    query_params = { resource_uri: @opts[:resource_uri] }
    query_params[:query_parameters] = { '$filter' => "resourceId eq '#{azure_resource_id}'" }
    # Use the latest api_version unless provided.
    query_params[:query_parameters]['api-version'] = @opts[:api_version] || 'latest'
    query_params[:method] = 'post'
    query_params
  end

  def build_resource_uri
    @opts[:resource_uri] = validate_resource_uri({ resource_uri: ['providers', resource_provider, policy_definition,
                                                                  'providers/Microsoft.PolicyInsights/policyStates/latest/queryResults']
                                                                   .join('/'),
                                                   add_subscription_id: true })
    Validators.validate_resource_uri(@opts[:resource_uri])
  end

  def build_resource_methods
    if !@api_response.is_a?(Hash) || !@api_response[:value]
      resource_fail("Unable to get the detailed information for the resource_id: #{@resource_id}")
    end
    response = @api_response[:value].first
    response.delete(:"@odata.id")
    response.delete(:"@odata.context")
    create_resource_methods(response)
  end

  def failed_resource?
    @failed_resource ||= false
  end
end

# Provide the same functionality under the old resource name.
# This is for backward compatibility.
class AzurermPolicyInsightsQueryResult < AzurePolicyInsightsQueryResult
  name 'azurerm_policy_insights_query_result'
  desc 'Verifies settings for an Azure Container Registry'
  example <<-EXAMPLE
    describe azurerm_policy_insights_query_result(policy_definition: '') do
      it { should exist }
    end
  EXAMPLE

  def initialize(opts = {})
    Inspec::Log.warn Helpers.resource_deprecation_message(@__resource_name__, AzurePolicyInsightsQueryResult.name)
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    # For backward compatibility.
    opts[:api_version] ||= '2019-05-01'
    super
  end
end
