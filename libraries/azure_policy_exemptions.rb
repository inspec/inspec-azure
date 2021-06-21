require 'azure_generic_resources'

class AzurePolicyExemptions < AzureGenericResources
  name 'azure_policy_exemptions'
  desc 'Retrieves and verifies all policy exemptions that apply to a subscription'
  example <<-EXAMPLE
    describe azure_policy_exemptions do
      it { should exist }
    end
  EXAMPLE

  def initialize(opts = {})
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    opts[:resource_provider] = specific_resource_constraint('Microsoft.Authorization/policyExemptions', opts)
    super(opts, true)

    return if failed_resource?

    @table.map! do |row|
      row.merge!(row[:properties].transform_keys { |i| i.to_s.snakecase.to_sym })
      row.merge!(row[:systemData].transform_keys { |i| i.to_s.snakecase.to_sym })
      row
    end

    table_schema = [
      { column: :ids, field: :id },
      { column: :names, field: :name },
      { column: :types, field: :type },
      { column: :properties, field: :properties },
      { column: :system_data, field: :systemData },
      { column: :policy_assignment_ids, field: :policy_assignment_id },
      { column: :policy_definition_reference_ids, field: :policy_definition_reference_ids },
      { column: :exemption_categories, field: :exemption_category },
      { column: :display_names, field: :display_name },
      { column: :descriptions, field: :description },
      { column: :metadata, field: :metadata },
      { column: :created_by, field: :created_by },
      { column: :created_by_types, field: :created_by_type },
      { column: :created_at, field: :created_at },
      { column: :last_modified_by, field: :last_modified_by },
      { column: :last_modified_by_types, field: :last_modified_by_type },
      { column: :last_modified_at, field: :last_modified_at },
    ]

    AzureGenericResources.populate_filter_table(:table, table_schema)
  end

  def to_s
    super(AzurePolicyExemptions)
  end
end
