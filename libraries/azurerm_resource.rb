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
    Azure::Rest.new(credentials: credentials.to_h)
  end

  def subscription_id
    credentials.subscription_id
  end

  def credentials
    @credentials ||= begin
      args = {}
      args[:subscription_id] = inspec.backend.options[:subscription_id] if respond_to?(:inspec)

      Azure::Credentials.new(args)
    end
  end
end
