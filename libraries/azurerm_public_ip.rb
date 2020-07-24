# frozen_string_literal: true

require 'azurerm_resource'

class AzurermPublicIp < AzurermSingularResource
  name 'azurerm_public_ip'
  desc 'Verifies settings for public IP address'
  example <<-EXAMPLE
    describe azurerm_public_ip(resource_group: 'example', name: 'name') do
      its(name) { should eq 'name'}
    end
  EXAMPLE

  ATTRS = %i(
    name
    id
    etag
    type
    location
    tags
    properties
  ).freeze

  attr_reader(*ATTRS)

  def initialize(resource_group: nil, name: nil)
    resp = management.public_ip(resource_group, name)
    return if has_error?(resp)

    assign_fields(ATTRS, resp)

    @exists = true
  end

  def to_s
    "'#{name}' Public IP address"
  end
end
