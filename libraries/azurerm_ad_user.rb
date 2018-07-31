# frozen_string_literal: true

require 'azurerm_resource'

class AzurermAdUser < AzurermSingularResource
  name 'azurerm_ad_user'
  desc 'Verifies settings for an Azure Active Directory User'
  example <<-EXAMPLE
    describe azurerm_ad_user(user_id: 'userId') do
      it { should exist }
    end
  EXAMPLE

  ATTRS = %i(
    objectId
    accountEnabled
    city
    country
    department
    displayName
    facsimileTelephoneNumber
    givenName
    jobTitle
    mail
    mailNickname
    mobile
    passwordPolicies
    passwordProfile
    postalCode
    state
    streetAddress
    surname
    telephoneNumber
    usageLocation
    userPrincipalName
    userType
  ).freeze

  attr_reader(*ATTRS)

  def initialize(user_id: nil)
    user = graph.user(user_id)
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
    "Azure Active Directory Username: '#{displayName}' with objectId '#{objectId}'"
  end
end
