# frozen_string_literal: true

require 'azurerm_resource'
require 'json'

class AzurermAdUsers < AzurermResource
  name 'azurerm_ad_users'
  desc 'Verifies settings for a collection of Azure Active Directory Users'
  example <<-EXAMPLE
    describe azure_ad_users do
        it  { should exist }
    end
  EXAMPLE

  filter = FilterTable.create
  filter.register_column(:azure_ids,      field: 'azureId')
  filter.register_column(:display_names,  field: 'displayName')
  filter.register_column(:mails,          field: 'mail')
  filter.register_column(:user_types,     field: 'userType')
  filter.install_filter_methods_on_resource(self, :table)

  def initialize
    @table = graph_client.users
  end

  def guest_accounts
    @guest_accounts ||= GuestUsers.new(@table)
  end

  def to_s
    'Azure Active Directory Users'
  end

  class GuestUsers
    def initialize(all_users)
      @guests = all_users.select { |user| user['userType'] == 'Guest' }
                         .map { |user|
                           {
                             displayName: user['displayName'],
                               mail:        user['mail'],
                               userType:    user['userType'],
                           }
                         }

      @exists = !@guests.empty?
    end

    def to_s
      JSON.pretty_generate @guests
    end

    def exists?
      @exists ||= false
    end
  end
end
