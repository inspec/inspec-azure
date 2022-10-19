require 'azure_generic_resource'

class AzureRoleDefinition < AzureGenericResource
  name 'azure_role_definition'
  desc 'Verifies settings for an Azure Role.'
  example <<-EXAMPLE
    describe azure_role_definition(name: 'Mail-Account') do
      it { should exist }
      its('role_name') { should be 'Mail-Account' }
      its('role_type') { should be 'CustomRole' }
    end
  EXAMPLE

  attr_reader :role_name, :role_type, :assignable_scopes, :permissions_allowed, :permissions_not_allowed

  def initialize(opts = {})
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)
    raise ArgumentError, '`resource_group` is not allowed.' if opts.key(:resource_group)

    opts[:resource_provider] = specific_resource_constraint('Microsoft.Authorization/roleDefinitions', opts)
    # See azure_policy_definitions resource for how to use `resource_uri` and `add_subscription_id` parameters.
    opts[:resource_uri] = "providers/#{opts[:resource_provider]}"
    opts[:add_subscription_id] = true

    # static_resource parameter must be true for setting the resource_provider in the backend.
    super(opts, true)

    return if failed_resource?

    @role_name = properties&.roleName
    @role_type = properties&.type
    @assignable_scopes = properties&.assignableScopes
    @permissions_allowed = properties&.permissions&.map(&:actions)&.flatten!
    @permissions_not_allowed = properties&.permissions&.map(&:notActions)&.flatten!
  end

  def to_s
    super(AzureRoleDefinition)
  end
end

# Provide the same functionality under the old resource name.
# This is for backward compatibility.
class AzurermRoleDefinition < AzureRoleDefinition
  name 'azurerm_role_definition'
  desc 'Verifies settings for an Azure Role'
  example <<-EXAMPLE
    describe azurerm_role_definition(name: 'Mail-Account') do
      it                { should exist }
      its ('role_name') { should be 'Mail-Account' }
      its ('role_type') { should be 'CustomRole' }
    end
  EXAMPLE

  def initialize(opts = {})
    Inspec::Log.warn Helpers.resource_deprecation_message(@__resource_name__, AzureRoleDefinition.name)
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    # For backward compatibility.
    opts[:api_version] ||= '2015-07-01'
    super
  end
end
