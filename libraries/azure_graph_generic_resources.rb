require_relative 'azure_backend'

class AzureGraphGenericResources < AzureResourceBase
  name 'azure_graph_generic_resources'
  desc 'Inspec plural resource to interrogate any resource type available through Azure Graph API'
  example <<-EXAMPLE
    describe azure_graph_generic_resources(resource_provider: 'users', filter: {given_name: 'John'}) do
      it { should exist }
    end
  EXAMPLE

  attr_reader :table

  def initialize(opts = {}, static_resource = false)
    super(opts)
    # This will be false in the base class if AzureConnection fails.
    return unless http_client_ready?

    # A Graph API HTTP request is in the form of:
    #   {HTTP method} https://graph.microsoft.com/{version}/{resource}?{query-parameters}
    #
    # The dynamic part that has to be created in this resource:
    #   {version}/{resource}?{query-parameters}
    #
    # User supplied parameters:
    #   - api_version => Optional {version}. Default is defined in libraries/backend/helpers.rb as Graph API version.
    #   - resource => Mandatory {resource}. E.g., users, messages.
    #   - filter => Optional. Query parameters to filter the interrogated resource.
    #       E.g.: filter: {given_name: 'John', substring_of_user_principal_name: 'chef'}.
    #   - filter_free_text => Optional. Parameters to filter resource in OData format.
    #       E.g.: filter_free_text: 'givenName eq "John" and substringof("chef", userPrincipalName)'
    #       @see: https://www.odata.org/getting-started/basic-tutorial/
    #       @note: Either `filter` or `filter_free_text` can be provided at the same time.
    #   - select => Optional. Query parameters defining which attributes that the resource will expose.
    #       E.g.: select: ['id', 'displayName', 'givenName']
    #
    # If the queried entity does not exist, this resource will pass `it { should_not exist }` test.
    #
    validate_parameters(
      required: %i(resource),
      allow: %i(select filter filter_free_text),
    )
    @display_name = @opts.slice(:resource, :filter, :filter_free_text).values.join(' ')

    query = {}
    query[:resource] = @opts[:resource]
    query[:api_version] = @opts[:api_version] unless @opts[:api_version].nil?

    query_parameters = {}
    # Ensure that `id` of the resource is returned from the API.
    query_parameters['$select'] = 'id,'
    if @opts[:select]
      # Remove `id` if it is duplicated in user supplied 'select' parameters.
      @opts[:select].delete('id')
      query_parameters['$select'] += Helpers.odata_query(@opts[:select])
    end
    if %i(filter filter_free_text).all? { |a| @opts.keys.include?(a) }
      raise ArgumentError, 'Either `:filter` or `:filter_free_text` should be provided.'
    end
    if @opts[:filter]
      query_parameters['$filter'] = Helpers.odata_query(@opts[:filter])
    end

    # This will allow passing:
    #   $filter=startswith(displayName,'J') or startswith(givenName,'J') or startswith(surname,'M') or
    #           startswith(mail,'J') or startswith(userPrincipalName,'J')
    # @see
    #   https://docs.microsoft.com/en-us/graph/query-parameters#filter-parameter
    if @opts[:filter_free_text]
      query_parameters['$filter'] = @opts[:filter_free_text]
    end
    query[:query_parameters] = query_parameters unless query_parameters.empty?

    catch_failed_resource_queries do
      @resource = resource_from_graph_api(query)
    end

    # If an exception is raised above then the resource is failed.
    # This check should be done every time after using catch_failed_resource_queries
    #
    return if failed_resource?

    @resources = @resource[:value]
    next_link = @resource[:"@odata.nextLink"]
    unless next_link.nil?
      loop do
        url_parsed = URI.parse(next_link)
        query_hash = URI.decode_www_form(url_parsed.query).to_h
        url = next_link.split('?')[0]
        api_response = @azure.rest_get_call(url, query[:api_version], query_hash)
        @resources += api_response[:value]
        return if failed_resource?
        next_link = api_response[:"@odata.nextLink"]
        break if next_link.nil?
      end
    end
    @table = @resources
    if @table == []
      @table_schema = {}
    else
      # Create FilterTable layout dynamically.
      # Column names will be in snakecase and the pluralized form of the `select` parameters.
      @table_schema = @table.first.keys.each_with_object([{ column: :ids, field: :id }]) do |k, acc|
        unless k == :id
          acc << { column: k.to_s.pluralize.snakecase.to_sym, field: k }
        end
      end
    end
    return if static_resource
    AzureGraphGenericResources.populate_filter_table(:table, @table_schema)
  end

  def to_s(class_name = nil)
    api_version = @opts[:api_version] || @azure.graph_api_endpoint_api_version
    api_info = "- api_version: #{api_version} "
    if class_name.nil?
      "#{AzureGraphGenericResources.name.split('_').map(&:capitalize).join(' ')} #{api_info}: #{@display_name}"
    else
      "#{class_name.name.split('_').map(&:capitalize).join(' ')} #{api_info}: #{@display_name}"
    end
  end

  # Populate the FilterTable.
  # FilterTable is a class bound object so is this method.
  # @param raw_data [Symbol] Method name of the table with raw data.
  # @param table_scheme [Array] [{column: :blahs, field: :blah}, {..}]
  def self.populate_filter_table(raw_data, table_scheme)
    filter_table = FilterTable.create
    table_scheme.each do |col_field|
      filter_table.register_column(col_field[:column], field: col_field[:field])
    end
    filter_table.install_filter_methods_on_resource(self, raw_data)
  end
end
