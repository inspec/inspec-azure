require "azure_generic_resource"

class AzureDataFactory < AzureGenericResource
  name "azure_data_factory"
  desc "Creates azure data factory"
  example <<-EXAMPLE
    describe azure_data_factory(resource_group: 'example', name: 'factoryName') do
      it { should have_monitoring_agent_installed }
    end
  EXAMPLE

  def initialize(opts = {})
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, "Parameters must be provided in an Hash object." unless opts.is_a?(Hash)
    # Azure REST API endpoint URL format for the resource:
    #   GET https://management.azure.com/subscriptions/${subscriptionId}/resourceGroups/${resourceGroupName}/
    # providers/Microsoft.DataFactory/factories/${factoryName}?api-version=${apiVersion}
    #
    # The dynamic part that has to be created in this resource:
    #   Microsoft.DataFactory/factories/${factoryName}?api-version=${apiVersion}
    #
    # Parameters acquired from environment variables:
    #   - {subscriptionId} => Required parameter. It will be acquired by the backend from environment variables.
    #
    # User supplied parameters:
    #   - resource_group => Required parameter unless `resource_id` is provided. {resourceGroupName}
    #   - name => Required parameter unless `resource_id` is provided. Virtual machine name. {vmName}
    #   - resource_id => Optional parameter. If exists, `resource_group` and `name` must not be provided.
    #     In the following format:
    #       /subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/
    #       /Microsoft.DataFactory/factories/${factoryName}
    #   - api_version => Optional parameter. The latest version will be used unless provided. api-version
    #
    #   **`resource_group` and (resource) `name` or `resource_id`  will be validated in the backend appropriately.
    #     We don't have to do anything here.
    #
    # Following resource parameters have to be defined here.
    #   - resource_provider => Microsoft.DataFactory/factories
    #     The `specific_resource_constraint` method will validate the user input
    #       not to accept a different `resource_provider`.
    #
    opts[:resource_provider] = specific_resource_constraint("Microsoft.DataFactory/factories", opts)
    opts[:required_parameters] = %i(name)
    # static_resource parameter must be true for setting the resource_provider in the backend.
    super(opts, true)
  end

  def to_s
    super(AzureDataFactory)
  end

  def provisioning_state
    properties.provisioningState if exists?
  end

  def repo_configuration_type
    properties.repoConfiguration.type if exists?
  end

  def repo_configuration_project_name
    properties.repoConfiguration.projectName if exists?
  end

  def repo_configuration_account_name
    properties.repoConfiguration.accountName if exists?
  end

  def repo_configuration_repository_name
    properties.repoConfiguration.repositoryName if exists?
  end

  def repo_configuration_collaboration_branch
    properties.repoConfiguration.collaborationBranch if exists?
  end

  def repo_configuration_root_folder
    properties.repoConfiguration.rootFolder if exists?
  end

  def repo_configuration_last_commit_id
    properties.repoConfiguration.lastCommitId if exists?
  end

  def repo_configuration_tenant_id
    properties.repoConfiguration.tenantId if exists?
  end
end
