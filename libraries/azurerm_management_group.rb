# frozen_string_literal: true

require 'azurerm_resource'

class AzurermManagementGroup < AzurermSingularResource
  name 'azurerm_management_group'
  desc 'Verifies settings for an Azure Management Group'
  example <<-EXAMPLE
    describe azurerm_management_group(group_id: 'example-group') do
      it { should exist }
    end
  EXAMPLE

  ATTRS = [
    :id,
    :type,
    :name,
    :parent,
  ].freeze

  PROPERTY_ATTRS = {
    children:     :children,
    display_name: :displayName,
    roles:        :roles,
    tenant_id:    :tenantId,
  }.freeze

  attr_reader(*ATTRS, *PROPERTY_ATTRS.keys)

  def initialize(group_id:, expand: nil, recurse: false, filter: nil)
    resp = management.management_group(group_id, expand: expand, recurse: recurse, filter: filter)
    return if has_error?(resp)

    @id = resp.id
    @type = resp.type
    @name = resp.name
    @parent = resp.properties.details.parent

    assign_fields_with_map(PROPERTY_ATTRS, resp.properties)

    @exists = true
  end

  def to_s
    "'#{name}' Management Group"
  end

  def parent_name
    parent.name
  end

  def parent_id
    parent.id
  end

  def parent_display_name
    parent.displayName
  end

  def children_display_names
    Array(children).map(&:displayName)
  end

  def children_ids
    Array(children).map(&:id)
  end

  def children_names
    Array(children).map(&:name)
  end

  def children_roles
    Array(children).map(&:roles)
  end

  def children_types
    Array(children).map(&:type)
  end
end
