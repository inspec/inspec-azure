# frozen_string_literal: true
require 'backend/azure_environment'

# TODO: This file should be updated at every release.
# Source:
#   https://github.com/Azure/azure-sdk-for-ruby/blob/master/runtime/ms_rest_azure/lib/ms_rest_azure/azure_environment.rb
# Base module name should be changed to => module MicrosoftRestAzure

# Azure REST API specific errors.
#
# If the API returns an invalid api_version error,
# the suggested api_version can be acquired from the error message and used at consecutive calls.
#
# E.g.:
#     rescue UnsuccessfulAPIQuery::UnexpectedHTTPResponse::InvalidApiVersionParameter => e
#       api_version_suggested = e.get_suggested_api
#
class UnsuccessfulAPIQuery < StandardError
  class ResourceNotFound < StandardError; end
  class UnexpectedHTTPResponse < StandardError
    class InvalidApiVersionParameter < StandardError
      # Return a list if the wrong api is not provided.
      def suggested_api_version(wrong_api_version = nil)
        # Capture all the api versions within the error message.
        # This will include the wrong one used in HTTP request.
        # It has to be removed.
        #
        # Example for key in a key vault: https://docs.microsoft.com/en-us/rest/api/keyvault/getkey/getkey
        #
        # "The specified version (7.4) is not recognized. Consider using the latest supported version (7.1)."
        semver_like_versions = message.scan(/[0-9]\.[0-9]/)
        unless semver_like_versions.empty?
          # The last one will be the supported version.
          return semver_like_versions.last
        end
        #
        # Example for specific resource type api (for detailed description)
        # "No registered resource provider found for location 'westeurope' and API version '2022-01-01' for type
        #   'virtualMachines'. The supported api-versions are '2015-05-01-preview, 2015-06-15, 2016-03-30,
        #   2016-04-30-preview, 2016-08-30, 2017-03-30, 2017-12-01, 2018-04-01, 2018-06-01, 2018-10-01, 2019-03-01,
        #   2019-07-01, 2019-12-01, 2020-06-01'. The supported locations are 'eastus, eastus2, westus, centralus,
        #   northcentralus, southcentralus, northeurope, westeurope, eastasia, southeastasia, japaneast, japanwest,
        #   australiaeast, australiasoutheast, australiacentral, brazilsouth, southindia, centralindia, westindia,
        #   canadacentral, canadaeast, westus2, westcentralus, uksouth, ukwest, koreacentral, koreasouth, francecentral,
        #   southafricanorth, uaenorth, switzerlandnorth, germanywestcentral, norwayeast'."
        #
        # Example for resource manager api (for short description)
        # "The api-version '2019-10-11' is invalid. The supported versions are '2020-01-01,2019-11-01,2019-10-01,
        #   2019-09-01,2019-08-01,2019-07-01,2019-06-01,2019-05-10,2019-05-01,2019-03-01,2018-11-01,2018-09-01,
        #   2018-08-01,2018-07-01,2018-06-01,2018-05-01,2018-02-01,2018-01-01,2017-12-01,2017-08-01,2017-06-01,
        #   2017-05-10,2017-05-01,2017-03-01,2016-09-01,2016-07-01,2016-06-01,2016-02-01,2015-11-01,2015-01-01,
        #   2014-04-01-preview,2014-04-01,2014-01-01,2013-03-01,2014-02-26,2014-04'."
        #
        # There are cases where the stable api_versions are too old and don't return JSON response.
        # If the latest stable is too old (based on the age_criteria), then return the preview versions as well.
        # This is a quick fix until TODO finding a more stable solution.
        stable_api_versions = message.scan(/\d{4}-\d{2}-\d{2}[,']/).map(&:chop).sort.reverse
        preview_api_versions = message.scan(/\d{4}-\d{2}-\d{2}-preview/).sort.reverse
        if wrong_api_version
          stable_api_versions.delete(wrong_api_version) if stable_api_versions.include?(wrong_api_version)
          preview_api_versions.delete(wrong_api_version) if preview_api_versions.include?(wrong_api_version)
        end
        age_criteria = 2
        n_a_l = Helpers.normalize_api_list(age_criteria, stable_api_versions, preview_api_versions)
        n_a_l.first
      end
    end
  end
end

class HTTPClientError < StandardError
  class MissingCredentials < StandardError; end
end

# Create necessary Azure environment variables and provide access to them
#
# @example:
#   my_env = AzureEnvironments.get_endpoint('azure_cloud')
#   my_env.resource_manager_endpoint_url => 'https://management.azure.com/'
#
# For graph api endpoint urls:
#   https://docs.microsoft.com/en-us/graph/deployments
# For graph api endpoint api versions:
#   https://docs.microsoft.com/en-us/azure/active-directory/develop/microsoft-graph-intro
class AzureEnvironments
  # Following data can be modified if necessary.
  # TODO: Update API versions if there is a newer version available.
  ENDPOINTS = {
    'azure_cloud' => {
      resource_manager_endpoint_url: MicrosoftRestAzure::AzureEnvironments::AzureCloud.resource_manager_endpoint_url,
      active_directory_endpoint_url: MicrosoftRestAzure::AzureEnvironments::AzureCloud.active_directory_endpoint_url,
      storage_endpoint_suffix: MicrosoftRestAzure::AzureEnvironments::AzureCloud.storage_endpoint_suffix,
      key_vault_dns_suffix: MicrosoftRestAzure::AzureEnvironments::AzureCloud.key_vault_dns_suffix,
      resource_manager_endpoint_api_version: '2020-01-01',
      graph_api_endpoint_url: 'https://graph.microsoft.com',
      graph_api_endpoint_api_version: 'v1.0',
    },
    # The latest version can be acquired from the error message if the current ones don't work.
    'azure_china_cloud' => {
      resource_manager_endpoint_url: MicrosoftRestAzure::AzureEnvironments::AzureChinaCloud.resource_manager_endpoint_url,
      active_directory_endpoint_url: MicrosoftRestAzure::AzureEnvironments::AzureChinaCloud.active_directory_endpoint_url,
      storage_endpoint_suffix: MicrosoftRestAzure::AzureEnvironments::AzureChinaCloud.storage_endpoint_suffix,
      key_vault_dns_suffix: MicrosoftRestAzure::AzureEnvironments::AzureChinaCloud.key_vault_dns_suffix,
      resource_manager_endpoint_api_version: '2020-01-01',
      graph_api_endpoint_url: 'https://microsoftgraph.chinacloudapi.cn',
      graph_api_endpoint_url_api_version: 'v1.0',
    },
    'azure_us_government_L4' => {
      resource_manager_endpoint_url: MicrosoftRestAzure::AzureEnvironments::AzureUSGovernment.resource_manager_endpoint_url,
      active_directory_endpoint_url: MicrosoftRestAzure::AzureEnvironments::AzureUSGovernment.active_directory_endpoint_url,
      storage_endpoint_suffix: MicrosoftRestAzure::AzureEnvironments::AzureUSGovernment.storage_endpoint_suffix,
      key_vault_dns_suffix: MicrosoftRestAzure::AzureEnvironments::AzureUSGovernment.key_vault_dns_suffix,
      resource_manager_endpoint_api_version: '2020-01-01',
      graph_api_endpoint_url: 'https://graph.microsoft.us',
      graph_api_endpoint_url_api_version: 'v1.0',
    },
    'azure_us_government_L5' => {
      resource_manager_endpoint_url: MicrosoftRestAzure::AzureEnvironments::AzureUSGovernment.resource_manager_endpoint_url,
      active_directory_endpoint_url: MicrosoftRestAzure::AzureEnvironments::AzureUSGovernment.active_directory_endpoint_url,
      storage_endpoint_suffix: MicrosoftRestAzure::AzureEnvironments::AzureUSGovernment.storage_endpoint_suffix,
      key_vault_dns_suffix: MicrosoftRestAzure::AzureEnvironments::AzureUSGovernment.key_vault_dns_suffix,
      resource_manager_endpoint_api_version: '2020-01-01',
      graph_api_endpoint_url: 'https://dod-graph.microsoft.us',
      graph_api_endpoint_url_api_version: 'v1.0',
    },
    'azure_german_cloud' => {
      resource_manager_endpoint_url: MicrosoftRestAzure::AzureEnvironments::AzureGermanCloud.resource_manager_endpoint_url,
      active_directory_endpoint_url: MicrosoftRestAzure::AzureEnvironments::AzureGermanCloud.active_directory_endpoint_url,
      storage_endpoint_suffix: MicrosoftRestAzure::AzureEnvironments::AzureGermanCloud.storage_endpoint_suffix,
      key_vault_dns_suffix: MicrosoftRestAzure::AzureEnvironments::AzureGermanCloud.key_vault_dns_suffix,
      resource_manager_endpoint_api_version: '2020-01-01',
      graph_api_endpoint_url: 'https://graph.microsoft.de',
      graph_api_endpoint_url_api_version: 'v1.0',
    },
  }.freeze

  # @return [String] the resource management endpoint
  # Used for getting short descriptions of resources including resource_id.
  attr_reader :resource_manager_endpoint_url

  # @return [String] the resource management endpoint latest api version
  attr_reader :resource_manager_endpoint_api_version

  # @return [String] the Active Directory login endpoint
  # Used for authentication.
  attr_reader :active_directory_endpoint_url

  # @return [String] the graph api endpoint url
  attr_reader :graph_api_endpoint_url

  # @return [String] the graph api endpoint api version, e.g. v1.0
  attr_reader :graph_api_endpoint_api_version

  # @return [String] the endpoint suffix for storage accounts
  attr_reader :storage_endpoint_suffix

  # @return [String] the endpoint dns suffix for key vaults
  attr_reader :key_vault_dns_suffix

  def initialize(options)
    required_properties = %i(resource_manager_endpoint_url resource_manager_endpoint_api_version)

    required_supplied_properties = required_properties & options.keys

    if required_supplied_properties.nil? || required_supplied_properties.empty? \
      || (required_supplied_properties & required_properties) != required_properties
      raise ArgumentError, "#{required_properties} are the required properties but provided properties are #{options}"
    end

    required_supplied_properties.each do |prop|
      if options[prop].nil? || !options[prop].is_a?(String) || options[prop].empty?
        raise ArgumentError, "Value of the '#{prop}' property must be of type String and non empty."
      end
    end

    options.each do |k, v|
      instance_variable_set("@#{k}", v) unless v.nil?
    end
  end

  # Provide access to the endpoint properties.
  def self.get_endpoint(endpoint)
    options = ENDPOINTS[endpoint]
    new(options)
  end
end

# Make Hash return {} when accessing undefined keys.
class HashRecursive < Hash
  def self.recursive
    new { |hash, key| hash[key] = recursive }
  end
end

module Helpers
  # @see https://github.com/inspec/inspec-aws/blob/master/libraries/aws_backend.rb#L209
  #
  # @param opts [Hash] The parameters to be validated.
  # @param resource_name [String] The name of the method/resource that the parameters are validated in.
  # @param allow [Array] The list of optional parameters.
  # @param required [Array] The list of required parameters.
  # @param require_any_of [Array] The list of parameters that at least one of them are required.
  def self.validate_parameters(resource_name: nil, allow: [], required: nil, require_any_of: nil, opts: {}, skip_length: false) # rubocop:disable Metrics/ParameterLists
    raise ArgumentError, "Parameters must be provided with as a Hash object. Provided #{opts.class}" unless opts.is_a?(Hash)
    if required
      allow += Helpers.validate_params_required(resource_name, required, opts)
    end
    if require_any_of
      allow += Helpers.validate_params_require_any_of(resource_name, require_any_of, opts)
    end
    Helpers.validate_params_allow(allow, opts, skip_length)
    true
  end

  # @return [String] Provided parameter within require only one of parameters.
  # @param require_only_one_of [Array]
  def self.validate_params_only_one_of(resource_name = nil, require_only_one_of, opts)
    # At least one of them has to exist.
    Helpers.validate_params_require_any_of(resource_name, require_only_one_of, opts)
    provided = require_only_one_of.select { |i| opts.key?(i) }
    if provided.size > 1
      raise ArgumentError, "Either one of #{require_only_one_of} is required. Provided: #{provided}."
    end
    # There should be only one parameter at this point.
    provided.first
  end

  # @return [Array] Required parameters
  # @param required [Array]
  def self.validate_params_required(resource_name = nil, required, opts)
    raise ArgumentError, "#{resource_name}: `#{required.uniq - opts.keys.uniq}` must be provided" unless opts.is_a?(Hash) && required.all? { |req| opts.key?(req) && !opts[req].nil? && opts[req] != '' }
    required
  end

  # @return [Array] Require any of parameters
  # @param require_any_of [Array]
  def self.validate_params_require_any_of(resource_name = nil, require_any_of, opts)
    raise ArgumentError, "#{resource_name}: One of `#{require_any_of}` must be provided." unless opts.is_a?(Hash) && require_any_of.any? { |req| opts.key?(req) && !opts[req].nil? && opts[req] != '' }
    require_any_of
  end

  # @return [Array] Allowed parameters
  # @param allow [Array]
  def self.validate_params_allow(allow, opts, skip_length = false)
    unless skip_length
      raise ArgumentError, 'Arguments or values can not be longer than 500 characters.' if opts.any? { |k, v| k.size > 100 || v.to_s.size > 500 }
    end
    raise ArgumentError, 'Scalar arguments not supported.' unless defined?(opts.keys)
    raise ArgumentError, "Unexpected arguments found: #{opts.keys.uniq - allow.uniq}" unless opts.keys.all? { |a| allow.include?(a) }
    raise ArgumentError, 'Provided parameter should not be empty.' unless opts.values.all? do |a|
      return true if a.class == Integer
      return true if [TrueClass, FalseClass].include?(a.class)
      !a.empty?
    end
  end

  # Convert provided data into Odata query format.
  # @see
  #   https://www.odata.org/getting-started/basic-tutorial/
  #
  # This is a very simple approach, and tested with a very limited data.
  # The result of the new operators should be tested thoroughly before using this method.
  #
  # Supported key words:
  #   - substring_of => substring_of_name: 'Mc'
  #   - starts_with => starts_with_name: 'J'
  #
  # @param data [Array, Hash] The data to be used in the query statement.
  # @return [String] The query string in the Odata format.
  #
  def self.odata_query(data)
    supported_types = [Hash, Array]
    unless supported_types.include?(data.class)
      raise ArgumentError, "Data should be #{supported_types}. Provided #{data.class}."
    end
    # This approach works for $filter.
    if data.is_a?(Hash)
      # TODO: implement 'ne' operator
      query = data.each_with_object([]) do |(k, v), acc|
        v = v.delete_suffix('/').delete_prefix('/')
        if k.to_s.start_with?('substring_of_')
          acc << "substringof('#{v}',#{k.to_s[13..-1].camelcase(:lower)})"
        elsif k.to_s.start_with?('starts_with_')
          acc << "startswith(#{k.to_s[12..-1].camelcase(:lower)},'#{v}')"
        else
          acc << "#{k.to_s.camelcase(:lower)} eq '#{v}'"
        end
      end.join(' and ')
    end
    # This works for `$select, $expand`.
    if data.is_a?(Array)
      query = data.join(',')
    end
    query
  end

  def self.validate_resource_uri(resource_uri)
    resource_uri_format = '/subscriptions/{subscription_id}/resourceGroups/{resource_group}/providers/'\
      'Microsoft.Compute/virtualMachines/{resource_name}'
    raise ArgumentError, "Resource URI should be in the format of #{resource_uri_format}. Found: #{resource_uri}" \
      unless resource_uri.start_with?('/subscriptions/') || resource_uri.include?('providers')
  end

  # Disassemble resource_id and extract the resource_group, provider and resource_provider.
  #
  # This is the one and only method where the `resource_provider` is defined differently from the rest.
  # Example: the resource type for the virtual machines is `Microsoft.Compute/virtualMachines` in all other methods.
  #   However, it is divided into 2 entities here as `provider` and `resource_provider`.
  #   provider => `Microsoft.Compute`
  #   resource_provider => `virtualMachines`
  #
  # This can be used for acquiring the latest/default api version for a specific provider.
  #
  # @see https://docs.microsoft.com/en-us/rest/api/resources/resources/getbyid
  #
  # @return [Array] [resource_group, provider, resource_provider]
  # @param resource_uri [String] The URI of the resource,
  #   /subscriptions/{subscription_id}/resourceGroups/{resource_group}/providers/
  #   Microsoft.Compute/virtualMachines/{resource_name}
  def self.res_group_provider_type_from_uri(resource_uri)
    Helpers.validate_resource_uri(resource_uri)
    subscription_resource_group, provider_resource_type = resource_uri.split('/providers/')
    resource_group = subscription_resource_group.split('/').last
    interim_array = provider_resource_type.split('/')
    provider = interim_array[0]
    # interim array can be one of two
    #   1- provider/resource_provider/resource/name
    #   2- provider/parent_resource_type/parent_resource_name/resource_provider/resource_name
    # For the second case, the desired resource_provider is provide/parent_resource_type/resource_provider
    # E.g.
    #   if resource_id: "/subscriptions/{subscription_id}/resourceGroups/{resource_group}/
    #                   providers/Microsoft.Compute/virtualMachines/{vm_name}/extensions/{extension_name}"
    #   provider => "Microsoft.Compute"
    #   resource_provider => "virtualMachines/extensions"
    resource_type = [interim_array[1], interim_array[3]].compact.join('/')
    [resource_group, provider, resource_type]
  end

  # Decide whether to include preview api-versions in the api_Version list.
  # If the latest stable is too old (based on the age_criteria) and there is a newer preview,
  #   then return the preview versions as well.
  def self.normalize_api_list(age_criteria, stable_versions, preview_versions)
    return stable_versions if preview_versions.empty?
    return preview_versions if stable_versions.empty?
    r_stable_versions = stable_versions.sort.reverse
    return_list = r_stable_versions
    r_preview_versions = preview_versions.sort.reverse
    latest_stable_year = r_stable_versions.first[0..3].to_i
    latest_preview_year = r_preview_versions.first[0..3].to_i
    if latest_stable_year < (Time.now.year - age_criteria) && latest_preview_year > latest_stable_year
      return_list += r_preview_versions
    end
    return_list.sort.reverse
  end

  # Deprecation message for the old resources.
  def self.resource_deprecation_message(old_resource_name, new_resource_class)
    "DEPRECATION: `#{old_resource_name}` uses the new resource `#{new_resource_class}` under the hood. "\
  "#{old_resource_name} will be deprecated soon and it is advised to switch to the fully backward compatible new resource. "\
  'Please see the documentation for the additional features available.'
  end

  def self.construct_url(input_list)
    raise ArgumentError, "An array has to be provided. Found: #{input_list.class}." unless input_list.is_a?(Array)
    input_list.each_with_object([]) { |input, list| list << input.delete_suffix('/').delete_prefix('/') }.join('/')
  end
end

# Inspired from: https://gist.github.com/EdvardM/9639051
#
# Applies a given Ruby method on a given Hash keys recursively.
# E.g.: Convert all keys to snakecase
#   RecursiveMethodHelper.method_recursive(hash, :snakecase)
#
# @param hash [Hash] The hash that the Ruby method will be run on its keys.
# @param method [Symbol] The Ruby method that will be called on the keys of the given Hash.
# @return [Hash] The original hash with updates keys recursively with the given Ruby method.
module RecursiveMethodHelper
  def self.method_recursive(hash, method)
    {}.tap do |h|
      hash.each { |key, value| h[key.public_send(method.to_sym)] = RecursiveMethodHelper.transform(value, method) }
    end
  end

  def self.transform(thing, method)
    case thing
    when Hash then method_recursive(thing, method)
    when Array then thing.map { |v| transform(v, method) }
    else; thing
    end
  end
end
