require 'azure_generic_resource'

class AzurePolicyDefinition < AzureGenericResource
  name 'azure_policy_definition'
  desc 'Verifies settings for a policy definition'
  example <<-EXAMPLE
    describe azure_policy_definition(name: 'policy_name') do
      it { should exist }
    end
  EXAMPLE

  def initialize(opts = {})
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)
    opts[:allowed_parameters] = %i(built_in_only)

    opts[:resource_provider] = specific_resource_constraint('Microsoft.Authorization/policyDefinitions', opts)
    # GET https://management.azure.com/providers/Microsoft.Authorization/policyDefinitions/{policyDefinitionName}?api-version=2019-09-01
    opts[:resource_uri] = '/providers/Microsoft.Authorization/policyDefinitions'

    opts[:add_subscription_id] = opts.dig(:built_in_only) != true

    # static_resource parameter must be true for setting the resource_provider in the backend.
    super(opts, true)
  end

  def to_s
    super(AzurePolicyDefinition)
  end
end
