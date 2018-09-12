# frozen_string_literal: true

require 'azurerm_resource'

class AzurermSecurityCenterPolicy < AzurermSingularResource
  name 'azurerm_security_center_policy'
  desc 'Verifies settings for Security Center'
  example <<-EXAMPLE
    describe azurerm_security_center_policy(name: 'default') do
      its('log_collection') { should eq('On') }
    end
  EXAMPLE

  ATTRS = {
    name:                            :name,
    id:                              :id,
    properties:                      :properties,
    log_collection:                  :logCollection,
    pricing_tier:                    :selectedPricingTier,
    patch:                           :patch,
    baseline:                        :baseline,
    anti_malware:                    :antimalware,
    disk_encryption:                 :diskEncryption,
    network_security_groups:         :nsgs,
    web_application_firewall:        :waf,
    next_generation_firewall:        :ngfw,
    vulnerability_assessment:        :vulnerabilityAssessment,
    storage_encryption:              :storageEncryption,
    just_in_time_network_access:     :jitNetworkAccess,
    app_whitelisting:                :appWhitelisting,
    sql_auditing:                    :sqlAuditing,
    sql_transparent_data_encryption: :sqlTde,
  }.freeze

  SECURITY_CONTACT_ATTRS = {
    contact_emails:               :securityContactEmails,
    contact_phone:                :securityContactPhone,
    notifications_enabled:        :areNotificationsOn,
    send_security_email_to_admin: :sendToAdminOn,
  }.freeze

  attr_reader(*ATTRS.keys, *SECURITY_CONTACT_ATTRS.keys)

  def initialize(options = { name: 'default' })
    resp = management.security_center_policy(options[:name])
    return if has_error?(resp)

    @name = resp.name
    @id   = resp.id
    @log_collection = resp.properties.logCollection
    @pricing_tier   = resp.properties.pricingConfiguration.selectedPricingTier

    assign_fields_with_map(ATTRS, resp.properties.recommendations)
    assign_fields_with_map(SECURITY_CONTACT_ATTRS, resp.properties.securityContactConfiguration)

    @exists = true
  end

  def to_s
    "'#{name}' Security Policy"
  end
end
