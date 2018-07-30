# frozen_string_literal: true

require 'support/azure'

class AzurermResource < Inspec.resource(1)
  supports platform: 'azure'

  def management
    Azure::Management.instance
                     .with_client(management_client)
                     .for_subscription(subscription_id)
  end

  def graph
    Azure::Graph.instance
                .with_client(graph_client)
                .for_tenant(tenant_id)
  end

  private

  def management_client
    Azure::Rest.new(inspec.backend.azure_client)
  end

  def graph_client
    Azure::Rest.new(inspec.backend.graph_client)
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
