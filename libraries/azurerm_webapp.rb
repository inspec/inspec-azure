# frozen_string_literal: true

require 'azurerm_resource'

class AzurermWebapp < AzurermSingularResource
	name 'azurerm_webapp'
	desc 'Verifies the settings for Azure Webapps'
	example <<-EXAMPLE
		describe azurerm_webapp(resource_group: 'example', name: 'webapp-name') do
		it { should exist }
		end
	EXAMPLE

	ATTRS=%i(
		name
    id
    location
    identity
		properties
	).freeze

	attr_reader(*ATTRS)

	def initialize(resource_group: nil, name: nil)
		resp = management.webapp(resource_group, name)
		return if has_error?(resp)

		assign_fields(ATTRS, resp)

		@resource_group = resource_group
		@webapp_name = name	
    @exists = true
	end

  def to_s
    "Webapp: '#{name}'"
  end

	def auth_settings
    management.webapp_authentication_settings(@resource_group, @webapp_name)
	end

	def configuration
		management.webapp_configuration(@resource_group, @webapp_name)
  end

  def has_identity?
    identity.is_a?(Struct)
  end
  
  # def uses_latest_software?

  # end
end