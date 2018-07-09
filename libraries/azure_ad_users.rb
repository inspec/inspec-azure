# frozen_string_literal: true

require 'azurerm_resource'

class AzureAdUsers < AzurermResource
  name 'azure_ad_users'
  desc 'Verifies settings for a collection of Azure Active Directory Users'
  example "
    describe azure_ad_users do
        it  { should exist }
    end
  "

  @users = FilterTable.create
                          .register_column(:object_ids,     field: 'objectId')
                          .register_column(:display_names,  field: 'displayName')
                          .register_column(:mails,          field: 'mail')
                          .register_column(:user_types,     field: 'userType')
                          .install_filter_methods_on_resource(self, :data)

  def initialize
    @users = graph_client.users
  end

  def data
    @users
  end

  def to_s
    "Azure Active Directory Users"
  end
end
