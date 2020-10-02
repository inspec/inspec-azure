require 'azure_generic_resources'

class AzureSubscriptions < AzureGenericResources
  name 'azure_subscriptions'
  desc 'Verifies settings for the Azure Subscription within a tenant'
  example <<-EXAMPLE
    describe azure_subscriptions do
      its('display_names') { should include 'Demo Resources' }
    end
  EXAMPLE

  attr_reader :table

  def initialize(opts = {})
    opts[:resource_provider] = specific_resource_constraint('/subscriptions/', opts)
    # See azure_policy_definitions resource for how to use `resource_uri` and `add_subscription_id` parameters.
    opts[:resource_uri] = '/subscriptions/'
    opts[:add_subscription_id] = false

    # static_resource parameter must be true for setting the resource_provider in the backend.
    super(opts, true)

    # Check if the resource is failed.
    # It is recommended to check that after every usage of inherited methods or making API calls.
    return if failed_resource?

    # Define the column and field names for FilterTable.
    # In most cases, the `column` should be the pluralized form of the `field`.
    table_schema = [
      { column: :names, field: :name },
      { column: :ids, field: :id },
      { column: :tags, field: :tags },
      { column: :tenant_ids, field: :tenant_id },
    ]

    # FilterTable is populated at the very end due to being an expensive operation.
    AzureGenericResources.populate_filter_table(:table, table_schema)
  end

  def to_s
    super(AzureSubscriptions)
  end

  private

  def populate_table
    return [] if @resources.empty?
    @resources.each do |resource|
      @table << {
        id: resource[:subscriptionId],
        name: resource[:displayName],
        tags: resource[:tags],
        tenant_id: resource[:tenantId],
      }
    end
  end
end
