require 'azure_generic_resource'

class AzureSubscription < AzureGenericResource
  name 'azure_subscription'
  desc 'Verifies settings for the current Azure Subscription.'
  example <<-EXAMPLE
    describe azure_subscription do
      its('name') { should eq 'SUBSCRIPTION_NAME' }
      its('locations') { should include 'eastus' }
    end
  EXAMPLE

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
    opts[:locations_api_version] ||= 'latest'

    # static_resource parameter must be true for setting the resource_provider in the backend.
    super(opts, true)

    return if failed_resource?
    # Fetch locations before updating the `id`
    fetch_locations
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

  def locations
    return unless exists?
    return unless respond_to?(:locations_list)
    # This is for backward compatibility
    # Return locations where physicalLocation is defined
    if locations_list.first.respond_to?(:metadata)
      locations_list.reject { |location| location.metadata&.physicalLocation.nil? }.map(&:name)
    else
      locations_list.map(&:name)
    end
  end

  def all_locations
    return unless exists?
    return unless respond_to?(:locations_list)
    locations_list.map(&:name)
  end

  def physical_locations
    return unless exists?
    return unless respond_to?(:locations_list)
    return unless locations_list.first.respond_to?(:metadata)
    locations_list.select { |location| location.metadata&.regionType == 'Physical' }.map(&:name)
  end

  def logical_locations
    return unless exists?
    return unless respond_to?(:locations_list)
    return unless locations_list.first.respond_to?(:metadata)
    locations_list.select { |location| location.metadata&.regionType == 'Logical' }.map(&:name)
  end

  def diagnostic_settings
    return unless exists?
    additional_resource_properties(
      {
        property_name: 'default',
        property_endpoint: "subscriptions/#{id}/providers/microsoft.insights/diagnosticSettings",
        api_version: '2017-05-01-preview',
      },
    )
  end

  def diagnostic_settings_names
    return nil if diagnostic_settings.first.nil?
    result = []
    diagnostic_settings.each do |setting|
      result.push setting.name
    end
    result
  end

  def diagnostic_settings_locations
    return nil if diagnostic_settings.first.nil?
    result = []
    diagnostic_settings.each do |setting|
      result.push setting.location
    end
    result
  end

  def diagnostic_settings_event_hubs
    return nil if diagnostic_settings.first.nil?
    result = []
    diagnostic_settings.each do |setting|
      result.push setting.properties&.eventHubName
    end
    result
  end

  def diagnostic_settings_enabled_logging_types
    return nil if diagnostic_settings.first.nil?
    result = []
    diagnostic_settings.each do |setting|
      result += setting.properties&.logs&.select(&:enabled)&.map(&:category)
    end
    result
  end

  def diagnostic_settings_disabled_logging_types
    return nil if diagnostic_settings.first.nil?
    result = []
    diagnostic_settings.each do |setting|
      result += setting.properties&.logs&.reject(&:enabled)&.map(&:category)
    end
    result
  end

  private

  def fetch_locations
    return unless exists?
    additional_resource_properties(
      {
        property_name: 'locations_list',
        property_endpoint: "#{id}/locations",
        api_version: @opts[:locations_api_version],
      },
    )
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
    Inspec::Log.warn Helpers.resource_deprecation_message(@__resource_name__, AzureSubscription.name)
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    # For backward compatibility.
    opts[:api_version] ||= '2019-10-01'
    opts[:locations_api_version] ||= '2019-10-01'
    super
  end
end
