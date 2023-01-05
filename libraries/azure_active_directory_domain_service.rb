require "azure_graph_generic_resource"

class AzureActiveDirectoryDomainService < AzureGraphGenericResource
  name "azure_active_directory_domain_service"
  desc "Verifies settings for an Azure AD Domain Service"
  example <<-EXAMPLE
    describe azure_active_directory_domain_service(id: 'ACTIVE_DIRECTORY_DOMAIN_SERVICE_ID') do
      it { should exist }
    end
  EXAMPLE

  def initialize(opts = {})
    raise ArgumentError, "Parameters must be provided in an Hash object." unless opts.is_a?(Hash)

    opts[:resource] = "domains"
    opts[:resource_identifiers] = %i(id)
    super(opts, true)
  end

  def exists?
    !failed_resource?
  end

  def to_s
    super(AzureGraphUser)
  end
end
