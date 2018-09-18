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
    if inspec.backend.msi_auth?
      raise Inspec::Exceptions::ResourceSkipped, 'MSI Authentication is currently unsupported for Active Directory Users.'
    end
    Azure::Graph.instance
                .with_client(graph_client)
                .for_tenant(tenant_id)
  end

  def vault(vault_name)
    Azure::Vault.instance
                .with_client(vault_client(vault_name))
  end

  private

  def management_client
    Azure::Rest.new(inspec.backend.azure_client)
  end

  def graph_client
    Azure::Rest.new(inspec.backend.azure_client(::Azure::GraphRbac::Profiles::Latest::Client))
  end

  def vault_client(vault_name)
    Azure::Rest.new(inspec.backend.azure_client(::Azure::KeyVault::Profiles::Latest, vault_name))
  end

  def tenant_id
    inspec.backend.azure_client.tenant_id
  end

  def subscription_id
    inspec.backend.azure_client.subscription_id
  end

  def has_error?(struct)
    struct.nil? || (struct.is_a?(Struct) && struct.key?(:error))
  end

  def assign_fields(keys, struct)
    keys.each do |field|
      next if instance_variable_defined?("@#{field}")

      instance_variable_set("@#{field}", struct.key?(field) ? struct[field] : nil)
    end
  end

  def assign_fields_with_map(map, struct)
    map.each do |name, api_name|
      next if instance_variable_defined?("@#{name}")

      instance_variable_set("@#{name}", struct.key?(api_name) ? struct[api_name] : nil)
    end
  end
end

class AzurermPluralResource < AzurermResource
end

class AzurermSingularResource < AzurermResource
  def exists?
    @exists ||= false
  end
end
