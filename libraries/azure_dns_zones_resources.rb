require 'azure_generic_resources'

class AzureDNSZonesResources < AzureGenericResources
  name 'azure_dns_zones_resources'
  desc 'Verifies settings for Azure DNS ZONES'
  example <<-EXAMPLE
    describe azure_dns_zones_resources  do
      it{ should exist }
    end
  EXAMPLE

  attr_reader :table

  def initialize(opts = {})
    # require "byebug"
    # byebug
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    # Azure REST API endpoint URL format listing the all resources for a given subscription:
    #   GET https://management.azure.com/subscriptions/{subscriptionId}/
    # providers/Microsoft.Network/dnszones?api-version=2018-05-01
    #
    # or in a resource group only
    #   GET https://management.azure.com/subscriptions/{subscriptionId}/
    #     # providers/Microsoft.Network/dnszones?api-version=2018-05-01
    #
    # The dynamic part that has to be created for this resource:
    #   Microsoft.Network/dnszones?api-version=2019-12-01
    #
    # Parameters acquired from environment variables:
    #   - {subscriptionId} => Required parameter. It will be acquired by the backend from environment variables.
    #
    # For parameters applicable to all resources, see project's README.
    #
    # User supplied parameters:
    #   - resource_group => Optional parameter.
    #   - api_version => Optional parameter. The latest version will be used unless provided.
    #
    # Following resource parameters have to be defined/created here.
    #   resource_provider => Microsoft.Network/dnszones

    opts[:resource_provider] = specific_resource_constraint('Microsoft.Network/dnszones', opts)
    # static_resource parameter must be true for setting the resource_provider in the backend.
    super(opts, false)

    # Check if the resource is failed.
    # It is recommended to check that after every usage of superclass methods or API calls.
    return if failed_resource?

    # Define the column and field names for FilterTable.
    #   - column: It is defined as an instance method, callable on the resource, and present `field` values in a list.
    #   - field: It has to be identical with the `key` names in @table items that will be presented in the FilterTable.
    # @see https://github.com/inspec/inspec/blob/master/docs/dev/filtertable-usage.md
    table_schema = [
      { column: :names, field: :name },
      { column: :types, field: :type },
      { column: :ids, field: :id },
      { column: :locations, field: :location },
      { column: :tags, field: :tags },
      { column: :max_number_of_recordsets, field: :max_number_of_recordsets },
      { column: :number_of_record_sets, field: :number_of_record_sets },
      { column: :name_servers, field: :name_servers },
      { column: :properties, field: :properties },
    ]

    # FilterTable is populated at the very end due to being an expensive operation.
    AzureGenericResources.populate_filter_table(:table, table_schema)
  end

  def to_s
    super(AzureDNSZonesResources)
  end

  private

  # Populate the @table with the resource attributes.
  # @table has been declared in the super class as an empty array.
  # Each item in the @table
  #   - should be a Hash object
  #   - should have the exact key names defined in the @table_schema as `field`.
  def populate_table
    # If @resources empty than @table should stay as an empty array as declared in superclass.
    # This will ensure constructing resource and passing `should_not exist` test.
    return [] if @resources.empty?
    @resources.each do |resource|
      @table << {
        id: resource[:id],
        name: resource[:name],
        location: resource[:location],
        type: resource[:type],
        tags: resource[:tags],
        max_number_of_recordsets: resource[:properties][:maxNumberOfRecordSets],
        number_of_record_sets: resource[:properties][:numberOfRecordSets],
        name_servers: resource[:properties][:nameServers],
        properties: resource[:properties],
      }
    end
  end
end
