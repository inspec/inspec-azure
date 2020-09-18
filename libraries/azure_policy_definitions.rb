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
    opts[:allowed_parameters] = %i(built_in_only)


    opts[:resource_provider] = specific_resource_constraint('Microsoft.Authorization/policyDefinitions', opts)
    opts[:resource_uri] = '/providers/Microsoft.Authorization/policyDefinitions'
    opts[:add_subscription_id] = opts.dig(:built_in_only) != true

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
      { column: :tags, field: :tags },
      { column: :locations, field: :location },
      { column: :properties, field: :properties },
    ]

    # FilterTable is populated at the very end due to being an expensive operation.
    AzureGenericResources.populate_filter_table(:table, table_schema)
  end

  def to_s
    super(AzurePolicyDefinitions)
  end
end
