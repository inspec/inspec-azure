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
  def add_key(struct, key, value)
    Struct.new(*struct.members << key) do
      def key?(key)
        members.include?(key)
      end

      alias_method :keys, :members
    end.new(*struct.values << value)
  end
end

class AzurermSingularResource < AzurermResource
  def exists?
    @exists ||= false
  end
end
