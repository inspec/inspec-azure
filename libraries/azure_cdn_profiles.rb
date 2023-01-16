require "azure_generic_resources"

class AzureCDNProfiles < AzureGenericResources
  name "azure_cdn_profiles"
  desc "Verifies settings for a collection of Azure CDN Profiles."
  example <<-EXAMPLE
    describe azure_cdn_profiles do
        it { should exist }
    end
  EXAMPLE

  def initialize(opts = {})
    raise ArgumentError, "Parameters must be provided in an Hash object." unless opts.is_a?(Hash)

    opts[:resource_provider] = specific_resource_constraint("Microsoft.Cdn/profiles", opts)
    super(opts, true)
    return if failed_resource?

    populate_filter_table_from_response
  end

  def to_s
    super(AzureCDNProfiles)
  end

  private

  def populate_table
    @table = @resources.map do |resource|
      resource.merge(resource[:properties]).merge(resource[:sku]).merge(resource[:systemdata])
    end
  end
end
