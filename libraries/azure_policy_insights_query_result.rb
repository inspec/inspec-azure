require 'azure_backend'

class AzurePolicyInsightsQueryResult < AzureResourceBase
  name 'azure_policy_insights_query_result'
  desc 'Lists a collection of Azure Policy Insights Query Results'
  example <<-EXAMPLE
    describe azure_policy_insights_query_result(policy_definition: 'de875639-505c-4c00-b2ab-bb290dab9a54', resource_id: '/subscriptions/80b824de-ec53-4116-9868-3deeab10b0cd/resourcegroups/jfm-winimgbuilderrg2/providers/microsoft.virtualmachineimages/imagetemplates/win1021h1') do
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
    response.transform_keys! { |key| key.to_s.snakecase.to_sym }
    response[:timestamp] = Time.parse(response[:timestamp])
    create_resource_methods(response)
  end

  def failed_resource?
    @failed_resource ||= false
  end
end
