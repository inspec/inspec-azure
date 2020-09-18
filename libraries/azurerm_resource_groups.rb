# frozen_string_literal: true

require 'azurerm_resource'

class AzurermResourceGroups < AzurermPluralResource
  name 'azurerm_resource_groups'
  desc 'Fetches all available resource groups'
  example <<-EXAMPLE
    describe azurerm_resource_groups do
      its('names') { should include('example-group') }
    end
  EXAMPLE

  FilterTable.create
             .register_column(:names, field: :name)
             .register_column(:ids, field: :id)
             .register_column(:tags, field: :tags)
             .install_filter_methods_on_resource(self, :table)

  attr_reader :table

  def initialize
    resp = management.resource_groups
    return if has_error?(resp)

    resp.map! do |r|
      r=r.to_h
      r[:tags]={} unless r[:tags]
      r
    end
    @table = resp
  end

  include Azure::Deprecations::StringsInWhereClause

  def to_s
    'Resource Groups'
  end
end
