# frozen_string_literal: true

require 'azurerm_resource'

class AzureAdUser < AzurermResource
  name 'azure_ad_user'
  desc 'Verifies settings for an Azure Active Directory User'
  example "
    describe azure_ad_user(object_id: 'object_id') do
    end
  "

  ATTRS = %i(
    objectId
    mail
    displayName
    userType
  ).freeze

  attr_reader(*ATTRS)

  # Can be constructed either via API call with an Azure ID provided,
  # or from parameters passed. API call takes precedence when ID provided.
  def initialize(azure_id, user_args)

    if azure_id != nil
      user = graph_client.get_user(azure_id)
      return if user.nil? || user.key?('error')
    else
      user = user_args
    end

    ATTRS.each do |field|
      instance_variable_set("@#{field}", user[field])
    end

    @exists = true
  end

  def guest?
    @userType == 'Guest'
  end

  def to_s
    "Azure AD Username: '#{displayName}' with email '#{mail}'"
  end
end
