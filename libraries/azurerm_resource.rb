# frozen_string_literal: true

require 'support/azure'

class AzurermResource < Inspec.resource(1)
  supports platform: 'azure'

  def management
    Azure::Management.instance.with_backend(inspec.backend)
  end

  def graph
    Azure::Graph.instance.with_backend(inspec.backend)
  end

  def vault(vault_name)
    Azure::Vault.new(vault_name, inspec.backend)
  end

  private

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
