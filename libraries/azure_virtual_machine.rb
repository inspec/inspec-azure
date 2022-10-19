require 'azure_generic_resource'

class AzureVirtualMachine < AzureGenericResource
  name 'azure_virtual_machine'
  desc 'Verifies settings for an Azure Virtual Machine.'
  example <<-EXAMPLE
    describe azure_virtual_machine(resource_group: 'RESOURCE_GROUP_NAME', name: 'VIRTUAL_MACHINE_NAME') do
      it { should have_monitoring_agent_installed }
    end
  EXAMPLE

  def initialize(opts = {})
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    # Azure REST API endpoint URL format for the resource:
    #   GET https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/
    #   Microsoft.Compute/virtualMachines/{vmName}?api-version=2019-12-01
    #
    # The dynamic part that has to be created in this resource:
    #   Microsoft.Compute/virtualMachines/{vmName}?api-version=2019-12-01
    #
    # Parameters acquired from environment variables:
    #   - {subscriptionId} => Required parameter. It will be acquired by the backend from environment variables.
    #
    # User supplied parameters:
    #   - resource_group => Required parameter unless `resource_id` is provided. {resourceGroupName}
    #   - name => Required parameter unless `resource_id` is provided. Virtual machine name. {vmName}
    #   - resource_id => Optional parameter. If exists, `resource_group` and `name` must not be provided.
    #     In the following format:
    #       /subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/
    #       Microsoft.Compute/virtualMachines/{vmName}
    #   - api_version => Optional parameter. The latest version will be used unless provided. api-version
    #
    #   **`resource_group` and (resource) `name` or `resource_id`  will be validated in the backend appropriately.
    #     We don't have to do anything here.
    #
    # Following resource parameters have to be defined here.
    #   - resource_provider => Microsoft.Network/virtualNetworks
    #     The `specific_resource_constraint` method will validate the user input
    #       not to accept a different `resource_provider`.
    #
    opts[:resource_provider] = specific_resource_constraint('Microsoft.Compute/virtualMachines', opts)

    # static_resource parameter must be true for setting the resource_provider in the backend.
    super(opts, true)
  end

  def to_s
    super(AzureVirtualMachine)
  end

  # Resource specific methods can be created.
  # `return unless exists?` is necessary to prevent any unforeseen Ruby error.
  # Following methods are created to provide the same functionality with the current resource pack >>>>
  # @see https://github.com/inspec/inspec-azure

  def admin_username
    properties.osProfile.adminUsername if exists?
  end

  # Following methods are created to provide the same functionality with the current resource pack >>>>
  # @see https://github.com/inspec/inspec-azure
  def os_disk_name
    properties.storageProfile.osDisk.name if exists?
  end

  def data_disk_names
    properties.storageProfile.dataDisks.map(&:name) if exists?
  end

  def installed_extensions_types
    return unless exists?
    return [] if resources.nil?
    @installed_extensions_types ||= resources.map { |resource| resource.properties.type }
  end

  def has_only_approved_extensions?(approved_extensions)
    (installed_extensions_types - approved_extensions).empty?
  end

  def has_endpoint_protection_installed?(endpoint_protection_extensions)
    installed_extensions_types.any? { |extension| endpoint_protection_extensions.include?(extension) }
  end

  def installed_extensions_names
    return unless exists?
    return [] if resources.nil?
    @installed_extensions_names ||= resources.map { |resource| resource&.name }
  end

  def has_monitoring_agent_installed?
    return unless exists?
    return false if resources.nil?
    resources&.select do |res|
      res&.properties&.type == 'MicrosoftMonitoringAgent' && res&.properties&.provisioning_state == 'Succeeded'
    end
    resources.size == 1
  end
end

# Provide the same functionality under the old resource name.
# This is for backward compatibility.
class AzurermVirtualMachine < AzureVirtualMachine
  name 'azurerm_virtual_machine'
  desc 'Verifies settings for an Azure Virtual Machine'
  example <<-EXAMPLE
    describe azurerm_virtual_machine(resource_group: 'example', name: 'vm-name') do
      it { should have_monitoring_agent_installed }
    end
  EXAMPLE

  def initialize(opts = {})
    Inspec::Log.warn Helpers.resource_deprecation_message(@__resource_name__, AzureVirtualMachine.name)
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    # For backward compatibility.
    opts[:api_version] ||= '2017-12-01'
    super
  end
end
