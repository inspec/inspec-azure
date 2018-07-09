# frozen_string_literal: true

require 'support/azure'

class AzurermResource < Inspec.resource(1)
  supports platform: 'azure'

  def exists?
    @exists ||= false
  end

  def client
    Azure::Management.instance
                     .with_client(azure_client)
                     .for_subscription(subscription_id)
  end

  private

  def azure_client
    Azure::Rest.new(credentials: credentials)
  end

  def credentials
    inspec.backend.azure_client.credentials
  end

  def subscription_id
    inspec.backend.azure_client.subscription_id
  end
end
