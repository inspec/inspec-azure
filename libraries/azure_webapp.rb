require "azure_generic_resource"

class AzureWebapp < AzureGenericResource
  name "azure_webapp"
  desc "Verifies settings for Azure Webapp"
  example <<-EXAMPLE
    describe azure_webapp(resource_group: 'RESOURCE_GROUP_NAME', name: 'WEBAPP_NAME') do
      it { should exist }
    end
  EXAMPLE

  def initialize(opts = {})
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, "Parameters must be provided in an Hash object." unless opts.is_a?(Hash)

    opts[:resource_provider] = specific_resource_constraint("Microsoft.Web/sites", opts)
    opts[:allowed_parameters] = %i(auth_settings_api_version configuration_api_version supported_stacks_api_version)
    opts[:auth_settings_api_version] ||= "latest"
    opts[:configuration_api_version] ||= "latest"
    opts[:supported_stacks_api_version] ||= "latest"

    # static_resource parameter must be true for setting the resource_provider in the backend.
    super(opts, true)
  end

  def to_s
    super(AzureWebapp)
  end

  def webapp_name
    return unless exists?
    name
  end

  def auth_settings
    return unless exists?
    additional_resource_properties(
      {
        property_name: "auth_settings",
        property_endpoint: "#{id}/config/authsettings/list",
        api_version: @opts[:auth_settings_api_version],
        method: "post",
      },
    )
  end

  def configuration
    return unless exists?
    additional_resource_properties(
      {
        property_name: "configuration",
        property_endpoint: "#{id}/config/web",
        api_version: @opts[:configuration_api_version],
      },
    )
  end

  def has_identity?
    return unless exists?
    identity.count > 1
  end

  def supported_stacks
    return unless exists?
    additional_resource_properties(
      {
        property_name: "supported_stacks",
        property_endpoint: "providers/Microsoft.Web/availableStacks",
        add_subscription_id: true,
        api_version: @opts[:supported_stacks_api_version],
      },
    )
  end

  # Determines if the Webapp is using the given stack, and if the version
  # of that stack is the latest runtime supported by Azure.
  def using_latest?(stack)
    using = stack_version(stack)
    raise ArgumentError, "#{self} does not use Stack #{stack}" unless using
    latest = latest(stack)
    using[0] = "" if using[0].casecmp?("v")
    using.to_i >= latest.to_i
  end

  # private

  # Returns the version of the given stack being used by the Webapp.
  # nil if stack not used. raises if stack invalid.
  def stack_version(stack)
    stack = "netFramework" if stack.eql?("aspnet")
    stack_key = "#{stack}Version"
    raise ArgumentError, "#{stack} is not a supported stack." unless stack_supported(stack)
    linux_fx_version = configuration.properties.public_send("linuxFxVersion")
    if !linux_fx_version.empty?
      existing_stack = linux_fx_version.split("|")[0]
      existing_stack = existing_stack.downcase
      new_stack = stack.downcase
      version = linux_fx_version.split("|")[1] if get_language(existing_stack).eql?(get_language(new_stack))
    else
      version = configuration.properties.public_send(stack_key.to_s)
    end
    version.nil? || version.empty? ? nil : parse_version(version)
  end

  def latest(stack)
    return unless exists?
    supported_stacks unless respond_to?(:supported_stacks)
    latest_supported = supported_stacks.select { |s| s.name.eql?(stack) }
      .map { |e| e.properties.majorVersions.max_by(&:runtimeVersion).runtimeVersion }
      .reduce(:+)
    return if latest_supported.empty?
    latest_supported[0] = "" if latest_supported[0].casecmp?("v")
    latest_supported
  end

  private

  def parse_version(version)
    is_java_version = !(version =~ /java/ || version =~/jre/).nil?
    return version unless is_java_version
    version.split("-")[1].gsub(/java|jre|/, "")
  end

  def get_language(stack)
    lang_hash = { python: "python", php: "php", tomcat: "tomcat", java: "tomcat" }
    lang_hash[:"#{stack}"]
  end

  def stack_supported(stack)
    return false unless configuration.properties.respond_to?("#{stack}Version") || configuration.properties.public_send("#{stack}Version").nil?
    # Below commented code for custom stack identification for furture requirements.
    # linux_fx_version = configuration.properties.public_send('linuxFxVersion')
    # if !linux_fx_version.nil? && !linux_fx_version.empty?
    #   stack = get_language(stack.downcase)
    #   existing_stack = linux_fx_version.split('|')[0]
    #   return get_language(existing_stack.downcase).casecmp(stack) == 0
    # end
    true
  end
end

# Provide the same functionality under the old resource name.
# This is for backward compatibility.
class AzurermWebapp < AzureWebapp
  name "azurerm_webapp"
  desc "Verifies the settings for Azure Webapps"
  example <<-EXAMPLE
    describe azurerm_webapp(resource_group: 'example', name: 'webapp-name') do
    it { should exist }
    end
  EXAMPLE

  def initialize(opts = {})
    Inspec::Log.warn Helpers.resource_deprecation_message(@__resource_name__, AzureWebapp.name)
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, "Parameters must be provided in an Hash object." unless opts.is_a?(Hash)

    # For backward compatibility.
    opts[:api_version] ||= "2016-08-01"
    opts[:auth_settings_api_version] ||= "2016-08-01"
    opts[:configuration_api_version] ||= "2016-08-01"
    opts[:supported_stacks_api_version] ||= "2018-02-01"
    super
  end
end
