# frozen_string_literal: true

require 'azurerm_resource'

class AzurermAdUser < AzurermResource
  name 'azurerm_ad_user'
  desc 'Verifies settings for an Azure Active Directory User'
  example <<-EXAMPLE
    describe azure_ad_user(object_id: 'object_id') do
      it  { should exist }
    end
  EXAMPLE

  ATTRS = %i(
    objectId
    mail
    displayName
    userType
  ).freeze

  attr_reader(*ATTRS)

  def initialize(id)
    user = graph_client.user(id)
    return if user.nil?

    ATTRS.each do |field|
      instance_variable_set("@#{field}", user[field.to_s])
    end

    @exists = true
  end

  def guest?
    @userType == 'Guest'
  end

  def to_s
    "Azure Active Directory Username: '#{displayName}' with email '#{mail}'"
  end
end
