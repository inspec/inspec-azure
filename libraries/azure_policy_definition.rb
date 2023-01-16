require "azure_generic_resource"

class AzurePolicyDefinition < AzureGenericResource
  name "azure_policy_definition"
  desc "Verifies settings for a policy definition"
  example <<-EXAMPLE
    describe azure_policy_definition(name: 'policy_name') do
      it { should exist }
    end
  EXAMPLE

  def initialize(opts = {})
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, "Parameters must be provided in an Hash object." unless opts.is_a?(Hash)
    raise ArgumentError, "`resource_group` is not allowed." if opts.key(:resource_group)

    # Azure REST API endpoint URL format for the resource:
    #   for a policy in a subscription:
    #   GET https://management.azure.com/subscriptions/{subscriptionId}/providers/
    #     Microsoft.Authorization/policyDefinitions/{policyDefinitionName}?api-version=2019-09-01
    #
    #   for a built-in policy: see => https://docs.microsoft.com/en-us/azure/governance/policy/samples/built-in-policies
    #   GET https://management.azure.com/providers/
    #     Microsoft.Authorization/policyDefinitions/{policyDefinitionName}?api-version=2019-09-01
    #
    # The dynamic part that has to be created in this resource:
    #   Microsoft.Authorization/policyDefinitions/{policyDefinitionName}?api-version=2019-09-01
    #
    # Parameters acquired from environment variables:
    #   - {subscriptionId} => Optional parameter. It will be acquired by the backend from environment variables.
    #
    # User supplied parameters:
    #   - name => Required parameter unless `resource_id` is provided. Policy definition name. {policyDefinitionName}
    #   - built_in => Optional parameter. Indicates whether the policy definition is built-in. Default is `false`.
    #   - resource_id => Optional parameter. If exists, `name` or `built_in` must not be provided.
    #     In the following format:
    #       /{subscriptionId}/providers/Microsoft.Authorization/policyDefinitions/{policyDefinitionName}
    #   - api_version => Optional parameter. The latest version will be used unless provided.
    #
    #
    # Following resource parameters have to be defined here.
    #   - resource_provider => Microsoft.Authorization/policyDefinitions
    #     The `specific_resource_constraint` method will validate the user input
    #       not to accept a different `resource_provider`.
    #     It should be the first parameter defined.
    #   - resource_uri => /providers/Microsoft.Authorization/policyDefinitions
    #   - add_subscription_id => Indicates whether subscription ID should be added to the resource_uri or not.
    #     This is `false` for built-in policy definitions and it is bound to user-supplied `built_in` parameter.
    #     Default is `true`.
    #
    opts[:resource_provider] = specific_resource_constraint("Microsoft.Authorization/policyDefinitions", opts)

    # `built_in` is a resource specific parameter as oppose to `name` and `api_version`.
    # That's why it should be put in allowed_parameters to be able to pass the parameter validation in the backend.
    opts[:allowed_parameters] = %i(built_in)

    opts[:resource_uri] = "/providers/Microsoft.Authorization/policyDefinitions"
    opts[:add_subscription_id] = opts[:built_in] != true

    # static_resource parameter must be true for setting the resource_provider in the backend.
    super(opts, true)
  end

  def to_s
    super(AzurePolicyDefinition)
  end

  def custom?
    return unless exists?
    properties&.policyType&.downcase == "custom"
  end
end
