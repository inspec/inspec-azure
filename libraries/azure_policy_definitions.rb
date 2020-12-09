require 'azure_generic_resources'

class AzurePolicyDefinitions < AzureGenericResources
  name 'azure_policy_definitions'
  desc 'Verifies settings for multiple policy definitions'
  example <<-EXAMPLE
    azure_policy_definitions(built_in: true) do
      it{ should exist }
    end
  EXAMPLE

  attr_reader :table

  def initialize(opts = {})
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    # Azure REST API endpoint URL format for the resource:
    #   for a policy in a subscription:
    #   GET https://management.azure.com/subscriptions/{subscriptionId}/providers/
    #     Microsoft.Authorization/policyDefinitions?api-version=2019-09-01
    #
    #   for a built-in policy: see => https://docs.microsoft.com/en-us/azure/governance/policy/samples/built-in-policies
    #   GET https://management.azure.com/providers/
    #     Microsoft.Authorization/policyDefinitions?api-version=2019-09-01
    #
    # The dynamic part that has to be created in this resource:
    #   Microsoft.Authorization/policyDefinitions?api-version=2019-09-01
    #
    # Parameters acquired from environment variables:
    #   - {subscriptionId} => Optional parameter. It will be acquired by the backend from environment variables.
    #
    # User supplied parameters:
    #   - built_in_only => Optional parameter. Indicates whether the policy definitions are built-in. Default is `false`.
    #   - api_version => Optional parameter. The latest version will be used unless provided.
    #
    # Following resource parameters have to be defined here.
    #   - resource_provider => Microsoft.Authorization/policyDefinitions
    #     The `specific_resource_constraint` method will validate the user input
    #       not to accept a different `resource_provider`.
    #     It should be the first parameter defined.
    #   - resource_uri => /providers/Microsoft.Authorization/policyDefinitions
    #   - add_subscription_id => Indicates whether subscription ID should be added to the resource_uri or not.
    #     This is `false` for built-in policy definitions and it is bound to user-supplied `built_in_only` parameter.
    #     Default is `true`.
    #

    opts[:resource_provider] = specific_resource_constraint('Microsoft.Authorization/policyDefinitions', opts)

    # `built_in_only` is a resource specific parameter as oppose to the `api_version`.
    # That's why it should be put in allowed_parameters to be able to pass the parameter validation in the backend.
    opts[:allowed_parameters] = %i(built_in_only)
    opts[:resource_uri] = '/providers/Microsoft.Authorization/policyDefinitions'
    opts[:add_subscription_id] = opts[:built_in_only] != true

    # static_resource parameter must be true for setting the resource_provider in the backend.
    super(opts, true)

    # Check if the resource is failed.
    # It is recommended to check that after every usage of inherited methods or making API calls.
    return if failed_resource?

    # Define the column and field names for FilterTable.
    # In most cases, the `column` should be the pluralized form of the `field`.
    # @see https://github.com/inspec/inspec/blob/master/docs/dev/filtertable-usage.md
    table_schema = [
      { column: :names, field: :name },
      { column: :ids, field: :id },
      { column: :properties, field: :properties },
    ]

    # FilterTable is populated at the very end due to being an expensive operation.
    AzureGenericResources.populate_filter_table(:table, table_schema)
  end

  def to_s
    super(AzurePolicyDefinitions)
  end
end
