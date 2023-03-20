require "backend/helpers"

# Client class to manage the Azure REST API connection.
#
# An instance of this class will:
#   - create a HTTP client.
#   - read environment variables and gather necessary information for authentication.
#   - authenticate with Azure Rest API and gets an access token.
#   - make the access token available to use.
#
# @author omerdemirok
#
class AzureConnection
  @@token_data = HashRecursive.recursive
  @@provider_details = {}

  # This will be included in headers for statistical purposes.
  INSPEC_USER_AGENT = "pid-18d63047-6cdf-4f34-beed-62f01fc73fc2".freeze

  # @return [String] the resource management endpoint url
  attr_reader :resource_manager_endpoint_url

  # @return [String] the resource management endpoint api version, e.g. 2020-01-01
  attr_reader :resource_manager_endpoint_api_version

  # @return [String] the graph api endpoint url
  attr_reader :graph_api_endpoint_url

  # @return [String] the endpoint suffix for storage accounts
  attr_reader :storage_endpoint_suffix

  # @return [String] the endpoint dns suffix for key vaults
  attr_reader :key_vault_dns_suffix

  # @return [String] the graph api endpoint api version, e.g. v1.0
  attr_reader :graph_api_endpoint_api_version

  # Creates a HTTP client.
  def initialize(client_args)
    # Validate parameter's type.
    raise ArgumentError, "Parameters must be provided in an Hash object." unless client_args.is_a?(Hash)

    # The valid client args:
    #   - endpoint: [String]
    #       azure_cloud, azure_china_cloud, azure_us_government_L4, azure_us_government_L5, azure_german_cloud
    #   - azure_retry_limit: [Integer] Maximum number of retries (default - 2)
    #   - azure_retry_backoff: [Integer] Pause in seconds between retries (default - 0)
    #   - azure_retry_backoff_factor: [Integer] The amount to multiply each successive retry's interval amount by
    #       in order to provide back-off (default - 1)
    @client_args = client_args

    raise StandardError, "Endpoint has to be provided to establish a connection with Azure REST API." \
      unless @client_args.key?(:endpoint)
    @resource_manager_endpoint_url = @client_args[:endpoint].resource_manager_endpoint_url
    @resource_manager_endpoint_api_version = @client_args[:endpoint].resource_manager_endpoint_api_version
    @graph_api_endpoint_url = @client_args[:endpoint].graph_api_endpoint_url
    @storage_endpoint_suffix = @client_args[:endpoint].storage_endpoint_suffix
    @key_vault_dns_suffix = @client_args[:endpoint].key_vault_dns_suffix
    @graph_api_endpoint_api_version = @client_args[:endpoint].graph_api_endpoint_api_version
    @connection ||= Faraday.new do |conn|
      # Implement user provided HTTP client params for handling TimeOut exceptions.
      # https://www.rubydoc.info/gems/faraday/Faraday/Request/Retry
      conn.request(:retry, max: @client_args[:azure_retry_limit],
                   interval: @client_args[:azure_retry_backoff],
                   backoff_factor: @client_args[:azure_retry_backoff_factor])
      # Convert response to a JSON object and symbolize names.
      conn.response :json, content_type: /\bjson$/, parser_options: { symbolize_names: true }
      conn.adapter Faraday.default_adapter
    end
    # subscriptionId = 'e9f33b12-2297-4b42-bd77-74a71ec7bb1a' #ENV['AZURE_SUBSCRIPTION_ID']
    # azureAccessToken=`az account get-access-token --subscription #{subscriptionId}`
    # token = "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsIng1dCI6Ii1LSTNROW5OUjdiUm9meG1lWm9YcWJIWkdldyIsImtpZCI6Ii1LSTNROW5OUjdiUm9meG1lWm9YcWJIWkdldyJ9.eyJhdWQiOiJodHRwczovL21hbmFnZW1lbnQuY29yZS53aW5kb3dzLm5ldC8iLCJpc3MiOiJodHRwczovL3N0cy53aW5kb3dzLm5ldC9kYjI2NmE2Ny1jYmUwLTRkMjYtYWUxYS1kMDU4MWZlMDM1MzUvIiwiaWF0IjoxNjc5MzM4NjUwLCJuYmYiOjE2NzkzMzg2NTAsImV4cCI6MTY3OTM0NDI5NiwiYWNyIjoiMSIsImFpbyI6IkFYUUFpLzhUQUFBQVl1OExYVk90S3JrWUVDMVJpeWM0WGdLbi9LVnM1U3FZT1NFcksreXJXUlBUR2RzSTdrQjQrNVl6ckVBVUNqUFFiUTdOWkNqMjNpd2hjZXNkSDRqZjdtOGpTM3lyeWhxVDhodmxPNzZ4V3AxeE9BVVJ2ekNHMmV6bWptcVFicUo3NUNxSmxoaEJhOHlkUVhMdXBlT0RzZz09IiwiYW1yIjpbInB3ZCIsIm1mYSJdLCJhcHBpZCI6IjA0YjA3Nzk1LThkZGItNDYxYS1iYmVlLTAyZjllMWJmN2I0NiIsImFwcGlkYWNyIjoiMCIsImZhbWlseV9uYW1lIjoiQW5hbmQiLCJnaXZlbl9uYW1lIjoiU2FtaXIiLCJncm91cHMiOlsiM2E4MDUzMWItMmI1Zi00YTdiLTg2ZjEtNGNkM2Q1YjRkMzY4IiwiYWRjMDczMjEtZWYyYi00NGQ1LWEyMTAtNTU5YWE1ZjEwZjJkIiwiZjBmZjMzMjktZmVlNS00Y2JhLWFkN2YtNjVjNGY2YThlOWRmIiwiMGJmMjkyMjktNTBkNy00MzNjLWIwOGUtMmE1ZDhiMjkzY2I1IiwiNzcyMTQ5NTQtODhlNy00NjMxLWI2NGYtODdlYTBmOGIzZTNjIiwiNTIxMTNjNzQtYzdhZC00Mzc2LTgyYjEtODViN2QzYTg0MDdiIiwiYTJhZTk1N2UtOTI1NC00MzU0LWJlMTgtMWFlNGE4ZmI0MzY4IiwiN2UyNTI4ODAtNzQ4ZS00NmVlLWExZWEtNmM2N2E3MWUzYzExIiwiNGZiMzJhOGUtNDAzZC00NzNkLWE1YmYtMTY1MGQ1OTdjMzc1IiwiNGMyMzk5OTItODk5OS00ZTMwLTllZDUtZWZmZjI4YjQxNWJlIiwiYWIzODkwYjAtNTU2NS00OTgyLWEzMDAtZjQ3MjhkNjIwN2FmIiwiNzMwYzg5YmMtMzE3OC00MThlLWEzMWEtNWYxNjU0ZjU1MmExIiwiOTZlYzIwYzQtZGE5ZC00MmU1LTllZWMtNDVmMWVlZmQwYmRlIiwiYTIxYmU3YzQtMWQwMy00M2FmLWI"
    # @connection ||= Faraday.new do |conn|
    #   conn.request :authorization, 'Bearer', azureAccessToken
    #   conn.response :json, content_type: /\bjson$/, parser_options: { symbolize_names: true }
    #   conn.adapter Faraday.default_adapter
    # end
  end

  # azure://<client_id>:<secret>@<tenant_id>/<subscription_id>
  # @return [Hash] tenant_id, client_id, client_secret, subscription_id
  def credentials
    # azure://<user>:<password>@<host>/<path>
    @credentials ||= {
      tenant_id: creds_from_uri[:host] || ENV["AZURE_TENANT_ID"],
      client_id: creds_from_uri[:user] || ENV["AZURE_CLIENT_ID"],
      client_secret: creds_from_uri[:password] || ENV["AZURE_CLIENT_SECRET"],
      subscription_id: creds_from_uri[:path]&.gsub("/", "") || ENV["AZURE_SUBSCRIPTION_ID"],
    }
  end

  def provider_details
    @@provider_details
  end

  # Make a HTTP GET request to Azure Rest API.
  #
  # Azure Rest API requires access token for every query.
  # If a token data exist for a resource it will be used, if not, new one will be created by #authenticate.
  #
  # @return [Hash] The HTTP response body as a JSON/XML object.
  # Properties can be accessed via symbol key names if it is JSON.
  # @param opts [Hash] Some required and optional arguments for an HTTP request.
  #   url: The URL. Required.
  #   params: The HTTP request parameters. Optional.
  #   headers: The HTTP headers. Optional.
  #   method: The HTTP method. Optional, default is GET.
  #   req_body: Optional. The request body if it is a POST request.
  #   audience: The audience for the authentication. Optional, it will be extracted frm the URL unless provided.
  #
  def rest_api_call(opts)
    Validators.validate_parameters(resource_name: @__resource_name__,
                                   required: %i(url),
                                   allow: %i(params headers method req_body audience),
                                   opts: opts, skip_length: true)
    uri = URI(opts[:url])
    # If the authentication audience is provided, use it.
    resource = opts[:audience] || "#{uri.scheme}://#{uri.host}"

    # If it is a paged response than the provided nextLink will contain `skiptoken` in parameters.
    unless opts[:url].include?("skiptoken")
      # Authenticate if necessary.
      authenticate(resource) if @@token_data[resource.to_sym].nil? || @@token_data[resource.to_sym].empty?
      # Update access token if expired.
      # authenticate(resource) if Time.now > @@token_data[resource.to_sym][:token_expires_on]
    end
    # Create the necessary headers.
    opts[:headers] ||= {}
    opts[:headers]["User-Agent"] = INSPEC_USER_AGENT
    opts[:headers]["Authorization"] = "#{@@token_data[resource.to_sym][:token_type]} #{@@token_data[resource.to_sym][:token]}"
    opts[:headers]["Accept"] = "application/json"
    opts[:method] ||= "get"
    resp = send_request(opts)

    if resp.status == 200
      return resp.headers if resp.env.method == :head
      resp.body
    else
      fail_api_query(resp)
    end
  end

  # Get the access token for Azure Rest API.
  #
  # @return [nil]
  #
  # Following class variables will be created:
  #   @@token_data[:resource][:token]  access_token for Azure Rest API queries
  #   @@token_data[:resource][:token_expires_on] [TimeClass]
  #   @@token_data[:resource][:token_type] token_type, e.g.: Bearer
  #
  # https://docs.microsoft.com/en-us/rest/api/azure/
  #
  def authenticate(resource)

    # # Validate the presence of credentials.
    # unless credentials.values.compact.delete_if(&:empty?).size == 4
    #   raise HTTPClientError::MissingCredentials, "The following must be set in the Environment:"\
    #     " #{credentials.keys}.\n"\
    #     "Missing: #{credentials.keys.select { |key| credentials[key].nil? }}"
    # end
    tenant_id = 'db266a67-cbe0-4d26-ae1a-d0581fe03535'
    # Build up the url that is required to authenticate with Azure REST API
    auth_url = "#{@client_args[:endpoint].active_directory_endpoint_url}#{tenant_id}/oauth2/token"

    if !credentials[:client_secret].nil? && credentials[:client_secret]!='dummy'
      body = {
        grant_type: "client_credentials",
        client_id: credentials[:client_id],
        client_secret: credentials[:client_secret],
        resource: resource,
      }
      headers = {
        "Content-Type" => "application/x-www-form-urlencoded",
        "Accept" => "application/json",
      }
      resp = @connection.post(auth_url) do |req|
        req.body = URI.encode_www_form(body)
        req.headers = headers
      end

      if resp.status == 200
        response_body = resp.body
        @@token_data[resource.to_sym][:token] = response_body[:access_token]
        @@token_data[resource.to_sym][:token_expires_on] = Time.at(Integer(response_body[:expires_on]))
        @@token_data[resource.to_sym][:token_type] = response_body[:token_type]
      else
        fail_api_query(resp)
      end
    end
    accessToken = `az account get-access-token --query accessToken -o tsv`
    @@token_data[resource.to_sym][:token] = accessToken
    @@token_data[resource.to_sym][:token_type] = 'bearer'
  end

  # Raise custom exceptions for failed Azure Rest API calls.
  #
  # @raise [UnsuccessfulAPIQuery]
  #
  # TODO: Improve decision making. It relies on the content of the Azure error messages which might be changed over time.
  def fail_api_query(resp, message = nil)
    message ||= "Unsuccessful HTTP request to Azure REST API.\n"
    message += "HTTP #{resp.status}.\n"
    body = resp.body
    if body.empty?
      raise UnsuccessfulAPIQuery::UnexpectedHTTPResponse, message
    end
    if body.instance_of?(Hash)
      code = body[:code]
      error_message = body[:message]
      error = body[:error]
      if error.is_a?(Hash)
        code ||= error[:code]
        error_message ||= error[:message]
      end
      message += code.nil? ? "#{code} #{error_message}" : resp.body.to_s
      resource_not_found_codes = %w{Request_ResourceNotFound ResourceGroupNotFound ResourceNotFound NotFound}
      resource_not_found_keywords = ["could not be found"]
      wrong_api_keywords = ["The supported api-versions are", "The supported versions are", "Consider using the latest supported version"]
      explicit_invalid_api_code = "InvalidApiVersionParameter"
      possible_invalid_api_codes = %w{InvalidApiVersionParameter NoRegisteredProviderFound InvalidResourceType BadParameter}
      code = code.to_s
      if code
        if code == explicit_invalid_api_code \
      || possible_invalid_api_codes.include?(code) && wrong_api_keywords.any? { |word| error_message.include?(word) }
          raise UnsuccessfulAPIQuery::UnexpectedHTTPResponse::InvalidApiVersionParameter, error_message
        elsif resource_not_found_codes.include?(code) \
      || resource_not_found_codes.any? { |not_found_code| code.include?(not_found_code) } \
      && resource_not_found_keywords.any? { |word| error_message.include?(word) }
          raise UnsuccessfulAPIQuery::ResourceNotFound, error_message
        end
      end
      if resource_not_found_codes.include?(body[:httpStatusCode])
        raise UnsuccessfulAPIQuery::ResourceNotFound, message
      end
      raise UnsuccessfulAPIQuery::UnexpectedHTTPResponse, "#{message} #{body}"
    else
      raise UnsuccessfulAPIQuery::UnexpectedHTTPResponse, message
    end
  end

  def send_request(opts)
    case opts[:method]
    when "get"
      @connection.get(opts[:url]) do |req|
        req.params =  opts[:params] unless opts[:params].nil?
        req.headers = opts[:headers].merge(opts[:headers]) unless opts[:headers].nil?
      end
    when "post"
      @connection.post(opts[:url]) do |req|
        req.params = opts[:params] unless opts[:params].nil?
        req.headers = opts[:headers].merge(opts[:headers]) unless opts[:headers].nil?
        req.body = opts[:req_body] unless opts[:req_body].nil?
      end
    when "head"
      @connection.head(opts[:url]) do |req|
        req.params = opts[:params] unless opts[:params].nil?
        req.headers = opts[:headers] unless opts[:headers].nil?
      end
    else
      raise StandardError, "This method is not supported: #{opts[:method]}"
    end
  end

  private

  def creds_from_uri
    return @creds_from_uri if defined? @creds_from_uri

    if ENV["RAKE_ENV"] == "test"
      Inspec::Config.mock.unpack_train_credentials
    else
      begin
        config = Inspec::Config.cached
        # existing external platforms might not be aware of above environment variable
        # some backends don't respond to unpack_train_credentials method
        return {} unless config.respond_to?(:unpack_train_credentials)

        config.unpack_train_credentials
      rescue StandardError => _e
        {}
      end
    end
  end
end
