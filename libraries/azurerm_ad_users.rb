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
  filter.install_filter_methods_on_resource(self, :data)

  def initialize
    @table = graph_client.users

    @exists = !@table.empty?
  end

  def data
    @table
  end

  def guest_accounts
    GuestUsers.new(@table)
  end

  def to_s
    'Azure Active Directory Users'
  end

  class GuestUsers
    def initialize(all_users)
      @guests = []

      all_users.each do |user|
        @guests << { displayName: user['displayName'], mail: user['mail'], userType: user['userType'] } if user['userType'] == 'Guest'
      end

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
