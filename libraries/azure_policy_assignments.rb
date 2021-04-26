require 'azure_generic_resources'

class AzurePolicyAssignments < AzureGenericResources
  name 'azure_policy_assignments'
  desc 'Verifies settings for a collection of policy assignments'
  example <<-EXAMPLE
    # For property names see https://docs.microsoft.com/en-us/rest/api/policy/policyassignments/list#policyassignment

    describe azure_policy_assignments.where{ enforcement_mode != 'Default' } do
        it {should_not exist}
        its('display_names') {should eq []}
    end
  EXAMPLE

  attr_reader :table

  def initialize(opts = {})
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    # Azure REST API endpoint URL format listing the all resources for a given subscription:
    #   GET https://management.azure.com/subscriptions/{subscriptionId}/providers/{resourceProvider}
    #   Our resourceProvider is Microsoft.Authorization/policyAssignments
    opts[:resource_provider] = specific_resource_constraint('Microsoft.Authorization/policyAssignments', opts)

    # static_resource parameter must be true for setting the resource_provider in the backend.
    super(opts, true)

    # Check if the resource is failed.
    # It is recommended to check that after every usage of inherited methods or making API calls.
    return if failed_resource?

    AzurePolicyAssignments.populate_filter_table(:table)
  end

  # Define the column and field names for FilterTable.
  # In most cases, the `column` should be the pluralized form of the `field`.
  # @see https://github.com/inspec/inspec/blob/master/docs/dev/filtertable-usage.md
  def self.populate_filter_table(raw_data)
    # Top level fields
    filter_table = FilterTable.create
    filter_table.register_column(:ids,          field: :id)
    filter_table.register_column(:identities,   field: :identity)
    filter_table.register_column(:locations,    field: :location)
    filter_table.register_column(:names,        field: :name)
    filter_table.register_column(:types,        field: :type)
    filter_table.register_column(:properties,   field: :properties)

    # Sub fields are registered with blocks instead of top level field names
    filter_table.register_column(:descriptions)       { |p| p.entries.map { |e| e.dig(:properties, :description) } }
    filter_table.register_column(:display_names)      { |p| p.entries.map { |e| e.dig(:properties, :displayName) } }
    filter_table.register_column(:enforcement_modes)  { |p| p.entries.map { |e| e.dig(:properties, :enforcementMode) } }
    filter_table.register_column(:meta_datas)         { |p| p.entries.map { |e| e.dig(:properties, :metadata) } }
    filter_table.register_column(:non_compliance_messages) { |p| p.entries.map { |e| e.dig(:properties, :nonComplianceMessages) } }
    filter_table.register_column(:excluded_scopes)    { |p| p.entries.map { |e| e.dig(:properties, :notScopes) } }
    filter_table.register_column(:parameters)         { |p| p.entries.map { |e| e.dig(:properties, :parameters) } }
    filter_table.register_column(:definition_ids)     { |p| p.entries.map { |e| e.dig(:properties, :policyDefinitionId) } }
    filter_table.register_column(:scopes)             { |p| p.entries.map { |e| e.dig(:properties, :scope) } }
    filter_table.register_column(:assigned_by)        { |p| p.entries.map { |e| e.dig(:properties, :metadata, :assignedBy) } }
    filter_table.register_column(:created_by)         { |p| p.entries.map { |e| e.dig(:properties, :metadata, :createdBy) } }
    filter_table.register_column(:created_on)         { |p| p.entries.map { |e| e.dig(:properties, :metadata, :createdOn) } }
    filter_table.register_column(:updated_by)         { |p| p.entries.map { |e| e.dig(:properties, :metadata, :updatedBy) } }
    filter_table.register_column(:updated_on)         { |p| p.entries.map { |e| e.dig(:properties, :metadata, :updatedOn) } }

    # Connect the filter table to the data
    filter_table.install_filter_methods_on_resource(self, raw_data)
  end

  def to_s
    'AzurePolicyAssignments'
  end
end
