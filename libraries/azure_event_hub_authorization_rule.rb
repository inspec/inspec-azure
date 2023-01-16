require "azure_generic_resource"

class AzureEventHubAuthorizationRule < AzureGenericResource
  name "azure_event_hub_authorization_rule"
  desc "Verifies settings for Event Hub Authorization Rule"
  example <<-EXAMPLE
    describe azure_event_hub_authorization_rule(resource_group: 'example', namespace_name: 'namespace-ns', event_hub_endpoint: 'eventhub', authorization_rule_name: 'auth-rule'") do
      its(name) { should eq 'name'}
    end
  EXAMPLE

  def initialize(opts = {})
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, "Parameters must be provided in an Hash object." unless opts.is_a?(Hash)

    opts[:resource_provider] = specific_resource_constraint("Microsoft.EventHub/namespaces", opts)
    opts[:required_parameters] = %i(namespace_name event_hub_endpoint)
    opts[:resource_path] = [opts[:namespace_name], "eventhubs", opts[:event_hub_endpoint], "authorizationRules"].join("/")
    opts[:resource_identifiers] = %i(authorization_rule)

    # static_resource parameter must be true for setting the resource_provider in the backend.
    super(opts, true)
  end

  def to_s
    super(AzureEventHubAuthorizationRule)
  end
end

# Provide the same functionality under the old resource name.
# This is for backward compatibility.
class AzurermEventHubAuthorizationRule < AzureEventHubAuthorizationRule
  name "azurerm_event_hub_authorization_rule"
  desc "Verifies settings for Event Hub Authorization Rule"
  example <<-EXAMPLE
    describe azurerm_event_hub_authorization_rule(resource_group: 'example', namespace_name: 'namespace-ns', event_hub_endpoint: 'eventhub', authorization_rule_name: 'auth-rule'") do
      its(name) { should eq 'name'}
    end
  EXAMPLE

  def initialize(opts = {})
    Inspec::Log.warn Helpers.resource_deprecation_message(@__resource_name__, AzureEventHubAuthorizationRule.name)
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, "Parameters must be provided in an Hash object." unless opts.is_a?(Hash)

    # For backward compatibility.
    opts[:api_version] ||= "2017-04-01"
    super
  end
end
