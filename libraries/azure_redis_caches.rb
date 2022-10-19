require 'azure_generic_resource'

class AzureRedisCaches < AzureGenericResources
  name 'azure_redis_caches'
  desc 'Verifies settings for a list of redis cache resources in a resource group.'
  example <<-EXAMPLE
    describe azure_redis_caches(resource_group: 'RESOURCE_GROUP_NAME') do
      it { should exist }
    end
  EXAMPLE

  attr_reader :table

  def initialize(opts = {})
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    Validators.validate_parameters(resource_name: @__resource_name__,
                                   required: %i(resource_group),
                                   opts: opts)
    opts[:resource_provider] = specific_resource_constraint('Microsoft.Cache/redis', opts)
    opts[:resource_uri] = ['/resourceGroups', opts[:resource_group], 'providers', opts[:resource_provider]].join('/')
    opts[:add_subscription_id] = true
    super(opts, true)
    return if failed_resource?

    build_table
    table_schema = [
      { column: :ids, field: :id },
      { column: :locations, field: :location },
      { column: :names, field: :name },
      { column: :types, field: :type },
      { column: :tags, field: :tags },
      { column: :properties, field: :properties }, # only intended for complex use case
      { column: :instances_ssl_ports, field: :instances_ssl_ports },
      { column: :is_master_instance, field: :is_master_instance },
      { column: :is_primary_instance, field: :is_primary_instance },
      { column: :sku_names, field: :sku_name },
      { column: :sku_capacities, field: :sku_capacity },
      { column: :sku_families, field: :sku_family },
      { column: :max_clients, field: :max_clients },
      { column: :max_memory_reserves, field: :max_memory_reserved },
      { column: :max_fragmentation_memory_reserves, field: :max_fragmentation_memory_reserved },
      { column: :max_memory_deltas, field: :max_memory_delta },
      { column: :provisioning_states, field: :provisioning_state },
      { column: :redis_versions, field: :redis_version },
      { column: :enable_non_ssl_port, field: :enable_non_ssl_port },
      { column: :public_network_access, field: :public_network_access },
      { column: :access_keys, field: :access_keys },
      { column: :host_names, field: :host_name },
      { column: :ports, field: :port },
      { column: :ssl_ports, field: :ssl_port },
      { column: :linked_servers, field: :linked_servers },
    ]

    AzureGenericResources.populate_filter_table(:table, table_schema)
  end

  def to_s
    super(AzureRedisCaches)
  end

  private

  def build_table
    @table.map! do |row|
      # so we preserve properties for complex operations
      properties = row[:properties].dup

      instances = properties.delete(:instances)
      row[:is_primary_instance] = row[:is_master_instance] = row[:instances_ssl_ports] = []

      instances.each { |instance|
        row[:instances_ssl_ports] << instance[:sslPort]
        row[:is_master_instance] << instance[:isMaster]
        row[:is_primary_instance] << instance[:isPrimary]
      }

      sku = properties.delete(:sku)
      row[:sku_name] = sku[:name]
      row[:sku_size] = sku[:size]
      row[:sku_tier] = sku[:tier]
      row[:sku_capacity] = sku[:capacity]
      row[:sku_family] = sku[:family]

      redis_config = properties.delete(:redisConfiguration)
      row[:max_clients] = redis_config[:maxclients]
      row[:max_memory_reserved] = redis_config[:'maxmemory-reserved']
      row[:max_fragmentation_memory_reserved] = redis_config[:'maxfragmentationmemory-reserved']
      row[:max_memory_delta] = redis_config[:'maxmemory-delta']

      row.merge!(properties.transform_keys { |property| property.to_s.gsub(/([a-z\d])([A-Z])/, '\1_\2').downcase.to_sym })
      row
    end
  end
end
