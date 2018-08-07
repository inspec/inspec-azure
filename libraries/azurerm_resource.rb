# frozen_string_literal: true

require 'support/azure'

class AzurermResource < Inspec.resource(1)
  supports platform: 'azure'

  MANAGEMENT_HOST = 'https://management.azure.com'
  GRAPH_HOST      = 'https://graph.windows.net'

  def client
    Azure::Management.instance
                     .with_client(rest_client)
                     .for_subscription(subscription_id)
  end

  def graph_client
    Azure::Graph.instance
                .with_client(rest_client(GRAPH_HOST))
                .for_tenant(tenant_id)
  end

  private

  def rest_client(host = MANAGEMENT_HOST)
    Azure::Rest.new(host, credentials: credentials.to_h)
  end

  def subscription_id
    credentials.subscription_id
  end

  def tenant_id
    credentials.tenant_id
  end

  def credentials
    @credentials ||= begin
      args = {}
      args[:subscription_id] = inspec.backend.options[:subscription_id] if respond_to?(:inspec)

      Azure::Credentials.new(args)
    end
  end

  def has_error?(response)
    response.nil? || response.key?(:error)
  end
end

class AzurermPluralResource < AzurermResource; end

class AzurermSingularResource < AzurermResource
  def exists?
    @exists ||= false
  end
end
