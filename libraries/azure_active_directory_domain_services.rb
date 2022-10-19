require 'azure_graph_generic_resources'

class AzureActiveDirectoryDomainServices < AzureGraphGenericResources
  name 'azure_active_directory_domain_services'
  desc 'Verifies settings for all Azure Active Directory Domain Services.'
  example <<-EXAMPLE
    describe azure_active_directory_domain_services do
      it { should exist }
    end
  EXAMPLE

  def initialize(opts = {})
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    opts[:resource] = 'domains'
    opts[:select] = %w{id authenticationType availabilityStatus isAdminManaged isDefault isInitial isRoot isVerified supportedServices passwordNotificationWindowInDays passwordValidityPeriodInDays state}
    super(opts, true)

    self.class.populate_filter_table(:table, @table_schema)
  end
end
