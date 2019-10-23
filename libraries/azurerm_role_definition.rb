# frozen_string_literal: true

require 'azurerm_resource'

class AzurermRoleDefinition < AzurermSingularResource
  name 'azurerm_role_definition'
  desc 'Verifies settings for an Azure Role'
  example <<-EXAMPLE
    describe azurerm_role_definition(name: 'Mail-Account') do
      it                { should exist }
      its ('role_name') { should be 'Mail-Account' }
      its ('role_type') { should be 'CustomRole' }
    end
  EXAMPLE

  attr_reader(:id, :name, :role_name, :type, :role_type, :assignable_scopes, :permissions_allowed, :permissions_not_allowed)

  def initialize(name: nil)
    resp = management.role_definition(name)
    return if has_error?(resp)

    @exists       = true
    @id           = resp.id
    @name         = resp.name
    @role_name    = resp.properties.roleName
    @type         = resp.type
    @role_type    = resp.properties.type
    @assignable_scopes        = resp.properties.assignableScopes
    @permissions_allowed      = resp.properties.permissions.map(&:actions).flatten!
    @permissions_not_allowed  = resp.properties.permissions.map(&:notActions).flatten!
  end

  def to_s
    "Role Definition: '#{name}'"
  end
end
