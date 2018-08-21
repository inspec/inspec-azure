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
    return if has_error?(user)

    assign_fields(ATTRS, user)

    @exists = true
  end

  def guest?
    @userType == 'Guest'
  end

  def to_s
    "Azure Active Directory Username: '#{displayName}' with objectId '#{objectId}'"
  end
end
