# frozen_string_literal: true

require "azurerm_resource"

class AzurermWebapps < AzurermPluralResource
  name "azurerm_webapps"
  desc "Verifies settings for Webapps"
  example <<-EXAMPLE
    azurerm_webapps(resource_group: 'example') do
      it{ should exist }
    end
  EXAMPLE

  FilterTable.create
    .register_column(:names, field: "name")
    .register_column(:properties, field: "properties")
    .install_filter_methods_on_resource(self, :table)

  attr_reader :table

  def initialize(resource_group: nil)
    resp = management.webapps(resource_group)
    return if has_error?(resp)

    @table = resp
  end

  def to_s
    "Webapps"
  end
end
