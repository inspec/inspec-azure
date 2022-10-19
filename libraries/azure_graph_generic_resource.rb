require 'azure_backend'

class AzureGraphGenericResource < AzureResourceBase
  name 'azure_graph_generic_resource'
  desc 'Inspec Resource to interrogate any resource type available through Azure Graph API.'
  example <<-EXAMPLE
    describe azure_graph_generic_resource(resource_provider: 'RESOURCE_PROVIDER', name: 'TEST_NAME') do
      its('display_name') { should eq 'John Doe' }
    end
  EXAMPLE

  def initialize(opts = {}, static_resource = false) # rubocop:disable Style/OptionalBooleanParameter TODO: Fix disabled rubocop issue.
    super(opts)

    # A Graph API HTTP request is in the form of:
    #   {HTTP method} https://graph.microsoft.com/{version}/{resource}?{query-parameters}
    #
    # The dynamic part that has to be created in this resource:
    #   {version}/{resource}?{query-parameters}
    #
    # User supplied parameters:
    #   - api_version => Optional {version}. Default is defined in libraries/backend/helpers.rb as Graph API version.
    #   - resource => Mandatory {resource}. E.g., users, messages.
    #   - id => Mandatory. The unique identifier of an individual resource.
    #   - select => Optional. Query parameters defining which attributes that the resource will expose.
    #
    # If the queried entity does not exist, this resource will pass `it { should_not exist }` test.
    #
    if static_resource
      raise ArgumentError, '`:resource_identifiers` have to be provided within a list' unless @opts[:resource_identifiers]
      provided = Validators.validate_params_only_one_of(@__resource_name__, @opts[:resource_identifiers], @opts)
      # We should remove resource identifiers other than `:id`.
      unless provided == :id
        @opts[:id] = @opts[provided]
        @opts.delete(provided)
      end
    end

    validate_parameters(
      required: %i(resource id),
      allow: %i(select resource_identifiers),
    )
    @display_name = @opts.slice(:resource, :id).values.join(' ')

    query = {}
    query[:resource] = [@opts[:resource], @opts[:id]].join('/')
    query[:api_version] = @opts[:api_version] unless @opts[:api_version].nil?

    query_parameters = {}
    if @opts[:select]
      query_parameters['$select'] = Helpers.odata_query(@opts[:select])
    end
    query[:query_parameters] = query_parameters unless query_parameters.empty?

    catch_failed_resource_queries do
      @resource = resource_from_graph_api(query)
    end

    # If an exception is raised above then the resource is failed.
    # This check should be done every time after using catch_failed_resource_queries
    #
    return if failed_resource?
    create_resource_methods(@resource)
  end

  def exists?
    !failed_resource?
  end

  def to_s(class_name = nil)
    api_version = @opts[:api_version] || @azure.graph_api_endpoint_api_version
    api_info = "- api_version: #{api_version} "
    if class_name.nil?
      "#{AzureGraphGenericResource.name.split('_').map(&:capitalize).join(' ')} #{api_info}: #{@display_name}"
    else
      "#{class_name.name.split('_').map(&:capitalize).join(' ')} #{api_info}: #{@display_name}"
    end
  end

  # Track the status of the resource at InSpec Azure resource pack level.
  #
  # @return [TrueClass, FalseClass] Whether the resource is failed or not.
  def failed_resource?
    @failed_resource ||= false
  end
end
