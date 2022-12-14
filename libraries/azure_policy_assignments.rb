require "azure_generic_resources"
require "time"
class AzurePolicyAssignments < AzureGenericResources
  name "azure_policy_assignments"
  desc "Verifies settings for a collection of policy assignments"
  example <<-EXAMPLE
    # For property names see https://docs.microsoft.com/en-us/rest/api/policy/policyassignments/list#policyassignment

    describe azure_policy_assignments.where{ enforcementMode != 'Default' } do
        it {should_not exist}
        its('displayNames') {should eq []}
    end
  EXAMPLE

  attr_reader :table

  def initialize(opts = {})
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, "Parameters must be provided in an Hash object." unless opts.is_a?(Hash)

    # Azure REST API endpoint URL format listing the all resources for a given subscription:
    #   GET https://management.azure.com/subscriptions/{subscriptionId}/providers/{resourceProvider}
    #   Our resourceProvider is Microsoft.Authorization/policyAssignments
    opts[:resource_provider] = specific_resource_constraint("Microsoft.Authorization/policyAssignments", opts)

    # static_resource parameter must be true for setting the resource_provider in the backend.
    super(opts, true)

    # Check if the resource is failed.
    # It is recommended to check that after every usage of inherited methods or making API calls.
    return if failed_resource?

    table_schema = [
      { column: :ids, field: :id },
      { column: :types, field: :type },
      { column: :names, field: :name },
      { column: :locations, field: :location },
      { column: :tags, field: :tags },
      { column: :displayNames, field: :displayName },
      { column: :policyDefinitionIds, field: :policyDefinitionId },
      { column: :scopes, field: :scope },
      { column: :notScopes, field: :notScopes },
      { column: :parameters, field: :parameters },
      { column: :enforcementMode, field: :enforcementModes },
      { column: :assignedBys, field: :assignedBy },
      { column: :parameterScopes, field: :parameterScopes },
      { column: :created_bys, field: :created_by },
      { column: :createdOns, field: :createdOn },
      { column: :updatedBys, field: :updatedBy },
      { column: :updatedOns, field: :updatedOn },
      { column: :identityPrincipalIds, field: :identityPrincipalId },
      { column: :identityTenantIds, field: :identityTenantId },
      { column: :identityTypes, field: :identityType },
    ]
    # Process the raw data to provide easy access to subkeys (dates in particular)
    table.map! { |r| enrich_row(r) }
    # FilterTable is populated at the very end due to being an expensive operation.
    AzureGenericResources.populate_filter_table(:table, table_schema)
  end

  def enrich_row(row)
    # Hoist the [properties] key to the top
    [:displayName, :policyDefinitionId, :scope, :notScopes, :parameters, :enforcementMode].each do |field|
      row[field] = row.dig(:properties, field)
    end

    # Hoist the [properties][metadata] key to the top (except for Time fields)
    [:assignedBy, :parameterScopes, :created_by, :updatedBy].each do |field|
      row[field] = row.dig(:properties, :metadata, field)
    end

    # Hoist the Time fields to the top
    [:createdOn, :updatedOn].each do |field|
      row[field] = Time.parse(row.dig(:properties, :metadata, field) || Time.new(0).to_s)
    end

    # Hoist the identity fields to the top and rename them to avoid clashes
    row[:identityPrincipalId] = row.dig(:identity, :principalId)
    row[:identityTenantId] = row.dig(:identity, :tenantId)
    row[:identityType] = row.dig(:identity, :type)

    # Clean up the row
    row.delete(:identity)
    row.delete(:properties)
    row
  end

  def to_s
    "AzurePolicyAssignments"
  end
end
