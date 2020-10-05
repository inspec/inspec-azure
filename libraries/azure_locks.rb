require 'azure_generic_resources'

class AzureLocks < AzureGenericResources
  name 'azure_locks'
  desc 'Verifies settings for an Azure Lock on a Resource'
  example <<-EXAMPLE
    describe azure_locks(resource_group: 'my-rg', resource_name: 'my-vm', resource_type: 'Microsoft.Compute/virtualMachines') do
      it { should exist }
    end
  EXAMPLE

  attr_reader :table

  def initialize(opts = {})
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    # Resource level parameter validation is done here due to `resource_type` is a special parameter in the backend.
    if opts[:resource_id]
      opts[:resource_name] = opts[:resource_id].split('/').last
      opts[:resource_group], provider, r_type = Helpers.res_group_provider_type_from_uri(opts[:resource_id])
      opts[:type] = [provider, r_type].join('/')
      # `resource_id` is not allowed for plural resources in the backend
      opts.delete(:resource_id)
    elsif opts[:resource_name]
      required_params = [:resource_group, :resource_name, :resource_type]
      missing_params = required_params - opts.keys
      raise ArgumentError, "#{missing_params} must be provided." unless missing_params.empty?
      # `resource_type` is a special parameter in the backend.
      # Change the key name here to something else
      opts[:type] = opts[:resource_type]
      opts.delete(:resource_type)
    end

    # This validation is done at this point due to the `resource_type` => `type` conversion has to happen before
    opts[:resource_provider] = specific_resource_constraint('Microsoft.Authorization/locks', opts)
    # This is for passing the validation in the backend.
    opts[:allowed_parameters] = %i(resoure_id resource_group resource_name type)

    opts[:resource_uri] = "/providers/#{opts[:resource_provider]}"
    opts[:resource_uri].prepend("/providers/#{opts[:type]}/#{opts[:resource_name]}") unless opts[:resource_name].nil?
    opts[:resource_uri].prepend("/resourceGroups/#{opts[:resource_group]}") unless opts[:resource_group].nil?
    opts[:add_subscription_id] = true

    # static_resource parameter must be true for setting the resource_provider in the backend.
    super(opts, true)

    # Check if the resource is failed.
    # It is recommended to check that after every usage of inherited methods or making API calls.
    return if failed_resource?

    # Define the column and field names for FilterTable.
    # In most cases, the `column` should be the pluralized form of the `field`.
    table_schema = [
      { column: :names, field: :name },
      { column: :ids, field: :id },
      { column: :properties, field: :properties },
    ]

    # FilterTable is populated at the very end due to being an expensive operation.
    AzureGenericResources.populate_filter_table(:table, table_schema)
  end

  def to_s
    super(AzureLocks)
  end
end

# Provide the same functionality under the old resource name.
# This is for backward compatibility.
class AzurermLocks < AzureLocks
  name 'azurerm_locks'
  desc 'Verifies settings for an Azure Lock on a Resource'
  example <<-EXAMPLE
    describe azurerm_locks(resource_group: 'my-rg', resource_name: 'my-vm', resource_type: 'Microsoft.Compute/virtualMachines') do
      it { should exist }
    end
  EXAMPLE

  def initialize(opts = {})
    Inspec::Log.warn Helpers.resource_deprecation_message(@__resource_name__, AzureLocks.name)
    super
  end
end
