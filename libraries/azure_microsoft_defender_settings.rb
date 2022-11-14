require 'azure_generic_resources'

class AzureMicrosoftDefenderSettings < AzureGenericResources
  name 'azure_microsoft_defender_settings'
  desc 'Verifies settings for microsoft defender settings.'
  example <<-EXAMPLE
    describe azure_microsoft_defender_settings do
      it { should exist }
    end
  EXAMPLE
  
  attr_reader :table
  
  def initialize(opts = {})
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)
    raise ArgumentError, '`resource_group` is not allowed.' if opts.key(:resource_group)
    
    opts[:resource_provider] = specific_resource_constraint('Microsoft.Security/settings', opts)
    
    # `built_in_only` is a resource specific parameter as oppose to the `api_version`.
    # That's why it should be put in allowed_parameters to be able to pass the parameter validation in the backend.
    opts[:allowed_parameters] = %i(built_in_only)
    opts[:resource_uri] = '/providers/Microsoft.Security/settings'
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
      { column: :ids, field: :id },
      { column: :names, field: :name },
      { column: :types, field: :type },
      { column: :kinds, field: :kind },
      { column: :properties, field: :properties },
    ]
    
    # FilterTable is populated at the very end due to being an expensive operation.
    AzureGenericResources.populate_filter_table(:table, table_schema)
  end
  
  def to_s
    super(AzureMicrosoftDefenderSettings)
  end
end
