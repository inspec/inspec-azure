# frozen_string_literal: true

require 'azurerm_resource'

class AzurermResourceGroups < AzurermResource
  name 'azurerm_resource_groups'
  desc 'Fetches all available resource groups'
  example <<-EXAMPLE
    describe azure_rmresource_groups do
      its('names') { should include('example-group') }
    end
  EXAMPLE

  FilterTable.create
             .add_accessor(:entries)
             .add_accessor(:where)
             .add(:exists?) { |obj| !obj.entries.empty? }
             .add(:names, field: 'name')
             .connect(self, :table)

  def to_s
    'Resource Groups'
  end

  def table
    @table ||= client.resource_groups
  end
end
