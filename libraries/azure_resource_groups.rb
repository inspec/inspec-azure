# frozen_string_literal: true

require 'azurerm_resource'

class AzureResourceGroups < AzurermResource
  name 'azure_resource_groups'
  desc 'Fetches all available resource groups'
  example "
    describe azure_resource_groups do
      its('names') { should include('example-group') }
    end
  "

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
