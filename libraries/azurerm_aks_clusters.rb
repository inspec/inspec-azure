# frozen_string_literal: true

require 'azurerm_resource'

class AzurermAksClusters < AzurermPluralResource
  name 'azurerm_aks_clusters'
  desc 'Verifies settings for AKS Clusters'
  example <<-EXAMPLE
    azurerm_aks_clusters(resource_group: 'example') do
      it{ should exist }
    end
  EXAMPLE

  attr_reader :table

  FilterTable.create
             .register_column(:names, field: 'name')
             .install_filter_methods_on_resource(self, :table)

  def initialize(resource_group: nil)
    resp = management.aks_clusters(resource_group)
    return if has_error?(resp)

    @table = resp
  end

  include Azure::Deprecations::StringsInWhereClause

  def to_s
    'AKS Clusters'
  end
end
