require "azure_graph_generic_resource"

class AzureActiveDirectoryObject < AzureGraphGenericResource
  name "azure_active_directory_object"
  desc "Verifies settings for an Azure Active Directory Object"
  example <<-EXAMPLE
    describe azure_active_directory_object(id: 'ACTIVE_DIRECTORY_OBJECT_ID') do
      it { should exist }
    end
  EXAMPLE

  def initialize(opts = {})
    raise ArgumentError, "Parameters must be provided in an Hash object." unless opts.is_a?(Hash)

    opts[:resource] = "directoryObjects"
    opts[:resource_identifiers] = %i(id)
    super(opts, true)
  end

  def exists?
    !failed_resource?
  end

  def to_s
    super(AzureActiveDirectoryObject)
  end
end
