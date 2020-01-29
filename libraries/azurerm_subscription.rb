# frozen_string_literal: true

require 'azurerm_resource'

class AzurermSubscription < AzurermSingularResource
  name 'azurerm_subscription'
  desc 'Verifies settings for the current Azure Subscription'
  example <<-EXAMPLE
    describe azurerm_subscription do
      its('name') { should eq 'subscription-name' }
      its('locations')    { should include 'eastus' }
    end
  EXAMPLE

  ATTRS = %i(
    id
    name
  ).freeze

  attr_reader(*ATTRS)

  def initialize
    resp = management.subscription
    return if has_error?(resp)

    @id   = resp.subscriptionId
    @name = resp.displayName
    @exists = true
  end

  def locations
    @locations ||= management.subscription_locations.map(&:name)
  end

  def to_s
    "'#{name}' subscription"
  end
end
