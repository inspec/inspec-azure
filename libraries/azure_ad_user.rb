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

  def initialize(object_id)
    resp = graph_client.get_user(object_id)
    return if resp.nil? || resp.key?('error')

    ATTRS.each do |field|
      instance_variable_set("@#{field}", resp[field.to_s])
    end

    @exists = true
  end

  def is_guest
    :userType == 'Guest'
  end

  def to_s
    "'#{name}' Azure AD User"
  end
end
