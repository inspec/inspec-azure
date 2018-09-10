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
    secure_transfer_enabled
  ).freeze

  attr_reader(*ATTRS)

  def initialize(opt = { name: 'default', resource_group: nil })
    resp = management.storage_account(opt[:resource_group], opt[:name])
    return if has_error?(resp)

    @name                    = resp.name
    @id                      = resp.id
    @secure_transfer_enabled = resp.properties.supportsHttpsTrafficOnly

    @exists = true
  end

  def has_secure_transfer_enabled?
    !!secure_transfer_enabled
  end

  def to_s
    "#{name} Storage Account"
  end
end
