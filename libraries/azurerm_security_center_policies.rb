# frozen_string_literal: true

require 'azurerm_resource'

class AzurermSecurityCenterPolicies < AzurermPluralResource
  name 'azurerm_security_center_policies'
  desc 'Verifies settings for Security Center'
  example <<-EXAMPLE
    describe azurerm_security_center_policies do
      its('policy_names') { should include('default') }
    end
  EXAMPLE

  FilterTable.create
             .register_column(:policy_names, field: :name)
             .install_filter_methods_on_resource(self, :table)

  attr_reader :table

  def initialize
    resp = management.security_center_policies
    return if has_error?(resp)

    @table = resp
  end

  include Azure::Deprecations::StringsInWhereClause

  def to_s
    'Security Policies'
  end
end
