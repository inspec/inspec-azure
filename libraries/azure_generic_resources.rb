require_relative 'azure_backend'

class AzureGenericResources < AzureResourceBase
  name 'azure_generic_resources'
  desc 'Inspec Resource to interrogate any resource type in bulk available through Azure resource manager.'
  example <<-EXAMPLE
    describe azure_static_resources(resource_group: 'my_group') do
      it { should exist }
    end
  EXAMPLE

  attr_reader :table

  def initialize(opts = {}, static_resource = false)
    # A HTTP client will be created in the backend.
    super(opts)
    # This will be false in the base class if AzureConnection fails.
    return unless http_client_ready?

    @display_name = @opts.slice(:resource_group, :resource_path, :name, :resource_provider, :tag_name, :tag_value).values.join(' ')
    if static_resource
      raise ArgumentError, 'Warning for the resource author: `resource_provider` must be defined.' \
      unless opts.key?(:resource_provider)
      @table = []
      @resources = {}
      opts[:api_version] = 'latest' unless opts.key?(:api_version)
      # These are the parameters created in the static resource code, NOT provided by the user.
      allowed_params = %i(resource_path resource_group resource_provider)
      # User provided parameters will be passed here for validation with:
      #   opts[:required_parameters]
      #   opts[:allowed_parameters]
      allowed_params += opts[:allowed_parameters] unless opts[:allowed_parameters].nil?
      parameters_to_validate = {
        required: opts[:required_parameters],
      allow: allowed_params,
      }.each_with_object({}) { |(k, v), acc| acc[k] = v unless v.nil? }
      validate_parameters(parameters_to_validate)
      @display_name = @opts[:display_name] unless @opts[:display_name].nil?
      return
    end

    # Either one of the following sets can be provided for a valid short description query.
    # resource_group
    # name
    # substring_of_name, substring_of_resource_group
    # tag_name + tag_value
    # resource_group + resource_provider
    raise ArgumentError, "#{@__resource_name__}: The `api_version` parameter is not allowed." if opts.key?(:api_version)
    validate_parameters(allow: %i(name
                                  substring_of_name
                                  resource_group
                                  substring_of_resource_group
                                  resource_provider
                                  tag_name
                                  tag_value
                                  location))
    filter = @opts.slice(:resource_group, :name, :resource_provider, :tag_name, :tag_value, :location,
                         :substring_of_name, :substring_of_resource_group)
    catch_failed_resource_queries do
      # This filter will be used to query the Rest API.
      # At this point the resource_provider should be identical to resource_type which is the allowed query parameter.
      filter[:resource_type] = filter[:resource_provider] unless filter[:resource_provider].nil?
      filter.delete(:resource_provider)
      @resources = resource_short(filter)
    end
    # If an exception is raised above then the resource is failed.
    # This check should be done every time after using catch_failed_resource_queries
    return if failed_resource?
    validated = validate_short_desc(@resources, filter, false)
    # When @resources is an empty list the `validated` will be `false`.
    # However, an empty FilterTable should still be created to be able to response `should_not exist` test.
    return unless validated || @resources.empty?
    @table = @resources.empty? ? [] : @resources

    # @table = fetch_data
    table_schema = [
      { column: :ids, field: :id },
      { column: :names, field: :name },
      { column: :tags, field: :tags },
      { column: :types, field: :type },
      { column: :locations, field: :location },
      { column: :created_times, field: :createdTime },
      { column: :changed_times, field: :changedTime },
      { column: :provisioning_states, field: :provisioningState },
    ]
    AzureGenericResources.populate_filter_table(:table, table_schema)
  end

  def to_s(class_name = nil)
    if defined?(api_version_used_for_query)
      api_info = "- api_version: #{api_version_used_for_query} #{api_version_used_for_query_state}" unless api_version_used_for_query.nil?
    end
    if class_name.nil?
      "#{AzureGenericResources.name.split('_').map(&:capitalize).join(' ')} #{@display_name}"
    else
      "#{class_name.name.split('_').map(&:capitalize).join(' ')} #{api_info} #{@display_name}"
    end
  end

  def api_version_used_for_query
    @api_response[:api_version_used_for_query] if @api_response
  end

  def api_version_used_for_query_state
    @api_response[:api_version_used_for_query_state] if @api_response
  end

  # Populate the FilterTable.
  # FilterTable is a class bound object so is this method.
  # @param raw_data [Symbol] Method name of the table with raw data.
  # @param table_scheme [Array] [{column: :blahs, field: :blah}, {..}]
  def self.populate_filter_table(raw_data, table_scheme)
    filter_table = FilterTable.create
    # puts "Table scheme in pop fil met #{table_scheme}"
    # puts "Raw data: #{raw_data}"
    table_scheme.each do |col_field|
      filter_table.register_column(col_field[:column], field: col_field[:field])
    end
    filter_table.install_filter_methods_on_resource(self, raw_data)
  end

  private

  # Call this in the static resources.
  # Get plural resource details and populate @table to be used in FilterTable.
  # Paginate API responses if necessary.
  # @param resource_path [String, nil] A part of the URL that will be used to query resources.
  #   If the endpoint is
  #     `https://management.azure.com/subscriptions/{subscriptionId}/providers/Microsoft.Compute/
  #       virtualMachines?api-version=2019-12-01`
  #   resource_path should be: nil
  #
  #   If the endpoint is
  #     `https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/
  #       Microsoft.DBforMySQL/servers/{serverName}/databases?api-version=2017-12-01`
  #   resource_path should be: `{serverName}/databases`
  #
  # `resource_group` will be added if provided at resource initialization.
  #
  def get_resources(resource_path = nil)
    # Get details of resources and populate the FilterTable via @table.
    # @see https://docs.microsoft.com/en-us/rest/api/compute/virtualmachines/listall
    # GET https://management.azure.com/subscriptions/{subscriptionId}/providers/Microsoft.Compute/virtualMachines?
    #       api-version=2019-12-01
    query_params = @opts.slice(:api_version, :resource_group, :resource_provider)
    query_params[:resource_path] = resource_path unless resource_path.nil?
    catch_failed_resource_queries do
      @api_response = get_resource(query_params)
    end
    # If the resource is failed at this point, the `should_not exist` test should pass.
    # Empty value will ensure that.
    @api_response = { value: [] } if @api_response.nil?
    @resources = @api_response[:value]
    next_link = @api_response[:nextLink]
    # Populate the @table to be used filling the FilterTable
    if respond_to?(:populate_table, true)
      populate_table
    else
      @table = @resources
    end
    return nil if next_link.nil?
    # If there are more than 1000 resources than a nextLink will be returned for paging.
    # @see https://docs.microsoft.com/en-us/rest/api/azure/#async-operations-throttling-and-paging
    loop do
      api_response = get_next_link(next_link)
      return if failed_resource?
      @resources = api_response[:value]
      # Add new items to the @table.
      if method_defined?(:populate_table)
        populate_table
      else
        @table += @resources
      end
      next_link = api_response[:nextLink]
      break if next_link.nil?
    end
    nil
  end
end
