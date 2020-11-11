require 'azure_generic_resource'

class AzureManagementGroup < AzureGenericResource
  name 'azure_management_group'
  desc 'Verifies settings for an Azure Management Group'
  example <<-EXAMPLE
    describe azure_management_group(group_id: 'example-group') do
      it { should exist }
    end
  EXAMPLE

  def initialize(opts = {})
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    opts[:resource_provider] = specific_resource_constraint('Microsoft.Management/managementGroups', opts)
    opts[:resource_identifiers] = %i(group_id)
    opts[:allowed_parameters] = %i(expand recurse filter)
    opts[:query_parameters] = {
      '$recurse' => opts[:recurse] || 'false',
    }
    opts[:query_parameters].merge!('$expand' => opts[:expand]) unless opts[:expand].nil?
    # Note that $expand=children must be passed up if $recurse is set to true.
    if opts[:query_parameters]['$recurse']
      opts[:query_parameters]['$expand'] = 'children'
    end
    opts[:query_parameters].merge!('$filter' => opts[:filter]) unless opts[:filter].nil?

    # static_resource parameter must be true for setting the resource_provider in the backend.
    super(opts, true)
  end

  def to_s
    super(AzureManagementGroup)
  end

  # For backward compatibility
  def display_name
    return unless exists?
    properties&.displayName
  end

  def children
    return unless exists?
    properties&.children
  end

  def roles
    return unless exists?
    properties&.roles
  end

  def tenant_id
    return unless exists?
    properties&.tenantId
  end

  def parent
    return unless exists?
    properties&.details&.parent
  end
end

# Provide the same functionality under the old resource name.
# This is for backward compatibility.
class AzurermManagementGroup < AzureManagementGroup
  name 'azurerm_management_group'
  desc 'Verifies settings for an Azure Management Group'
  example <<-EXAMPLE
    describe azurerm_management_group(group_id: 'example-group') do
      it { should exist }
    end
  EXAMPLE

  def initialize(opts = {})
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    Inspec::Log.warn Helpers.resource_deprecation_message(@__resource_name__, AzureManagementGroup.name)
    super
  end
end
