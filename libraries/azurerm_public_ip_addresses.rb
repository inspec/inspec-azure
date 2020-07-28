# frozen_string_literal: true

require 'azurerm_resource'

class AzurermPublicIPAddresses < AzurermPluralResource
  name 'azurerm_public_ip_addresses'
  desc 'Verifies settings for a collection of Azure Public IP Address'
  example <<-EXAMPLE
    describe azure_public_ip_addresses do
      its('names')  { should include 'mypublicipaddress' }
    end
  EXAMPLE

  attr_reader :table

  FilterTable.create
             .register_column(:ids,        field: :id)
             .register_column(:names,      field: :name)
             .register_column(:skus,       field: :sku)
             .register_column(:locations,  field: :location)
             .register_column(:properties, field: :properties)
             .register_column(:types,      field: :type)
             .install_filter_methods_on_resource(self, :table)

  def initialize(resource_group: nil)
    public_ip_addresses = management.public_ip_addresses(resource_group)
    return if has_error?(public_ip_addresses)

    @table = public_ip_addresses
  end

  def to_s
    'Azure Public IP Addresses'
  end
end
