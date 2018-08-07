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
    name:                            'name',
    id:                              'id',
    log_collection:                  'logCollection',
    patch:                           'patch',
    baseline:                        'baseline',
    anti_malware:                    'antimalware',
    disk_encryption:                 'diskEncryption',
    network_security_groups:         'nsgs',
    web_application_firewall:        'waf',
    next_generation_firewall:        'ngfw',
    vulnerability_assessment:        'vulnerabilityAssessment',
    storage_encryption:              'storageEncryption',
    just_in_time_network_access:     'jitNetworkAccess',
    app_whitelisting:                'appWhitelisting',
    sql_auditing:                    'sqlAuditing',
    sql_transparent_data_encryption: 'sqlTde',
    contact_emails:                  'securityContactEmails',
    contact_phone:                   'securityContactPhone',
    notifications_enabled:           'areNotificationsOn',
    send_security_email_to_admin:    'sendToAdminOn',
  }.freeze

  attr_reader(*ATTRS.keys)

  def initialize(options = { name: 'default' })
    resp = client.security_center_policy(options[:name])
    return if has_error?(resp)

    @name = resp['name']
    @id   = resp['id']
    @log_collection = resp['properties']['logCollection']

    fields = resp['properties']['recommendations'].merge(
      resp['properties']['securityContactConfiguration'],
    )

    ATTRS.each do |name, api_name|
      next if instance_variable_defined?("@#{name}")
      # TODO: Should we handle cases where the fields aren't returned from the API?

      instance_variable_set("@#{name}", fields[api_name])
    end

    @exists = true
  end

  def to_s
    "'#{name}' Security Policy"
  end
end
