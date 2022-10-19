require 'azure_generic_resources'

class AzureActiveDirectoryObjects < AzureGraphGenericResources
  name 'azure_active_directory_objects'
  desc 'Retrieves and verifies all policy exemptions that apply to a subscription.'
  example <<-EXAMPLE
    describe azure_active_directory_objects do
      it { should exist }
    end
  EXAMPLE

  def initialize(opts = {})
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    opts[:resource] = 'me/getMemberObjects'
    opts[:method] = 'post'

    # At this point there is enough data to make the query.
    # super must be called with `static_resource => true` switch.
    super(opts, true)

    # FilterTable is populated at the very end due to being an expensive operation.
    AzureGraphUsers.populate_filter_table(:table, @table_schema)
  end

  def to_s
    super(AzureActiveDirectoryObjects)
  end
end
