require 'azure_generic_resources'

class AzureResourceHealthEvents < AzureGenericResources
  name 'azure_resource_health_events'
  desc 'Verifies settings for a collection of Azure Resource Health Events.'
  example <<-EXAMPLE
    describe azure_resource_health_events do
      its('names') { should include('role') }
    end

    describe azure_resource_health_events(resource_group: 'RESOURCE_GROUP_NAME', resource_type: 'Microsoft.Compute/virtualMachines', resource_id: 'RESOURCE_ID') do
      its('names') { should include('ROLE_NAME') }
    end
  EXAMPLE

  attr_reader :table

  def initialize(opts = {})
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    resource_type = opts.delete(:resource_type)
    resource_id = opts.delete(:resource_id)

    opts[:resource_provider] = specific_resource_constraint('Microsoft.ResourceHealth/events', opts)
    if opts.key?(:resource_group) && resource_type && resource_id
      opts[:resource_uri] = ['resourcegroups', opts.delete(:resource_group), 'providers', resource_type, resource_id,
                             'providers', opts[:resource_provider]].join('/')
      opts[:add_subscription_id] = true
    end
    super(opts, true)
    return if failed_resource?

    table_schema = [
      { column: :ids, field: :id },
      { column: :names, field: :name },
      { column: :properties, field: :properties },
      { column: :types, field: :type },
    ]
    AzureGenericResources.populate_filter_table(:table, table_schema)
  end

  def to_s
    super(AzureResourceHealthEvents)
  end
end
