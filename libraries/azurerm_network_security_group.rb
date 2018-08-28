# frozen_string_literal: true

require 'azurerm_resource'

class AzurermNetworkSecurityGroup < AzurermSingularResource
  name 'azurerm_network_security_group'
  desc 'Verifies settings for Network Security Groups'
  example <<-EXAMPLE
    describe azurerm_network_security_group(resource_group: 'example', name: 'name') do
      its(name) { should eq 'name'}
    end
  EXAMPLE

  ATTRS = %i(
    name
    id
    etag
    type
    location
    tags
    properties
  ).freeze

  attr_reader(*ATTRS)

  def initialize(resource_group: nil, name: nil)
    resp = management.network_security_group(resource_group, name)
    return if has_error?(resp)

    assign_fields(ATTRS, resp)

    @exists = true
  end

  def to_s
    "'#{name}' Network Security Group"
  end

  def security_rules
    @security_rules ||= @properties['securityRules']
  end

  def default_security_rules
    @default_security_rules ||= @properties['defaultSecurityRules']
  end

  SSH_CRITERIA = %i(ssh_port access_allow direction_inbound tcp source_open).freeze
  def allow_ssh_from_internet?
    @allow_ssh_from_internet ||= matches_criteria?(SSH_CRITERIA, security_rules_properties)
  end
  RSpec::Matchers.alias_matcher :allow_ssh_from_internet, :be_allow_ssh_from_internet

  RDP_CRITERIA = %i(rdp_port access_allow direction_inbound tcp source_open).freeze
  def allow_rdp_from_internet?
    @allow_rdp_from_internet ||= matches_criteria?(RDP_CRITERIA, security_rules_properties)
  end
  RSpec::Matchers.alias_matcher :allow_rdp_from_internet, :be_allow_rdp_from_internet

  private

  def security_rules_properties
    security_rules.collect { |rule| rule['properties'] }
  end

  def matches_criteria?(criteria, properties)
    properties.any? { |property| criteria.all? { |method| send(:"#{method}?", property) } }
  end

  def ssh_port?(properties)
    matches_port?(destination_port_ranges(properties), '22')
  end

  def rdp_port?(properties)
    matches_port?(destination_port_ranges(properties), '3389')
  end

  def destination_port_ranges(properties)
    return Array(properties['destinationPortRange']) if properties['destinationPortRanges'].empty?
    return properties['destinationPortRanges'] if properties['destinationPortRange'].empty?
    properties['destinationPortRanges'].push(properties['destinationPortRange'])
  end

  def matches_port?(ports, match_port)
    return true if ports.detect { |p| p =~ /^(#{match_port}|\*)$/ }
    ports.select { |port| port.include?('-') }
         .collect { |range| range.split('-') }
         .any? { |range| (range.first..range.last).cover?(match_port) }
  end

  def tcp?(properties)
    properties['protocol'].casecmp?('TCP')
  end

  def access_allow?(properties)
    properties['access'] == 'Allow'
  end

  def source_open?(properties)
    properties['sourceAddressPrefix'] =~ %r{\*|0\.0\.0\.0|<nw>\/0|\/0|internet|any}
  end

  def direction_inbound?(properties)
    properties['direction'] == 'Inbound'
  end
end
