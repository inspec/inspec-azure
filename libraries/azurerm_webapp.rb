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
    @auth_settings ||= management.webapp_authentication_settings(@resource_group, @webapp_name)
  end

  def configuration
    @configuration ||= management.webapp_configuration(@resource_group, @webapp_name)
  end

  # Returns the version of the given stack being used by the Webapp.
  # nil if stack not used. raises if stack invalid.
  def stack_version(stack)
    stack = 'netFramework' if stack.eql?('aspnet')
    stack_key = "#{stack}Version"
    raise ArgumentError, "#{stack} is not a supported stack." unless configuration.properties.respond_to?(stack_key)
    version = configuration.properties.public_send(stack_key.to_s)
    version.nil? || version.empty? ? nil : version
  end

  # Determines if the Webapp is using the given stack, and if the version
  # of that stack is the latest runtime supported by Azure.
  def using_latest?(stack)
    using = stack_version(stack)
    raise ArgumentError, "#{self} does not use Stack #{stack}" unless using
    latest = latest(stack)
    using[0] = '' if using[0].casecmp?('v')
    using.to_i >= latest.to_i
  end

  def has_identity?
    identity.is_a?(Struct)
  end

  private

  def latest(stack)
    latest_supported = supported_stacks.select { |s| s.name.eql?(stack) }
                                       .map { |e| e.properties.majorVersions.max_by(&:runtimeVersion).runtimeVersion }
                                       .reduce(:+)
    latest_supported[0] = '' if latest_supported[0].casecmp?('v')
    latest_supported
  end

  def supported_stacks
    @supported_stacks ||= management.webapp_supported_stacks
  end
end
