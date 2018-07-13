# frozen_string_literal: true

require 'azurerm_resource'
require 'json'

class AzurermAdUsers < AzurermResource
  name 'azurerm_ad_users'
  desc 'Verifies settings for a collection of Azure Active Directory Users'
  example <<-EXAMPLE
    describe azurerm_ad_users do
        it  { should exist }
    end
  EXAMPLE

  FilterTable.create
             .register_column(:object_ids,     field: 'objectId')
             .register_column(:display_names,  field: 'displayName')
             .register_column(:mails,          field: 'mail')
             .register_column(:user_types,     field: 'userType')
             .install_filter_methods_on_resource(self, :table)

  def table
    @table ||= graph_client.users
  end

  def guest_accounts
    @guest_accounts ||= where('userType' => 'Guest').entries
  end

  def to_s
    'Azure Active Directory Users'
  end
end
