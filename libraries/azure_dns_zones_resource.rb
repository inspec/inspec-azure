require 'azure_generic_resource'

class AzureDNSZonesResource < AzureGenericResource
  name 'azure_dns_zones_resource'
  desc 'Verifies settings for an Azure DNS Zones.'
  example <<-EXAMPLE
    describe azure_dns_zones_resource(resource_group: 'RESOURCE_GROUP_NAME', name: 'DNS_ZONE_NAME') do
      it { should exist }
    end
  EXAMPLE

  def initialize(opts = {})
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    # Azure REST API endpoint URL format for the resource:
    #   GET https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}
    # /providers/Microsoft.Network/dnsZones/{zoneName}?api-version=2018-05-01
    #
    # The dynamic part that has to be created in this resource:
    #   Microsoft.Network/dnsZones/{zoneName}?api-version=2018-05-01
    #
    # Parameters acquired from environment variables:
    #   - {subscriptionId} => Required parameter. It will be acquired by the backend from environment variables.
    #
    # User supplied parameters:
    #   - resource_group => Required parameter unless `resource_id` is provided. {resourceGroupName}
    #   - name => Required parameter unless `resource_id` is provided. DNS Zones name. {vmName}
    #   - resource_id => Optional parameter. If exists, `resource_group` and `name` must not be provided.
    #     In the following format:
    #       /subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/
    #       Microsoft.Network/dnsZones/{zoneName}
    #   - api_version => Optional parameter. The latest version will be used unless provided. api-version
    #
    #   **`resource_group` and (resource) `name` or `resource_id`  will be validated in the backend appropriately.
    #     We don't have to do anything here.
    #
    # Following resource parameters have to be defined here.
    #   - resource_provider => Microsoft.Network/dnsZones
    #     The `specific_resource_constraint` method will validate the user input
    #       not to accept a different `resource_provider`.
    #
    opts[:resource_provider] = specific_resource_constraint('Microsoft.Network/dnsZones', opts)
    opts[:required_parameters] = %i(name)

    # static_resource parameter must be true for setting the resource_provider in the backend.
    super(opts, true)
  end

  def to_s
    super(AzureDNSZonesResource)
  end

  def max_number_of_recordsets
    properties.maxNumberOfRecordSets if exists?
  end

  def number_of_record_sets
    properties.numberOfRecordSets if exists?
  end

  def name_servers
    properties.nameServers if exists?
  end
end
