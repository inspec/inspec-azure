# frozen_string_literal: true

require 'azurerm_resource'

class AzurermManagementGroups < AzurermPluralResource
  name 'azurerm_management_groups'
  desc 'Verifies settings for an Azure Management Groups'
  example <<-EXAMPLE
    describe azurerm_management_groups do
      its('groups_names') { should include 'example-group' }
    end
  EXAMPLE

  ATTRS = [
    :groups,
  ].freeze

  attr_reader(*ATTRS)

  def initialize
    resp = management.management_groups
    return if has_error?(resp)

    @groups = resp
  end

  def to_s
    'Management Groups'
  end

  def group_ids
    groups.map(&:id)
  end

  def group_types
    groups.map(&:type)
  end

  def group_names
    groups.map(&:name)
  end

  def group_tenant_ids
    groups.map { |x| x.properties.tenantId }
  end

  def group_display_names
    groups.map { |x| x.properties.displayName }
  end
end
