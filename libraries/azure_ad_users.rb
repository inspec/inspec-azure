# frozen_string_literal: true

require 'azurerm_resource'

class AzureAdUsers < AzurermResource
  name 'azure_ad_users'
  desc 'Verifies settings for a collection of Azure Active Directory Users'
  example "
    describe azure_ad_users do
        it                  { should exist }
    end
  "

  FilterTable.create
      .add_accessor(:entries)
      .add_accessor(:where)
      .add(:exists?)        { |obj| !obj.entries.empty? }
      .add(:object_ids,     field: 'objectId')
      .add(:display_names,  field: 'displayName')
      .add(:mails,          field: 'mail')
      .add(:user_types,     field: 'userType')
      .connect(self, :table)

  attr_reader(:table)

  def initialize

    user_rows = []
    next_page = nil

    @users = graph_client.get_users
    return if @users.nil? || @users.empty?

    loop do # Users may be paginated
      if next_page != nil # Skip in first iteration
        @users = graph_client.get_users_next(next_page)
      end

      @users["values"].map do |user|
        user_rows += [{
                          objectId:     user["objectId"],
                          displayName:  user["displayName"],
                          mail:         user["mail"],
                          userType:     user["userType"]
                      }]
      end
      next_page = @users["nextLink"]
      break unless next_page
    end
    @table = user_rows
  end

  def to_s
    "Azure AD Users"
  end
end
