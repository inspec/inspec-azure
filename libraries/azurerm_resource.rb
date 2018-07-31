# frozen_string_literal: true

require 'support/azure'

class AzurermResource < Inspec.resource(1)
  supports platform: 'azure'

  MANAGEMENT_API_CLIENT = ::Azure::Resources::Profiles::Latest::Mgmt::Client
  GRAPH_API_CLIENT      = ::Azure::GraphRbac::Profiles::Latest::Client

  def client
    Azure::Management.instance
                     .with_client(rest_client)
                     .for_subscription(subscription_id)
  end

  def graph_client
    Azure::Graph.instance
                .with_client(rest_client(GRAPH_API_CLIENT))
                .for_tenant(tenant_id)
  end

  private

  def rest_client(client = MANAGEMENT_API_CLIENT)
      Azure::Rest.new(inspec.backend.azure_client(client))
  end

  def tenant_id
    inspec.backend.azure_client.tenant_id
  end

  def subscription_id
    inspec.backend.azure_client.subscription_id
  end
end

class AzurermPluralResource < AzurermResource; end

class AzurermSingularResource < AzurermResource
  def exists?
    @exists ||= false
  end
end
