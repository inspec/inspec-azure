# frozen_string_literal: true

require 'azure_backend'

class AzureGenericResource < AzureResourceBase
  name 'azure_generic_resource'

  supports platform: "azure"

  desc '
    Inspec Resource to interrogate any Resource type in Azure
  '

  attr_accessor :filter, :total, :counts, :name, :type, :location, :probes

  def initialize(opts = {})
    # Call the parent class constructor
    super(opts)

    # Get the resource group
    resource_group

    # Get the resources
    resources

    # Create the tag methods
    create_tag_methods
  end

  # Define the filter table so that it can be interrogated
  @filter = FilterTable.create
  @filter.add_accessor(:count)
         .add_accessor(:entries)
         .add_accessor(:where)
         .add_accessor(:contains)
         .add(:exist?, field: 'exist?')
         .add(:type, field: 'type')
         .add(:name, field: 'name')
         .add(:location, field: 'location')
         .add(:properties, field: 'properties')

  @filter.connect(self, :probes)

  def parse_resource(resource)
    # return a hash of information
    parsed = {
      'location' => resource.location,
      'name' => resource.name,
      'type' => resource.type,
      'exist?' => true,
      'properties' => AzureResourceProbe.new(resource.properties),
    }

    parsed
  end
end
