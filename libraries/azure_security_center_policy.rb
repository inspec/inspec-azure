require 'azure_generic_resource'

class AzureSecurityCenterPolicy < AzureGenericResource
  name 'azure_security_center_policy'
  desc 'Verifies settings for Security Center.'
  example <<-EXAMPLE
    describe azure_security_center_policy(name: 'default') do
      its('log_collection') { should eq('On') }
    end
  EXAMPLE

  attr_reader :log_collection, :pricing_tier, :anti_malware, :disk_encryption, :network_security_groups, :baseline,
              :web_application_firewall, :next_generation_firewall, :vulnerability_assessment, :storage_encryption,
              :just_in_time_network_access, :app_whitelisting, :sql_auditing, :sql_transparent_data_encryption, :patch,
              :contact_emails, :contact_phone, :notifications_enabled, :send_security_email_to_admin

  def initialize(opts = { name: 'default' }) # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity TODO: Fix these issues.
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    opts[:resource_provider] = specific_resource_constraint('Microsoft.Security/policies', opts)

    # Default policy does not reside in a resource group.
    if opts[:name] == 'default' and opts[:resource_group].nil?
      opts[:resource_uri] = 'providers/Microsoft.Security/policies/'
      opts[:add_subscription_id] = true
    end

    opts[:allowed_parameters] = %i(default_policy_api_version auto_provisioning_settings_api_version)
    opts[:default_policy_api_version] ||= 'latest'
    opts[:auto_provisioning_settings_api_version] ||= 'latest'

    # static_resource parameter must be true for setting the resource_provider in the backend.
    super(opts, true)

    return if failed_resource?
    @log_collection = properties&.logCollection
    @pricing_tier = properties&.pricingConfiguration&.selectedPricingTier
    @patch = properties&.recommendations&.patch
    @baseline = properties&.recommendations&.baseline
    @anti_malware = properties&.recommendations&.antimalware
    @disk_encryption = properties&.recommendations&.diskEncryption
    @network_security_groups = properties&.recommendations&.nsgs
    @web_application_firewall = properties&.recommendations&.waf
    @next_generation_firewall = properties&.recommendations&.ngfw
    @vulnerability_assessment = properties&.recommendations&.vulnerabilityAssessment
    @storage_encryption = properties&.recommendations&.storageEncryption
    @just_in_time_network_access = properties&.recommendations&.jitNetworkAccess
    @app_whitelisting = properties&.recommendations&.appWhitelisting
    @sql_auditing = properties&.recommendations&.sqlAuditing
    @sql_transparent_data_encryption = properties&.recommendations&.sqlTde
    @contact_emails = properties&.securityContactConfiguration&.securityContactEmails
    @contact_phone = properties&.securityContactConfiguration&.securityContactPhone
    @notifications_enabled = properties&.securityContactConfiguration&.areNotificationsOn
    @send_security_email_to_admin = properties&.securityContactConfiguration&.sendToAdminOn
  end

  def to_s
    super(AzureSecurityCenterPolicy)
  end

  # @see AzureKeyVault#diagnostic_settings for how to use #additional_resource_properties method.
  #
  def default_policy
    return unless exists?
    # This property is relevant to default security policy only.
    return unless @opts[:name] == 'default'
    # This will add the subscription id.
    endpoint = validate_resource_uri(
      {
        add_subscription_id: true,
        resource_uri: 'providers/Microsoft.Authorization/policyAssignments/SecurityCenterBuiltIn',
      },
    )
    additional_resource_properties(
      {
        property_name: 'default_policy',
        property_endpoint: endpoint,
        api_version: @opts[:default_policy_api_version],
      },
    )
  end

  def has_auto_provisioning_enabled?
    return unless exists?
    # This property is relevant to default security policy only.
    return unless @opts[:name] == 'default'
    auto_provisioning_settings unless respond_to?(:auto_provisioning_settings)
    auto_provisioning_settings&.select { |setting| setting.name == 'default' }&.first&.properties&.autoProvision == 'On'
  end

  def auto_provisioning_settings
    return unless exists?
    # This property is relevant to default security policy only.
    return unless @opts[:name] == 'default'
    # This will add the subscription id.
    endpoint = validate_resource_uri(
      {
        add_subscription_id: true,
        resource_uri: 'providers/Microsoft.Security/autoProvisioningSettings',
      },
    )
    additional_resource_properties(
      {
        property_name: 'auto_provisioning_settings',
        property_endpoint: endpoint,
        api_version: @opts[:auto_provisioning_settings_api_version],
      },
    )
  end
end

# Provide the same functionality under the old resource name.
# This is for backward compatibility.
class AzurermSecurityCenterPolicy < AzureSecurityCenterPolicy
  name 'azurerm_security_center_policy'
  desc 'Verifies settings for Security Center'
  example <<-EXAMPLE
    describe azurerm_security_center_policy(name: 'default') do
      its('log_collection') { should eq('On') }
    end
  EXAMPLE

  def initialize(opts = { name: 'default' })
    Inspec::Log.warn Helpers.resource_deprecation_message(@__resource_name__, AzureSecurityCenterPolicy.name)
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    # For backward compatibility.
    opts[:api_version] ||= '2015-06-01-Preview'
    opts[:default_policy_api_version] ||= '2018-05-01'
    opts[:auto_provisioning_settings_api_version] ||= '2017-08-01-preview'
    super
  end
end
