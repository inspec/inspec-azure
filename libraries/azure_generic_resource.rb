require_relative 'azure_backend'

class AzureGenericResource < AzureResourceBase
  name 'azure_generic_resource'
  desc 'Inspec Resource to interrogate any resource type available through Azure Resource Manager'
  example <<-EXAMPLE
    describe azure_generic_resource(resource_group: 'example', name: 'my_resource') do
      its('name') { should eq 'my_resource' }
    end
  EXAMPLE

  def initialize(opts = {}, static_resource = false)
    super(opts)
    # This will be false in the base class if AzureConnection fails.
    return unless http_client_ready?

    if static_resource && !@opts.key?(:resource_id)
      if @opts[:resource_identifiers]
        raise ArgumentError, '`:resource_identifiers` have to be provided within a list.' \
          unless @opts[:resource_identifiers].is_a?(Array)
        # The `name` parameter should have been required in the static resource.
        # Since it is a mandatory field, it is better to make sure that it is in the required list before validations.
        @opts[:resource_identifiers] << :name unless @opts[:resource_identifiers].include?(:name)
        provided = Helpers.validate_params_only_one_of(@__resource_name__, @opts[:resource_identifiers], @opts)
        # Remove resource identifiers other than `:name`.
        unless provided == :name
          @opts[:name] = @opts[provided]
          @opts.delete(provided)
        end
      end
      required_params = %i(resource_group name)
      required_params += @opts[:required_parameters] if @opts.key?(:required_parameters)
      validate_parameters(required: required_params, allow: %i(resource_path resource_identifiers resource_provider))
    elsif static_resource && @opts.key?(:resource_id)
      # Ensure that the provided resource id is for the correct resource provider.
      raise ArgumentError, "Resource provider must be #{@opts[:resource_provider]}." \
          unless @opts[:resource_id].include?(@opts[:resource_provider])
      @opts.delete(:resource_provider)
      validate_parameters(required: %i(resource_id), allow: %i(resource_path resource_identifiers resource_provider))
    else
      # Either one of the following sets can be provided for a valid short description query (to get the resource_id).
      # resource_group + name
      # name
      # tag_name + tag_value
      # resource_group + resource_provider + name
      # resource_id: no other parameters (within above mentioned) should exist
      #
      # If there are static resource specific validations they can be passed here:
      #   required parameters via `opts[:required_parameters]`
      validate_parameters(require_any_of: %i(resource_group name tag_name tag_value resource_id resource_provider))
    end
    @display_name = @opts.slice(:resource_group, :resource_provider, :name, :tag_name, :tag_value, :resource_id)
                         .values.join(' ')

    # Use the latest api_version unless provided.
    api_version = @opts[:api_version] || 'latest'

    # Get/create or acquire the resource_id.
    # The resource_id is a MUST to get the detailed resource information.
    #
    # Use the provided resource_id
    if @opts[:resource_id]
      @resource_id = @opts[:resource_id]

    # Construct the resource_id from parameters if they are sufficient
    elsif %i(resource_group resource_provider name).all? { |param| @opts.keys.include?(param) }
      @resource_id = construct_resource_id

    # Query the resource management endpoint to get the resource_id with the provided parameters.
    else
      filter = @opts.slice(:resource_group, :name, :resource_provider, :tag_name, :tag_value, :location)
      catch_failed_resource_queries do
        # This filter will be used to query the Rest API.
        # At this point the resource_provider should be identical to resource_type which is an allowed query parameter.
        filter[:resource_type] = filter[:resource_provider] unless filter[:resource_provider].nil?
        filter.delete(:resource_provider)
        @resources = resource_short(filter)
      end
      # If an exception is raised above then the resource is failed.
      # This check should be done every time after using catch_failed_resource_queries
      #
      return if failed_resource?

      # Validate short description whether:
      # There is a resource description? (0: it should_not exist, nil: fail resource)
      # There are multiple resource description? (fail resource for singular resource)
      #
      validated = validate_short_desc(@resources, filter, true)
      # If resource description is not in expected format, resource will be failed here.
      return unless validated

      # For a singular resource there must be one and only resource description with a resource_id.
      @resource_id = @resources.first[:id]
    end

    # This is the last check on resource_id before talking to resource manager endpoint to get the detailed information.
    Helpers.validate_resource_uri(@resource_id)
    catch_failed_resource_queries do
      params = { resource_uri: @resource_id, api_version: api_version }
      @resource_long_desc = get_resource(params)
    end
    # If an exception is raised above then the resource is failed.
    # This check should be done every time after using catch_failed_resource_queries
    return if failed_resource?

    # resource_long_desc should be a Hash object
    # &
    # All resources must have a name:
    # https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/naming-and-tagging
    unless @resource_long_desc.is_a?(Hash) && @resource_long_desc.key?(:name)
      resource_fail("Unable to get the detailed information for the resource_id: #{@resource_id}")
    end

    # Create resource methods with the properties of the resource.
    create_resource_methods(@resource_long_desc)
  end

  def exists?
    !failed_resource?
  end

  def to_s(class_name = nil)
    api_info = "- api_version: #{api_version_used_for_query} #{api_version_used_for_query_state}" if defined?(api_version_used_for_query)
    if class_name.nil?
      "#{AzureGenericResource.name.split('_').map(&:capitalize).join(' ')} #{api_info}: #{@display_name}"
    else
      "#{class_name.name.split('_').map(&:capitalize).join(' ')} #{api_info}: #{@display_name}"
    end
  end

  def resource_group
    return unless exists?
    res_group, _provider, _res_type = Helpers.res_group_provider_type_from_uri(id)
    res_group
  end
end
