require 'azure_generic_resource'

class AzureVirtualMachineDisk < AzureGenericResource
  name 'azure_virtual_machine_disk'
  desc 'Verifies settings for Azure Virtual Machine Disks'
  example <<-EXAMPLE
    describe azure_virtual_machine_disk(resource_group: 'example', name: 'disk-name') do
      it{ should exist }
    end
  EXAMPLE

  def initialize(opts = {})
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    opts[:resource_provider] = specific_resource_constraint('Microsoft.Compute/disks', opts)

    # static_resource parameter must be true for setting the resource_provider in the backend.
    super(opts, true)
  end

  def encryption_enabled
    return unless exists?
    # In previous api versions `encryptionSettings` is used instead.
    return properties&.encryptionSettings&.enabled if properties&.encryptionSettingsCollection&.enabled.nil?
    return false if properties&.encryptionSettingsCollection&.enabled.nil?
    properties&.encryptionSettingsCollection&.enabled
  end

  def rest_encryption_type
    return unless exists?
    properties&.encryption&.type
  end

  def attached?
    return unless exists?
    properties&.diskState&.eql?('Attached')
  end

  def to_s
    super(AzureVirtualMachineDisk)
  end
end
