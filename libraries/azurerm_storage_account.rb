# frozen_string_literal: true

require 'azurerm_resource'

class AzurermStorageAccout < AzurermSingularResource
  name 'azurerm_storage_account'
  desc 'Verifies settings for a Azure Storage Account'
  example <<-EXAMPLE
    describe azurerm_storage_account(resource_group: resource_name, name: 'default') do
      it { should exist }
      its('secure_transfer_enabled') { should be true }
    end
  EXAMPLE

  ATTRS = %i(
    name
    id
    properties
  ).freeze

  attr_reader(*ATTRS)

  def initialize(name: 'default', resource_group: nil)
    resp = management.storage_account(resource_group, name)
    return if has_error?(resp)

    @name       = resp.name
    @id         = resp.id
    @properties = resp.properties

    @exists = true
  end

  def to_s
    "#{name} Storage Account"
  end
end
