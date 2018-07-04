# frozen_string_literal: true

require 'azurerm_resource'

class AzureAdUsers < AzurermResource
  name 'azure_ad_user'
  desc 'Verifies settings for an Azure Active Directory User'
  example "
    describe azure_iam_user(tenant_id: 'example', objectId: 'user-id') do
    end
  "
  # todo what we can get
  # ATTRS = %i(
  #   objectId
  #   mail
  #   displayName
  #   givenName
  #   surname
  #   userType
  # ).freeze

  FilterTable.create
      .add_accessor(:entries)
      .add_accessor(:where)
      .add(:exists?) { |obj| !obj.entries.empty? }
      .add(:object_ids,   field: 'objectId')
      .add(:display_names, field: 'displayName')
      .add(:user_type, field: 'userType')
      .connect(self, :table)

  attr_reader(:table)

  def initialize
    resp = graph_client.iam_guest_users
    return if resp.nil? || resp.key?('error')

    @table = resp
  end

  def to_s
    "'#{name}' Azure AD User"
  end
end
