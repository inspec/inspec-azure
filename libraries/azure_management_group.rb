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
    opts[:resource_uri] = "providers/#{opts[:resource_provider]}"
    opts[:add_subscription_id] = false
    opts[:resource_identifiers] = %i(group_id)
    opts[:allowed_parameters] = %i(expand recurse filter)
    # For backward compatibility.
    opts[:query_parameters] = {
      '$recurse' => opts[:recurse] || false,
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

  def parent_name
    return unless exists?
    properties&.details&.parent&.name
  end

  def parent_id
    return unless exists?
    properties&.details&.parent&.id
  end

  def parent_display_name
    return unless exists?
    properties&.details&.parent&.displayName
  end

  def children_display_names
    return unless exists?
    return [] if children.nil?
    Array(children).map(&:displayName)
  end

  def children_ids
    return unless exists?
    return [] if children.nil?
    Array(children).map(&:id)
  end

  def children_names
    return unless exists?
    return [] if children.nil?
    Array(children).map(&:name)
  end

  def children_roles
    return unless exists?
    return [] if children.nil?
    Array(children).map(&:roles)
  end

  def children_types
    return unless exists?
    return [] if children.nil?
    Array(children).map(&:type)
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
