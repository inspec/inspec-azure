# frozen_string_literal: true

require 'support/azure'
require 'active_support/core_ext/string/inflections'

class AzurermResource < Inspec.resource(1)
  name 'azurerm_resource'
  desc 'Base class for azurerm resources.'
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

  def queue(queue_name)
    Azure::Queue.new(queue_name, inspec.backend)
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

  # Converts the given Azure ID to a hash representation such that:
  # "/subscriptions/xxx/resourceGroups/my-rg/providers/Microsoft.Compute/disks/my-disk"
  # becomes {:subscription => 'xxx', :resource_group => 'my-rg', :provider => 'Microsoft.Compute', :disk => 'my-disk'}
  def id_to_h(azure_id)
    raise ArgumentError, "`#{azure_id}` is not a valid Azure ID." unless !azure_id.nil? && azure_id.start_with?('/subscriptions')

    begin
      split = azure_id.split('/').reject!(&:empty?)
      raise unless !split.empty? && split.length.even?
      hash = {}

      i = 0
      counter = 0
      while counter < split.length/2
        # Remove plural from API noun.
        k = split[i].end_with?('s') ? split[i][0..-2] : split[i]
        k = k.underscore.to_sym
        v = split[i+1]
        hash[k] = v
        i += 2
        counter += 1
      end
      hash
    rescue StandardError => e
      raise ArgumentError, "Unable to convert Azure ID `#{azure_id}` to hash: \n #{e.message}"
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
