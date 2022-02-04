require 'azure_generic_resource'

class AzureHdinsightCluster < AzureGenericResource
  name 'azure_hdinsight_cluster'
  desc 'Verifies settings for HDInsight Clusters'
  example <<-EXAMPLE
    describe azure_hdinsight_cluster(resource_group: 'example', name: 'name') do
      its(name) { should eq 'name'}
    end
  EXAMPLE

  def initialize(opts = {})
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    opts[:resource_provider] = specific_resource_constraint('Microsoft.HDInsight/clusters', opts)

    # static_resource parameter must be true for setting the resource_provider in the backend.
    super(opts, true)
  end

  def to_s
    super(AzureHdinsightCluster)
  end
end
