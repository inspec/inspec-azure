# frozen_string_literal: true

require 'azurerm_resource'

class AzurermEventHubAuthorizationRule < AzurermSingularResource
  name 'azurerm_event_hub_authorization_rule'
  desc 'Verifies settings for Event Hub Authorization Rule'
  example <<-EXAMPLE
    describe azurerm_event_hub_authorization_rule(resource_group: 'example', namespace_name: 'namespace-ns', event_hub_endpoint: 'eventhub', authorization_rule_name: 'auth-rule'") do
      its(name) { should eq 'name'}
    end
  EXAMPLE

  ATTRS = %i(
    name
    id
    type
    properties
  ).freeze

  attr_reader(*ATTRS)

  def initialize(resource_group: nil, namespace_name: nil, event_hub_endpoint: nil, authorization_rule: nil)
    resp = management.event_hub_authorization_rule(resource_group, namespace_name, event_hub_endpoint, authorization_rule)
    return if has_error?(resp)

    assign_fields(ATTRS, resp)

    @exists = true
  end

  def to_s
    "'#{name}' Event Hub Authorization Rule"
  end
end
