require 'azure_generic_resource'

class AzureSubscription < AzureGenericResource
  name 'azure_subscription'
  desc 'Verifies settings for the current Azure Subscription'
  example <<-EXAMPLE
    describe azure_subscription do
      its('name') { should eq 'subscription-name' }
      its('locations')    { should include 'eastus' }
    end
  EXAMPLE

  attr_reader :locations

  def initialize(opts = {})
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)
    raise ArgumentError, 'The `name` parameter is not allowed, use `id`, instead, in the format:'\
      '`1e0b427a-aaaa-bbbb-1111-ee558463ebbf`' if opts.key?(:name)

    opts[:resource_provider] = specific_resource_constraint('subscriptions', opts)
    # This is an edge case resource where `id` becomes `name` from the backend perspective.
    # Environment variable will be used unless `id` is provided.
    opts[:name] = opts[:id] || ENV['AZURE_SUBSCRIPTION_ID']
    opts[:resource_uri] = '/subscriptions/'
    opts[:add_subscription_id] = false
    opts[:allowed_parameters] = %i(locations_api_version id)

    # static_resource parameter must be true for setting the resource_provider in the backend.
    super(opts, true)

    return if failed_resource?
    @locations = collect_locations
    # This is for backward compatibility.
    define_singleton_method(:id) { subscriptionId }
  end

  def to_s
    super(AzureSubscription)
  end

  def name
    return unless exists?
    displayName
  end

  private

  def collect_locations
    return unless exists?
    api_version = @opts[:locations_api_version] || 'latest'
    api_response = get_resource({ resource_uri: id + '/locations', api_version: api_version })
    api_response[:value].map { |location| location[:name] }
  end
end

# Provide the same functionality under the old resource name.
# This is for backward compatibility.
class AzurermSubscription < AzureSubscription
  name 'azurerm_subscription'
  desc 'Verifies settings for the current Azure Subscription'
  example <<-EXAMPLE
    describe azurerm_subscription do
      its('name') { should eq 'subscription-name' }
      its('locations')    { should include 'eastus' }
    end
  EXAMPLE

  def initialize(opts = {})
    opts[:locations_api_version] ||= '2019-10-01'
    Inspec::Log.warn Helpers.resource_deprecation_message(@__resource_name__, AzureSubscription.name)
    super
  end
end
