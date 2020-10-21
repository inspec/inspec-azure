require 'backend/azure_require'

ENV_HASH = ENV.map { |k, v| [k.downcase, v] }.to_h

# Base class for Azure resources.
#
# Provides:
#  - Connection to Azure Rest API.
#  - Parameter validation.
#  - Short description of resources. This includes resource_id.
#  - Detailed (long) description of resources upon providing a resource_id.
#  - Latest or default api version for a resource provider endpoint.
#  - Rescuing invalid api version error by using the suggested api version in the error message.
#  - Creating resource methods dynamically.
#
class AzureResourceBase < Inspec.resource(1)
  def initialize(opts = {})
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)
    @opts = opts

    # Populate client_args to specify AzureConnection
    #
    # The valid client args (all of them are optional):
    #  - endpoint: [String] azure_cloud (default), azure_china_cloud, azure_us_government, azure_german_cloud
    #  - azure_retry_limit: [Integer] Maximum number of retries (default - 2)
    #  - azure_retry_backoff: [Integer] Pause in seconds between retries (default - 0)
    #  - azure_retry_backoff_factor: [Integer] The amount to multiply each successive retry's interval amount
    #     by in order to provide back-off (default - 1)
    @client_args = {}
    # If not provided, the endpoint will be the Global Cloud portal.
    # https://azure.microsoft.com/en-gb/global-infrastructure/
    @client_args[:endpoint] = @opts[:endpoint] || ENV_HASH['endpoint'] || 'azure_cloud'
    unless AzureEnvironments::ENDPOINTS.key?(@client_args[:endpoint])
      raise ArgumentError, "Invalid endpoint: `#{@client_args[:endpoint]}`."\
        " Expected one of the following options: #{AzureEnvironments::ENDPOINTS.keys}."
    end
    # Replace endpoint value with the content of AzureEnvironment instance.
    # @type [Hash]
    endpoint = AzureEnvironments.get_endpoint(@client_args[:endpoint])
    @client_args[:endpoint] = endpoint
    # Set HTTP client retry parameters, defining the timeout exception behavior, if provided.
    @client_args[:azure_retry_limit] = @opts[:azure_retry_limit] || ENV_HASH['azure_retry_limit']
    @client_args[:azure_retry_backoff] = @opts[:azure_retry_backoff] || ENV_HASH['azure_retry_backoff']
    @client_args[:azure_retry_backoff_factor] = @opts[:azure_retry_backoff_factor] || ENV_HASH['azure_retry_backoff_factor']

    # Fail resource if the http client is not properly set up.
    begin
      @azure = AzureConnection.new(@client_args)
    rescue StandardError => e
      message = "HTTP client is failed due to #{e}"
      resource_fail(message)
      raise StandardError, message
    end

    # We can't raise an error due to `InSpec check` builds up a dummy backend and any error at this stage fails it.
    unless @azure.credentials.values.compact.delete_if(&:empty?).size == 4
      Inspec::Log.error 'The following must be set in the Environment:'\
        " #{@azure.credentials.keys}.\n"\
        "Missing: #{@azure.credentials.keys.select { |key| @azure.credentials[key].nil? }}"
    end
  end

  private

  # A Graph API HTTP request is in the form of:
  #   {HTTP method} https://graph.microsoft.com/{version}/{resource}?{query-parameters}
  # For reading resource data, HTTP GET method is required.
  #   https://docs.microsoft.com/en-us/graph/use-the-api#http-methods
  #
  # OData system query options can be used to select or filter resources from the endpoint.
  #   https://docs.microsoft.com/en-us/graph/use-the-api#query-parameters
  # api_version will be defaulted to the endpoint settings if not provided.
  #   AzureEnvironments::ENDPOINTS
  #
  # @example
  #   - Query a single user
  #     GET https://graph.microsoft.com/v1.0/users/{id | userPrincipalName}
  #     id is the object id: 875603e5-1f77-4aab-367c-7a66be11a774
  #     userPrincipalName: jdoe@mycompany.com
  #   - Query multiple users
  #     GET https://graph.microsoft.com/v1.0/users/
  #     result can be tailored by passing parameters as `?$select=objectId,displayName,givenName`
  #
  def resource_from_graph_api(opts)
    Helpers.validate_parameters(resource_name: @__resource_name__, allow: %i(api_version query_parameters),
                                required: %i(resource), opts: opts)
    api_version = opts[:api_version] || @azure.graph_api_endpoint_api_version
    if api_version.size > 10 || api_version.include?('/')
      raise ArgumentError, 'api version can not be longer than 10 characters and contain `/`.'
    end
    resource_trimmed = opts[:resource].delete_suffix('/').delete_prefix('/')
    endpoint_url = @azure.graph_api_endpoint_url
    url = [endpoint_url, api_version, resource_trimmed].join('/')
    query_parameters = opts[:query_parameters].nil? ? {} : opts[:query_parameters]
    @azure.rest_get_call(url, query_parameters)
  end

  # Talk to resource manager endpoint to get the short description of a resource.
  # This will include the resource_id.
  #
  # This operation is not pageable.
  #
  # @return [Array] The short description of resources.
  #
  # Example result will look like:
  #   :id=>"/subscriptions/{subscription_id}/resourceGroups/{resource_group}/providers/Microsoft.Compute/virtualMachines/{resource_name}",
  #   :name=>"{resource_name}",
  #   :type=>"Microsoft.Compute/virtualMachines",
  #   :location=>"westeurope",
  #   :createdTime=>"2018-04-30T08:13:08.5601634Z",
  #   :changedTime=>"2018-04-30T09:23:10.8753511Z",
  #   :provisioningState=>"Succeeded"
  # @note
  #   - Reference: https://docs.microsoft.com/en-us/rest/api/resources/resources/list
  #   - $filter=resourceType eq 'Microsoft.Network/virtualNetworks'
  #   - $filter=tagName eq 'tag1' and tagValue eq 'Value1'
  #   - If filtered by tags, short description won't have the tags property.
  #   - GET https://management.azure.com/subscriptions/{subscription_id}/resources?api-version=2019-10-01&
  #         $filter=resourceGroup eq '{resource_group}' and name eq '{resource_name}'
  def resource_short(opts)
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)
    url = Helpers.construct_url([
                                  @azure.resource_manager_endpoint_url,
                                  'subscriptions',
                                  @azure.credentials[:subscription_id], 'resources'
                                ])
    api_version = @azure.resource_manager_endpoint_api_version
    params = {
      '$filter' => Helpers.odata_query(opts),
      '$expand' => Helpers.odata_query(%w{createdTime changedTime provisioningState}),
      'api-version' => api_version,
    }
    short_description, suggested_api_version = rescue_wrong_api_call(url, params)
    # If suggested_api_version is not nil, then the resource manager api version should be updated.
    unless suggested_api_version.nil?
      @resource_manager_endpoint_api = suggested_api_version
      Inspec::Log.warn "Resource manager endpoint api version should be updated with #{suggested_api_version} in"\
        ' `libraries/backend/helpers.rb`'
    end
    short_description[:value] || []
  end

  # @return [Array] [ HTTP_response_body, api_version_suggested ]
  # @param url [String] The url without any parameters or headers.
  # @param params [Hash] The query parameters without the api version.
  #
  # @note
  #   - HTTP_response_body will be in JSON with symbolized keys.
  #
  # @example Result
  #   [{:value => 'blah'}, '2020-01-01']
  def rescue_wrong_api_call(url, params = {})
    begin
      response = @azure.rest_get_call(url, params)
    rescue UnsuccessfulAPIQuery::UnexpectedHTTPResponse::InvalidApiVersionParameter => e
      api_version_suggested = e.suggested_api_version(params['api-version'])
      unless params['api-version'] == 'failed_attempt'
        Inspec::Log.warn "Incompatible api version: #{params['api-version']}\n"\
        "Trying with the latest api version suggested by the Azure Rest API: #{api_version_suggested}."
      end
      if api_version_suggested.nil?
        Inspec::Log.warn 'Failed to acquire suggested api version from the Azure Rest API.'
      else
        response = @azure.rest_get_call(url, params.merge!({ 'api-version' => api_version_suggested }))
      end
    end
    [response, api_version_suggested]
  end

  # Construct resource_id from the provided parameters.
  #
  # @return [String] The resource_id of an Azure cloud resource.
  # "/subscriptions/{subscription_id}/resourceGroups/{resource_group}/providers/
  #   Microsoft.Compute/virtualMachines/{resource_name}"
  #
  # @note: resource_provider should include parent resource path if there is, e.g.:
  #   Microsoft.Compute/virtualMachines/extensions
  # @see https://docs.microsoft.com/en-us/rest/api/resources/resources/get
  #
  def construct_resource_id
    required_arguments = %i(resource_group name resource_provider)
    raise ArgumentError, "Following parameters should be provided to construct a resource_id: #{required_arguments}" \
      unless required_arguments.all? { |resource_provider| @opts.keys.include?(resource_provider) }
    id_in_list = [
      "/subscriptions/#{@azure.credentials[:subscription_id]}",
      'resourceGroups', @opts[:resource_group],
      'providers', @opts[:resource_provider], @opts[:resource_path],
      @opts[:name]
    ].compact
    id_in_list.join('/').gsub('//', '/')
  end

  # Get the detailed information of an Azure cloud resource by its resource_id from resource manager endpoint.
  # or
  # Get the detailed information of all resources of a subscription by its resource_provider and/or resource_group e.g.:
  #   https://management.azure.com/subscriptions/{subscriptionId}/providers/Microsoft.Compute/virtualMachines?
  #     api-version=2019-12-01
  # or
  # Get the detailed information of all resources from a parent resource endpoint, e.g.:
  #   https://docs.microsoft.com/en-us/rest/api/sql/databases/listbyserver
  #   https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/
  #     Microsoft.Sql/servers/{serverName}/databases?api-version=2017-10-01-preview
  #
  # This operation is pageable, the caller method should check if there is a nextLink property in the response body.
  #
  # @return [Hash]
  #   - The detailed information of a resource if resource_id is provided.
  #   - For plural resources:
  #   - The details of the resources will be in an array. {:value => [{resource_1}, {resource_2}, .. {resource_n}], }
  #
  # @param opts [Hash]
  #   - For singular resources:
  #     - resource_uri: (This is equal to the resource_id in most cases.)
  #       - The ID of the resource, "/subscriptions/{subscription_id}/resourceGroups/{resource_group}/providers/
  #         Microsoft.Compute/virtualMachines/{resource_name}"
  #       - The path of a child resource, "/subscriptions/.../{parentResourceName}/{subDomain}{childResourceName}"
  #         @see: azure_mysql_server.firewall_rules, azure_key_vault.diagnostic_settings
  #   - For plural resource:
  #     - resource_provider: 'Microsoft.Compute/virtualMachines'
  #     - resource_path:
  #       E.g: If the required resource is in '/providers/Microsoft.DBforMySQL/servers/{serverName}/databases'
  #         resource_provider => 'Microsoft.DBforMySQL/servers'
  #         resource_path => '/{serverName}/databases'
  #   - For singular and plural:
  #     api_version => `2020-06-01`, `latest` (default), `default`.
  #
  # Resource group will be added appropriately unless `resource_uri` is provided.
  #   example:
  #   GET https://management.azure.com/subscriptions/{subscriptionId}/providers/
  #     Microsoft.Compute/virtualMachines?api-version=2019-12-01
  #   @example:
  #   GET https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/
  #     Microsoft.Compute/virtualMachines?api-version=2019-12-01
  #
  # Following properties will be added additional to the resource information returned from the Azure Rest API:
  #   - api_version_used_for_query [String] The specific api version used for the query.
  #   - api_version_used_for_query_state [String] The state of the api version used for the query,
  #       `user_provided`, `latest`, `default`.
  #
  def get_resource(opts = {})
    Helpers.validate_parameters(resource_name: @__resource_name__,
                                required: %i(resource_uri),
                                allow: %i(query_parameters),
                                opts: opts)
    params = opts[:query_parameters] || {}
    api_version = params['api-version'] || 'latest'
    if opts[:resource_uri].scan('providers').size == 1
      # If the resource provider is unknown then this method can't find the api_version.
      # The latest api_version will de acquired from the error message via #rescue_wrong_api_call method.
      _resource_group, provider, r_type = Helpers.res_group_provider_type_from_uri(opts[:resource_uri])
    end
    # Some resource names can contain spaces. Decode them before parsing with URI.
    url = URI.join(@azure.resource_manager_endpoint_url, opts[:resource_uri].gsub(' ', '%20'))
    api_version = api_version.downcase
    if %w{latest default}.include?(api_version)
      api_version_info = {}
      # api_version is not a specific version yet: latest or default.
      api_version_info = get_api_version(provider, r_type, api_version) if provider
      # Something was wrong at get_api_version, and we will try to get a valid api_version via rescue_wrong_api_call
      # by providing an invalid api_version intentionally.
      api_version_info[:api_version] = 'failed_attempt' if api_version_info[:api_version].nil?
    else
      api_version_info = { api_version: api_version, api_version_status: 'user_provided' }
    end
    long_description, suggested_api_version = rescue_wrong_api_call(url, params.merge!({ 'api-version' => api_version_info[:api_version] }))
    if long_description.is_a?(Hash)
      long_description[:api_version_used_for_query] = suggested_api_version || api_version_info[:api_version]
      long_description[:api_version_used_for_query_state] = suggested_api_version.nil? ? api_version_info[:api_version_status] : 'latest'
    else
      raise StandardError, "Expected a Hash object for querying #{opts}, but received #{long_description.class}."
    end
    long_description
  end

  # Get the latest or default api version of a resource provider's endpoint from the resource manager endpoint.
  # @return [Hash] {api_version: '2020-06-01', api_version_status: 'default' or 'latest'}
  # @param provider [String] The resource provider, e.g., Microsoft.Compute
  # @param resource_type [String] The resource type, e.g., virtualMachines
  # @param api_version_status [String] `latest` (default), `default`.
  #
  # Not all providers' endpoints define a default api version.
  # In that case, the latest version will be returned regardless of the requested api state.
  #
  # @see https://docs.microsoft.com/en-us/rest/api/resources/providers/get
  #
  def get_api_version(provider, resource_type, api_version_status = 'latest')
    unless %w{latest default}.include?(api_version_status)
      raise ArgumentError, "The api version status should be either `latest` or `default`, given: #{api_version_status}."
    end
    response = { api_version: nil, api_version_status: nil }
    resource_type_env = resource_type.gsub('/', '_')
    in_cache = ENV["#{provider}__#{resource_type_env}__#{api_version_status}"]
    unless in_cache.nil?
      if in_cache == 'use_latest'
        in_cache = ENV["#{provider}__#{resource_type}__latest"]
        api_version_status = 'latest'
      end
      response[:api_version] = in_cache
      response[:api_version_status] = api_version_status
    end
    return response unless response[:api_version].nil?

    # Use the cached provider details if exist.
    if @azure.provider_details[provider.to_sym].nil?
      # If the resource manager api version is updated earlier, use that.
      api_version_mgm = @resource_manager_endpoint_api || @azure.resource_manager_endpoint_api_version
      url = Helpers.construct_url([@azure.resource_manager_endpoint_url, 'subscriptions',
                                   @azure.credentials[:subscription_id], 'providers',
                                   provider])
      provider_details, suggested_api_version = rescue_wrong_api_call(url, { 'api-version' => api_version_mgm })
      # If suggested_api_version is not nil, then the resource manager api version should be updated.
      unless suggested_api_version.nil?
        @resource_manager_endpoint_api = suggested_api_version
        Inspec::Log.warn "Resource manager endpoint api version should be updated to #{suggested_api_version} in `libraries/backend/helpers.rb`"
      end
    else
      provider_details = @azure.provider_details[provider.to_sym]
    end

    resource_type_details = provider_details[:resourceTypes].select { |rt| rt[:resourceType].upcase == resource_type.upcase }&.first
    # For some resource types the api version might be available with their parent resource.
    if resource_type_details.nil? && resource_type.include?('/')
      parent_resource_type = resource_type.split('/').first
      resource_type_details = provider_details[:resourceTypes].select { |rt| rt[:resourceType].upcase == parent_resource_type&.upcase }&.first
    end
    if resource_type_details.nil? || !resource_type_details.is_a?(Hash)
      Inspec::Log.warn "#{@__resource_name__}: Couldn't get the #{api_version_status} API version for `#{provider}/#{resource_type}`. " \
      'Please make sure that the provider/resourceType are in the correct format, e.g. `Microsoft.Compute/virtualMachines`.'
    else
      # Caching provider details.
      @azure.provider_details[provider.to_sym] = provider_details if @azure.provider_details[provider.to_sym].nil?
      api_versions = resource_type_details[:apiVersions]
      api_versions_stable = api_versions.reject { |a| a.include?('preview') }
      api_versions_preview = api_versions.select { |a| a.include?('preview') }
      # If the latest stable version is older than 2 years then use preview versions.
      latest_api_version = Helpers.normalize_api_list(2, api_versions_stable, api_versions_preview).first
      ENV["#{provider}__#{resource_type_env}__latest"] = latest_api_version
      ENV["#{provider}__#{resource_type_env}__default"] = \
        resource_type_details[:defaultApiVersion].nil? ? 'use_latest' : resource_type_details[:defaultApiVersion]
      if api_version_status == 'default'
        if resource_type_details[:defaultApiVersion].nil?
          # This will be used to inform caller function about the actual status of the returned api version.
          api_version_status = 'latest'
          returned_api_version = latest_api_version
        else
          returned_api_version = resource_type_details[:defaultApiVersion]
        end
      else
        returned_api_version = latest_api_version
      end
      response[:api_version] = returned_api_version
      response[:api_version_status] = api_version_status
    end
    response
  end

  # Validate the short description list returned from the resource manager endpoint against a query.
  #
  # @return [TrueClass, FalseClass] Validation status of the resource description list.
  #
  # @param resource_list [Array] The list of short descriptions of resources.
  # @param filter [Hash] The parameters used for the query.
  # @param singular [TrueClass, FalseClass] Define if the expected result is for a singular resource (default - true).
  def validate_short_desc(resource_list, filter, singular = true)
    message = "#{@__resource_name__}: #{@display_name}."\
      " Unable to get the resource short description with the provided data: #{filter}"
    if resource_list.nil?
      resource_fail(message)
      false
    elsif resource_list.empty?
      empty_response_warn(message)
      false
    elsif singular && resource_list.size > 1
      resource_fail
      false
    else
      true
    end
  end

  def validate_resource_uri(opts = @opts)
    Helpers.validate_params_required(%i(add_subscription_id), opts)
    if opts[:add_subscription_id] == true
      opts[:resource_uri] = "/subscriptions/#{@azure.credentials[:subscription_id]}/#{opts[:resource_uri]}"
                            .gsub('//', '/')
    end
    opts[:resource_uri]
  end

  def validate_resource_provider
    # Ensure that the provided resource id is for the correct resource provider.
    if @opts.key?(:resource_id) && !@opts[:resource_id].downcase.include?(@opts[:resource_provider].downcase)
      raise ArgumentError, "Resource provider must be #{@opts[:resource_provider]}."
    end
    if @opts.key?(:resource_uri) && !@opts[:resource_uri].downcase.include?(@opts[:resource_provider].downcase)
      raise ArgumentError, "Resource provider must be #{@opts[:resource_provider]}."
    end
    true
  end

  # Get the paginated result.
  # The next_link url won't be validated since it is provided by the Azure Rest API.
  # @see https://docs.microsoft.com/en-us/rest/api/azure/#async-operations-throttling-and-paging
  #
  # @param next_link [String] The nextLink url provided by the Azure Rest API.
  # @return [Hash] The HTTP response body in JSON/Hash format with symbolized keys.
  #
  def get_next_link(next_link)
    @azure.rest_get_call(next_link)
  end

  # Enforce specific resource type constraint in static resources, e.g: 'azure_virtual_machine'.
  #
  # @return [String] The resource type, 'Microsoft.Compute/virtualMachines'.
  # @param resource_provider [String] The resource type, 'Microsoft.Compute/virtualMachines'.
  # @param opts [Hash] Parameters to validate.
  #
  # The resource_provider parameter should be the first parameter defined in a static resource by using this method.
  # This will ensure that the end user won't be able pass blacklisted parameters
  # which would cause the static resource behave differently than intended.
  #
  # All parameters will be validated again before talking to the Azure API.
  #
  def specific_resource_constraint(resource_provider, opts)
    if opts.is_a?(Hash)
      parameter_blacklist = %i(allowed_parameters required_parameters resource_uri resource_provider display_name
                               tag_name tag_value add_subscription_id resource_type)
      if opts.keys.any? { |key| parameter_blacklist.include?(key) }
        raise ArgumentError, "#{@__resource_name__}: The following parameters are not allowed: "\
          "#{parameter_blacklist}"
      end
    else
      raise ArgumentError, "#{@__resource_name__}: Parameters must be provided in an Hash object."
    end
    resource_provider
  end

  # Intercept failed resource queries.
  #
  # Inform if it is an api issue and present the suggested version by the Azure Rest API.
  #
  # This should be used to ensure to fail the resources properly if they can not be created.
  def catch_failed_resource_queries
    yield
    # Inform user if it is an API incompatibility issue and recommend how to solve it.
  rescue UnsuccessfulAPIQuery::UnexpectedHTTPResponse::InvalidApiVersionParameter => e
    api_version_suggested_list = e.suggested_api_version
    message = "Incompatible api version is provided.\n"\
    "The list of api versions suggested by the Azure REST API is #{api_version_suggested_list}.\n #{e.message}"\
    'Note that if this list includes the invalid api version and it should be removed before using the list.'
    resource_fail(message)
  rescue UnsuccessfulAPIQuery::ResourceNotFound => e
    empty_response_warn(e.message)
  rescue UnsuccessfulAPIQuery::UnexpectedHTTPResponse => e
    message = "Unable to get information from the REST API for #{@__resource_name__}: #{@display_name}.\n#{e.message}"
    resource_fail(message)
  rescue StandardError => e
    message = "Resource is failed due to #{e}. Error backtrace:#{e.backtrace.join(' ')}"
    resource_fail(message)
  end

  # Ensure required parameters have been set to perform backend operations.
  #
  # Some resources may require several parameters to be set, in which case use `required`.
  # Some resources may require at least 1 of n parameters to be set, in which case use `require_any_of`.
  # If a parameter is entirely optional, use `allow`.
  #
  # @see https://github.com/inspec/inspec-aws/blob/master/libraries/aws_backend.rb#L209
  def validate_parameters(allow: [], required: nil, require_any_of: nil)
    opts = @opts
    allow += %i(azure_retry_limit azure_retry_backoff azure_retry_backoff_factor
                endpoint api_version required_parameters allowed_parameters display_name)
    Helpers.validate_parameters(resource_name: @__resource_name__,
                                allow: allow, required: required,
                                require_any_of: require_any_of, opts: opts)
    true
  end

  # Fail resource for various reasons, such as:
  #   - Multiple resources for the provided criteria in singular resources.
  #   - HTTP issues.
  # This will update the @failed_resource variable.
  # The status of the resource can be checked with the 'resource_failed?' method when needed.
  # @param message [String] The reason of the failure (default - Multiple resources returned for the provided criteria.).
  # @return [String] The reason of the failure.
  def resource_fail(message = nil)
    message ||= "#{@__resource_name__}: #{@display_name}. "\
    'Multiple Azure resources were returned for the provided criteria. '\
    'If you wish to test multiple entities, please use the plural resource. '\
    'Otherwise, please provide more specific criteria to lookup the resource.'
    # Fail resource in resource pack. `exists?` method will return `false`.
    @failed_resource = true
    # Fail resource in InSpec core. Tests in InSpec profile will return the message.
    fail_resource(message)
    message
  end

  # This method should be used when Azure API returns an empty response, e.g. '[]'.
  # This will update the @failed_resource variable.
  # The status of the resource can be checked with the 'resource_failed?' method when needed.
  # @return [String] The reason of the failure.
  def empty_response_warn(message = nil)
    message ||= "#{@__resource_name__}: #{@display_name} not found."
    # Fail resource in resource pack. `exists?` method will return `false`.
    @failed_resource = true
    # Do not fail in InSpec core. The test `it { should_not exist }` will pass.
    Inspec::Log.warn message
    message
  end

  # Prevent undefined method error by returning nil.
  # This will prevent breaking a test when queried a non-existing method.
  # @return [NilClass]
  # @see https://github.com/inspec/inspec-azure/blob/master/libraries/support/azure/response.rb
  def method_missing(method_name, *args, &block)
    if respond_to?(method_name)
      super
    else
      NullResponse.new
    end
  end

  # This is a RuboCop requirement.
  def respond_to_missing?(*several_variants)
    super
  end

  # Create the methods for the resource object from the detailed information.
  # This will allow using dot notation to access nested properties of a resource.
  #
  # @example
  #   {:properties => {:osProfile => {:adminUsername}}}
  #   can be accessed via
  #   'properties.osProfile.adminUsername'
  def create_resource_methods(object)
    dm = AzureResourceDynamicMethods.new
    dm.create_methods(self, object)
  end
end

# ================================
#
# This code is taken from here:
#   https://github.com/inspec/inspec-azure/blob/0.6.2/libraries/azure_backend.rb#L320
# It is unchanged, except modifying the missing method behavior.
#
# ================================
#
# Class to create methods on the calling object at run time.
# Each of the Azure Resources have different attributes and properties, and they all need
# to be testable. To do this no methods are hardcoded, each on is created based on the
# information returned from Azure.
#
# The class is a helper class essentially as it creates the methods on the calling class
# rather than itself. This means that there is less duplication of code and it can be
# reused easily.
#
# @author Russell Seymour
# @since 0.2.0
class AzureResourceDynamicMethods
  # Given the calling object and its data, create the methods on the object according
  # to the data that has been retrieved. Various types of data can be returned so the method
  # checks the type to ensure that the necessary methods are configured correctly
  #
  # @param object AzureResourceProbe|AzureResource  The object on which the methods should be created.
  # @param data variant The data from which the methods should be created
  def create_methods(object, data)
    if data.is_a?(Hash)
      data.each do |key, value|
        create_method(object, key, value)
      end
    else
      raise ArgumentError, "Unsupported data type: #{data.class}. Expected Hash."
    end
  end

  private

  # Method that is responsible for creating the method on the calling object. This is
  # because some nesting maybe required. For example of the value is a Hash then it will
  # need to have an AzureResourceProbe create for each key, whereas if it is a simple
  # string then the value just needs to be returned
  #
  # @private
  #
  # @param object [AzureResourceProbe, AzureResource] Object on which the methods need to be created
  # @param name [string] The name of the method
  # @param value [variant] The value that needs to be returned by the method
  def create_method(object, name, value)
    # Create the necessary method based on the var that has been passed
    # Test the value for its type so that the method can be setup correctly
    case value.class.to_s
    when 'String', 'Integer', 'TrueClass', 'FalseClass', 'Fixnum'
      object.define_singleton_method name do
        value
      end
    when 'Hash'
      value.count.zero? ? return_value = value : return_value = AzureResourceProbe.new(value)
      object.define_singleton_method name do
        return_value
      end
    when 'Array'
      # Some things are just string or integer arrays
      # Check this by seeing if the first element is a string / integer / boolean or
      # a hashtable
      # This may not be the best method, but short of testing all elements in the array, this is
      # the quickest test
      case value[0].class.to_s
      when 'String', 'Integer', 'TrueClass', 'FalseClass', 'Fixnum'
        probes = value
      else
        probes = []
        value.each do |value_item|
          probes << AzureResourceProbe.new(value_item)
        end
      end
      object.define_singleton_method name do
        probes
      end
    end
  end
end

# Class object that is created for each element that is returned by Azure.
# This is what is interrogated by Inspec. If they are nested hashes, then this results
# in nested AzureResourceProbe objects.
#
# For example, if the following was seen in an Azure Resource
#    properties -> storageProfile -> imageReference
# Would result in the following nested classes
#    AzureResource -> AzureResourceProbe -> AzureResourceProbe
#
# The methods for each of the classes are dynamically defined at run time and will
# match the items that are retrieved from Azure. See the 'test/integration/verify/controls' for examples
#
# This class will not be called externally
#
# @author Russell Seymour
# @since 0.2.0
# @attr_reader string name Name of the Azure resource
# @attr_reader string type Type of the Azure Resource
# @attr_reader string location Location in Azure of the resource
class AzureResourceProbe
  attr_reader :name, :type, :location, :item, :count

  # Initialize method for the class. Accepts an item, be it a scalar value, hash or Azure object
  # It will then create the necessary dynamic methods so that they can be called in the tests
  # This is accomplished by call the AzureResourceDynamicMethods
  #
  # @return AzureResourceProbe
  def initialize(item)
    dm = AzureResourceDynamicMethods.new
    dm.create_methods(self, item)

    # Set the item as a property on the class
    # This is so that it is possible to interrogate what has been added to the class and isolate them from
    # the standard methods that a Ruby class has.
    # This used for checking Tags on a resource for example
    # It also allows direct access if so required
    @item = item

    # Set how many items have been set
    @count = item.length
  end

  # Allows resources to respond to the `include` test
  # This means that things like tags can be checked for and then their value tested
  #
  # @param [String, Hash] opt Name (or Name=>Value) of the item to look for in the @item property
  def include?(opt)
    unless opt.is_a?(Symbol) || opt.is_a?(Hash) || opt.is_a?(String)
      raise ArgumentError, 'Key or Key:Value pair should be provided.'
    end
    if opt.is_a?(Hash)
      raise ArgumentError, 'Only one item can be provided' if opt.keys.size > 1
      return @item[opt.keys.first&.to_sym] == opt.values.first
    end
    @item.key?(opt.to_sym)
  end

  # Prevent undefined method error by returning nil.
  # This will prevent breaking a test when queried a non-existing method.
  # @return [NilClass]
  # @see https://github.com/inspec/inspec-azure/blob/master/libraries/support/azure/response.rb
  def method_missing(method_name, *args, &block)
    if respond_to?(method_name)
      super
    else
      NullResponse.new
    end
  end

  # This is a RuboCop requirement.
  def respond_to_missing?(*several_variants)
    super
  end

  def to_s
    "#{type}/#{name} has the following properties: #{item.keys.map(&:to_s)}."
  end
end

# Ensure to return nil recursively.
# @see https://github.com/inspec/inspec-azure/blob/master/libraries/support/azure/response.rb
#
class NullResponse
  def nil?
    true
  end
  alias empty? nil?

  def ==(other)
    other.nil?
  end
  alias === ==
  alias <=> ==

  def key?(_key)
    false
  end

  def method_missing(method_name, *args, &block)
    if respond_to?(method_name)
      super
    else
      NullResponse.new
    end
  end

  # This is a RuboCop requirement.
  def respond_to_missing?(*several_variants)
    super
  end
end
