require 'azure_generic_resource'
require 'backend/azure_security_rules_helpers'
require 'rspec/expectations'

class AzureNetworkSecurityGroup < AzureGenericResource
  name 'azure_network_security_group'
  desc 'Verifies settings for Network Security Groups'
  example <<-EXAMPLE
    describe azure_network_security_group(resource_group: 'example', name: 'name') do
      its(name) { should eq 'name'}
    end
  EXAMPLE

  def initialize(opts = {})
    # Options should be Hash type. Otherwise Ruby error will be raised.
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    # Azure REST API endpoint URL format for the resource:
    #   GET https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/
    #   Microsoft.Network/networkSecurityGroups/{networkSecurityGroupName}?api-version=2020-05-01
    #
    # The dynamic part that has to be created in this resource:
    #   Microsoft.Network/networkSecurityGroups/{networkSecurityGroupName}?api-version=2020-05-01
    #
    # Parameters acquired from environment variables:
    #   - {subscriptionId} => Required parameter. It will be acquired by the backend from environment variables.
    #
    # For parameters applicable to all resources, see project's README.
    #
    # User supplied parameters:
    #   - resource_group => Required parameter unless `resource_id` is provided. {resourceGroupName}
    #   - name => Required parameter unless `resource_id` is provided. Name of the resource to be tested.
    #   - resource_id => Optional parameter. If exists, other resource related parameters must not be provided.
    #     In the following format:
    #       /subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/
    #       Microsoft.Network/networkSecurityGroups/{networkSecurityGroupName}
    #   - api_version => Optional parameter. The latest version will be used unless provided.
    #
    #   **`resource_group`, (resource) `name` and `resource_id`  will be validated in the backend appropriately.
    #     We don't have to do anything here.
    #
    # Following resource parameters have to be defined here.
    #   - resource_provider => Microsoft.Network/virtualNetworks
    #     The `specific_resource_constraint` method will validate the user input
    #       not to accept a different `resource_provider`.
    #
    opts[:resource_provider] = specific_resource_constraint('Microsoft.Network/networkSecurityGroups', opts)

    # static_resource parameter must be true for setting the resource_provider in the backend.
    super(opts, true)
  end

  def to_s
    super(AzureNetworkSecurityGroup)
  end

  # Resource specific methods can be created.
  # `return unless exists?` is necessary to prevent any unforeseen Ruby error.

  def inbound_rules
    @inbound_rules ||= normalized_security_rules.one_direction_rules('inbound')
  end

  def outbound_rules
    @outbound_rules ||= normalized_security_rules.one_direction_rules('outbound')
  end

  def allow_rules
    @allow_rules ||= normalized_security_rules.access_type_rules('allow')
  end

  def deny_rules
    @deny_rules ||= normalized_security_rules.access_type_rules('deny')
  end

  # @example
  #   it { should allow(source_ip_range: '10.0.0.0/24', direction: 'inbound') }
  #   it { should allow(destination_ip_range: '10.0.0.1', direction: 'outbound' destination_port: '22') }
  #   it { should_not allow(source_service_tag: 'Internet', direction: 'inbound' destination_port: ['22', '100-150']) }
  #   it { should allow(destination_service_tag: 'VirtualNetwork', direction: 'outbound', protocol: 'TCP') }
  #   it { should allow(source_ip_range: '0:0:0:0:0:ffff:a05:0', direction: 'inbound') }
  def allow?(criteria = {})
    Validators.validate_params_required(@__resource_name__, %i(direction), criteria)
    criteria[:access] = 'allow'
    rules = criteria[:direction] == 'inbound' ? inbound_rules : outbound_rules
    normalized_security_rules.go_compare(rules, criteria)
  end
  RSpec::Matchers.alias_matcher :allow, :be_allow
  alias allowed? allow?

  # @example
  #   it { should allow_in(service_tag: 'VirtualNetwork') }
  #   it { should_not allow_in(service_tag: 'Internet') }
  #   it { should_not allow_in(ip_range: '10.0.0.0/24', port: '22') }
  #   it { should allow_in(ip_range: '10.0.0.5', port: %w{22 8080 56-78}, protocol: 'TCP' ) }
  def allow_in?(criteria)
    criteria[:source_ip_range] = criteria[:ip_range] if criteria.key?(:ip_range)
    criteria[:source_service_tag] = criteria[:service_tag] if criteria.key?(:service_tag)
    criteria[:destination_port] = criteria[:port] if criteria.key?(:port)
    %i(ip_range port service_tag).each { |k| criteria.delete(k) }
    criteria[:direction] = 'inbound'
    allow?(criteria)
  end
  RSpec::Matchers.alias_matcher :allow_in, :be_allow_in
  alias allowed_in? allow_in?

  # @example
  #   See AzureNetworkSecurityGroup#allow_in?
  def allow_out?(criteria)
    criteria[:destination_ip_range] = criteria[:ip_range] if criteria.key?(:ip_range)
    criteria[:destination_service_tag] = criteria[:service_tag] if criteria.key?(:service_tag)
    criteria[:destination_port] = criteria[:port] if criteria.key?(port)
    %i(ip_range port service_tag).each { |k| criteria.delete(k) }
    criteria[:direction] = 'outbound'
    allow?(criteria)
  end
  RSpec::Matchers.alias_matcher :allow_out, :be_allow_out
  alias allowed_out? allow_out?

  def normalized_security_rules
    @normalized_security_rules ||= ConsolidateSecurityRules.new(default_security_rules + security_rules)
  end

  # Following methods are created to provide the same functionality with the current resource pack >>>>
  # @see https://github.com/inspec/inspec-azure
  # Code for backward compatibility starts here >>>>>>

  def security_rules
    return unless exists?
    @security_rules ||= properties.securityRules
  end

  def default_security_rules
    return unless exists?
    @default_security_rules ||= properties.defaultSecurityRules
  end

  def allow_ssh_from_internet?
    return unless exists?
    allow_port_from_internet?('22')
  end
  RSpec::Matchers.alias_matcher :allow_ssh_from_internet, :be_allow_ssh_from_internet

  def allow_rdp_from_internet?
    return unless exists?
    allow_port_from_internet?('3389')
  end
  RSpec::Matchers.alias_matcher :allow_rdp_from_internet, :be_allow_rdp_from_internet

  SPECIFIC_CRITERIA = %i(specific_port access_allow direction_inbound source_open not_icmp).freeze
  def allow_port_from_internet?(specific_port)
    return unless exists?
    @specific_port = specific_port
    matches_criteria?(SPECIFIC_CRITERIA, security_rules_properties)
  end
  RSpec::Matchers.alias_matcher :allow_port_from_internet, :be_allow_port_from_internet

  private

  def security_rules_properties
    security_rules.collect(&:properties) + default_security_rules.collect(&:properties)
  end

  def matches_criteria?(criteria, properties)
    properties.any? { |property| criteria.all? { |method| send(:"#{method}?", property) } }
  end

  def specific_port?(properties)
    matches_port?(destination_port_ranges(properties), @specific_port)
  end

  def destination_port_ranges(properties)
    properties_hash = properties.to_h
    return Array(properties.destinationPortRange) unless properties_hash.include?(:destinationPortRanges)

    return properties.destinationPortRanges unless properties_hash.include?(:destinationPortRange)

    properties.destinationPortRanges + Array(properties.destinationPortRange)
  end

  def matches_port?(ports, match_port)
    return true if ports.detect { |p| p =~ /^(#{match_port}|\*)$/ }

    ports.select { |port| port.include?('-') }
         .collect { |range| range.split('-') }
         .any? { |range| (range.first.to_i..range.last.to_i).cover?(match_port.to_i) }
  end

  def tcp?(properties)
    properties.protocol.match?(/TCP|\*/)
  end

  def access_allow?(properties)
    properties.access == 'Allow'
  end

  def source_open?(properties)
    properties_hash = properties.to_h
    if properties_hash.include?(:sourceAddressPrefix)
      return properties.sourceAddressPrefix =~ %r{\*|0\.0\.0\.0|<nw>/0|/0|Internet|any}
    end
    if properties_hash.include?(:sourceAddressPrefixes)
      properties.sourceAddressPrefixes.include?('0.0.0.0')
    end
  end

  def direction_inbound?(properties)
    properties.direction == 'Inbound'
  end

  def not_icmp?(properties)
    !properties.protocol.match?(/ICMP/)
  end

  # Code for backward compatibility ends here <<<<<<<<
end

# Provide the same functionality under the old resource name.
# This is for backward compatibility.
class AzurermNetworkSecurityGroup < AzureNetworkSecurityGroup
  name 'azurerm_network_security_group'
  desc 'Verifies settings for Network Security Groups'
  example <<-EXAMPLE
    describe azurerm_network_security_group(resource_group: 'example', name: 'name') do
      its(name) { should eq 'name'}
    end
  EXAMPLE

  def initialize(opts = {})
    Inspec::Log.warn Helpers.resource_deprecation_message(@__resource_name__, AzureNetworkSecurityGroup.name)
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    # For backward compatibility.
    opts[:api_version] ||= '2018-02-01'
    super
  end
end
