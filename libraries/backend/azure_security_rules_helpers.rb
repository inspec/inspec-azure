require 'backend/helpers'

# Normalise Azure security rules to make them comparable with criteria or other security rules.
#
class NormalizeSecurityRule
  CIDR_IPV4_REG = %r{^([0-9]{1,3}\.){3}[0-9]{1,3}(/([0-9]|[1-2][0-9]|3[0-2]))?$}i.freeze
  CIDR_IPV6_REG = %r{^s*((([0-9A-Fa-f]{1,4}:){7}([0-9A-Fa-f]{1,4}|:))|(([0-9A-Fa-f]{1,4}:){6}(:[0-9A-Fa-f]{1,4}|((25[0-5]|2[0-4]d|1dd|[1-9]?d)(.(25[0-5]|2[0-4]d|1dd|[1-9]?d)){3})|:))|(([0-9A-Fa-f]{1,4}:){5}(((:[0-9A-Fa-f]{1,4}){1,2})|:((25[0-5]|2[0-4]d|1dd|[1-9]?d)(.(25[0-5]|2[0-4]d|1dd|[1-9]?d)){3})|:))|(([0-9A-Fa-f]{1,4}:){4}(((:[0-9A-Fa-f]{1,4}){1,3})|((:[0-9A-Fa-f]{1,4})?:((25[0-5]|2[0-4]d|1dd|[1-9]?d)(.(25[0-5]|2[0-4]d|1dd|[1-9]?d)){3}))|:))|(([0-9A-Fa-f]{1,4}:){3}(((:[0-9A-Fa-f]{1,4}){1,4})|((:[0-9A-Fa-f]{1,4}){0,2}:((25[0-5]|2[0-4]d|1dd|[1-9]?d)(.(25[0-5]|2[0-4]d|1dd|[1-9]?d)){3}))|:))|(([0-9A-Fa-f]{1,4}:){2}(((:[0-9A-Fa-f]{1,4}){1,5})|((:[0-9A-Fa-f]{1,4}){0,3}:((25[0-5]|2[0-4]d|1dd|[1-9]?d)(.(25[0-5]|2[0-4]d|1dd|[1-9]?d)){3}))|:))|(([0-9A-Fa-f]{1,4}:){1}(((:[0-9A-Fa-f]{1,4}){1,6})|((:[0-9A-Fa-f]{1,4}){0,4}:((25[0-5]|2[0-4]d|1dd|[1-9]?d)(.(25[0-5]|2[0-4]d|1dd|[1-9]?d)){3}))|:))|(:(((:[0-9A-Fa-f]{1,4}){1,7})|((:[0-9A-Fa-f]{1,4}){0,5}:((25[0-5]|2[0-4]d|1dd|[1-9]?d)(.(25[0-5]|2[0-4]d|1dd|[1-9]?d)){3}))|:)))(%.+)?s*(\/([0-9]|[1-9][0-9]|1[0-1][0-9]|12[0-8]))?$}i.freeze
  PORT_RANGE = ('0'..'65535').freeze

  attr_reader :name, :etag, :id, :access, :direction, :protocol, :priority

  def initialize(rule)
    allowed_types = %w{Microsoft.Network/networkSecurityGroups/defaultSecurityRules \
                       Microsoft.Network/networkSecurityGroups/securityRules}
    unless allowed_types.include?(rule.type)
      raise ArgumentError, "Security rule should be either one of #{allowed_types}. Provided: `#{rule.type}`."
    end
    @properties = rule.properties
    @name = rule.name.downcase
    @id = rule.id
    @etag = rule.etag
    # allow or deny
    @access = rule.properties.access.downcase
    # inbound or outbound
    @direction = @properties.direction.downcase
    @description = @properties.description.downcase
    @protocol = @properties.protocol.upcase
    @priority = @properties.priority
  end

  def destination_address_prefixes
    if @properties.destinationAddressPrefixes.empty? || @properties.destinationAddressPrefixes.nil?
      Array(@properties.destinationAddressPrefix)
    else
      @properties.destinationAddressPrefixes
    end
  end

  def source_address_prefixes
    if @properties.sourceAddressPrefixes.empty? || @properties.sourceAddressPrefixes.nil?
      Array(@properties.sourceAddressPrefix)
    else
      @properties.sourceAddressPrefixes
    end
  end

  def destination_port_ranges_raw
    if @properties.destinationPortRanges.empty? || @properties.destinationPortRanges.nil?
      Array(@properties.destinationPortRange)
    else
      @properties.destinationPortRanges
    end
  end

  def source_port_ranges_raw
    if @properties.sourcePortRanges.empty? || @properties.sourcePortRanges.nil?
      Array(@properties.sourcePortRange)
    else
      @properties.sourcePortRanges
    end
  end

  def destination_addresses_as_ip
    if @destination_ip_addresses.nil?
      ip_and_tag = extract_ip_addresses(destination_address_prefixes)
      @destination_ip_addresses = ip_and_tag[:ip_addresses]
      @destination_service_tags ||= ip_and_tag[:service_tags]
    end
    @destination_ip_addresses
  end

  def source_addresses_as_ip
    if @source_ip_addresses.nil?
      ip_and_tag = extract_ip_addresses(source_address_prefixes)
      @source_ip_addresses = ip_and_tag[:ip_addresses]
      @source_service_tags ||= ip_and_tag[:service_tags]
    end
    @source_ip_addresses
  end

  def destination_addresses_as_service_tag
    if @destination_service_tags.nil?
      ip_and_tag = extract_ip_addresses(destination_address_prefixes)
      @destination_ip_addresses ||= ip_and_tag[:ip_addresses]
      @destination_service_tags = ip_and_tag[:service_tags]
    end
    @destination_service_tags
  end

  def source_addresses_as_service_tag
    if @source_service_tags.nil?
      ip_and_tag = extract_ip_addresses(source_address_prefixes)
      @source_ip_addresses ||= ip_and_tag[:ip_addresses]
      @source_service_tags = ip_and_tag[:service_tags]
    end
    @source_service_tags
  end

  def destination_ports
    extract_ports(destination_port_ranges_raw)
  end

  def source_ports
    extract_ports(source_port_ranges_raw)
  end

  # return one of the following: true, false, nil
  #   nil: The criteria is not within the scope (Ip range) of the rule.
  #     This can be used by the caller method to make a decision, such as moving to another rule.
  # @param criteria [Hash] Please see comments for the details.
  #   required: access (allow/deny), direction (inbound/outbound)
  #   require_any: destination/source_ip_range destination/source_service_tag
  #   allow: destination/source_port, protocol
  #
  # @note:
  #   service_tag test is explicit. If the provided service tag does not exist, it will fail.
  #     E.g: Even though the security rule allows requests from all IP addresses (0.0.0.0),
  #       testing `Internet` source_service_tag will fail.
  #   This is because this resource pack has no control over what IP ranges are included in the Azure service tags.
  #
  def compliant?(criteria)
    allowed = %i(source_port destination_port protocol)
    required = %i(access direction)
    require_any = %i(destination_ip_range source_ip_range destination_service_tag source_service_tag)
    Helpers.validate_parameters(allow: allowed, required: required, require_any_of: require_any, opts: criteria)

    # This will be updated by the relevant checks.
    compliant = false

    # From this point onwards:
    #   Every check will result either:
    #     true: Continue to the next check.
    #     false: Finish test, this criteria does not comply with the rule.
    #     nil: Finish test, this criteria is not in the scope of the rule.
    unless criteria[:source_ip_range].nil?
      within_range = ip_range_check(source_addresses_as_ip, criteria[:source_ip_range])
      return nil unless within_range
      compliant = access == criteria[:access]
      return compliant unless compliant
    end

    unless criteria[:destination_ip_range].nil?
      within_range = ip_range_check(destination_addresses_as_ip, criteria[:destination_ip_range])
      return nil unless within_range
      compliant = access == criteria[:access]
      return compliant unless compliant
    end

    unless criteria[:source_service_tag].nil?
      within_range = source_addresses_as_service_tag.include?(criteria[:source_service_tag])
      return nil unless within_range
      compliant = access == criteria[:access]
      return compliant unless compliant
    end

    unless criteria[:destination_service_tag].nil?
      within_range = destination_addresses_as_service_tag.include?(criteria[:destination_service_tag])
      return nil unless within_range
      compliant = access == criteria[:access]
      return compliant unless compliant
    end

    # `Any`, `all` will fail.
    # If this is the case, `protocol` parameter should not be provided at all.
    unless criteria[:protocol].nil?
      return nil unless criteria[:protocol].upcase == protocol
      compliant = access == criteria[:access]
      compliant = true if protocol == '*' && access == 'allow'
      compliant = false if protocol == '*' && access == 'deny'
      return compliant unless compliant
    end

    # Individual protocol number and/or a range can be provided.
    #   ['8080', '50-60']
    #   '22'
    unless criteria[:source_port].nil?
      ports = extract_ports(Array(criteria[:source_port]))
      return nil unless ports.all? { |p| source_ports.include?(p) }
      compliant = access == criteria[:access]
      return compliant unless compliant
    end

    unless criteria[:destination_port].nil?
      ports = extract_ports(Array(criteria[:destination_port]))
      return nil unless ports.all? { |p| destination_ports.include?(p) }
      compliant = access == criteria[:access]
    end

    compliant
  end

  private

  # @return [Boolean]
  # @param base_ip_ranges [Array] The list of IPAddr objects.
  # @param criteria_ip_range [String] The IP range or address in CIDR format.
  #
  # criteria ip range will be checked whether it is within one of the base ip ranges.
  #
  def ip_range_check(base_ip_ranges, criteria_ip_range)
    unless criteria_ip_range.match?(CIDR_IPV4_REG) || criteria_ip_range.match?(CIDR_IPV6_REG)
      raise ArgumentError, 'IP range/address must be in CIDR format, e.g: `192.168.0.1/24, 2001:1234::/64`.'
    end
    criteria_ip_range_cidr = IPAddr.new(criteria_ip_range)
    within_range = []
    base_ip_ranges.each do |b|
      within_range << b.include?(criteria_ip_range_cidr)
    end
    within_range.any? { |check| check == true }
  end

  # @return [Array] The list of ports as String type.
  #   The range of valid port numbers if '*' provided.
  # @param sources [Array, Class<Array>] The list of ports.
  #
  def extract_ports(sources)
    return PORT_RANGE if sources.any? { |s| s == '*' }
    sources.each_with_object([]) do |s, ports|
      if s.include?('-')
        from, to = s.split('-')
        ports << [*from..to]
      else
        ports << s
      end
    end.flatten.sort
  end

  # @return [Hash] {ip_addresses: A list of IPAddr objects, service_tags: A list of service tags}
  # @param sources [String] IP addresses in CIDR format or service tags, e.g: '10.0.0.0/24', 'VirtualNetwork'.
  #
  def extract_ip_addresses(sources)
    service_tags = []
    ip_addresses = sources.each_with_object([]) do |source, ip_adds|
      if source == '*'
        ip_adds << IPAddr.new('0.0.0.0/0')
      elsif source.match?(CIDR_IPV4_REG) || source.match?(CIDR_IPV6_REG)
        ip_adds << IPAddr.new(source)
      else
        service_tags << source
      end
    end
    { ip_addresses: ip_addresses, service_tags: service_tags }
  end
end

# Consolidated provided Azure security rules as normalised security rules.
# Provide helper methods to be used in Azure resources.
#
class ConsolidateSecurityRules
  attr_reader :normalized_security_rules

  # Normalise and sort Azure security rules by their priority.
  def initialize(rules)
    @normalized_security_rules = rules.map { |rule| NormalizeSecurityRule.new(rule) }.sort_by(&:priority)
  end

  # Filter rules by their directions.
  def one_direction_rules(direction)
    unless %w{inbound outbound}.include?(direction)
      raise ArgumentError, "Accepted parameters are `inbound` or `outbound`. Provided `#{direction}`."
    end
    @normalized_security_rules.select { |rule| rule.direction == direction }
  end

  # Filter rules by their access type.
  def access_type_rules(access)
    unless %w{allow deny}.include?(access)
      raise ArgumentError, "Accepted parameters are `allow` or `deny`. Provided `#{access}`."
    end
    @normalized_security_rules.select { |rule| rule.access == access }
  end

  # @return [Boolean] Indicated whether the criteria is compliant to the provided set of security rules or not.
  #   true: The criteria is compliant.
  #   false: The criteria is not compliant or it does not fall into the scope of provided security rules.
  #
  # @note: The security rules will be sorted by their priority.
  #   Tests will be started from the highest priority rule.
  # @param rules [Array] A list of NormalizeSecurityRule objects.
  # @param criteria [Hash] See NormalizeSecurityRule#compliant?
  def go_compare(rules, criteria)
    unless rules.first.is_a?(NormalizeSecurityRule)
      raise ArgumentError, "Security rules must be a `NormalizeSecurityRule` object, Provided #{rules.first.class}."
    end
    raise ArgumentError, "Criteria must be a `Hash` object. Provided #{criteria.class}" unless criteria.is_a?(Hash)
    # Ensure that the rules are sorted by their priority.
    rules = rules.sort_by(&:priority)
    result = false
    rules.each do |rule|
      result = rule.compliant?(criteria)
      break if [FalseClass, TrueClass].include?(result.class)
    end
    # If result is nil, that means the criteria does not fall in the scope of any security rules.
    # Fail safe: If the criteria is not regulated by a rule, then it is not allowed.
    return false if result.nil?
    result
  end
end
