require 'azure_generic_resources'

class AzureContainerGroups < AzureGenericResources
  name 'azure_container_groups'
  desc 'Verifies settings for a list of azure container groups in a subscription.'
  example <<-EXAMPLE
    describe azure_container_groups do
      it { should exist }
    end
  EXAMPLE

  attr_reader :table

  def initialize(opts = {})
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    opts[:resource_provider] = specific_resource_constraint('Microsoft.ContainerInstance/containerGroups', opts)
    super(opts, true)
    return if failed_resource?

    @table.map! do |row|
      props = row[:properties]
      row.merge!(props.transform_keys { |prop| prop.to_s.snakecase.to_sym })
      row
    end

    table_schema = [
      { column: :ids, field: :id },
      { column: :locations, field: :location },
      { column: :names, field: :name },
      { column: :types, field: :type },
      { column: :tags, field: :tags },
      { column: :properties, field: :properties }, # only intended for complex use case
      { column: :containers, field: :containers },
      { column: :init_containers, field: :init_containers },
      { column: :image_registry_credentials, field: :image_registry_credentials },
      { column: :ip_address, field: :ip_address },
      { column: :os_types, field: :os_type },
      { column: :provisioning_states, field: :provisioning_state },
      { column: :volumes, field: :volumes },
      { column: :skus, field: :sku },
      { column: :restart_policies, field: :restart_policy },
    ]

    AzureGenericResources.populate_filter_table(:table, table_schema)
  end

  def to_s
    super(AzureContainerGroups)
  end
end
