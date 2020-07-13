# frozen_string_literal: true

require 'azurerm_resource'

class AzurermHdinsightCluster < AzurermSingularResource
  name 'azurerm_hdinsight_cluster'
  desc 'Verifies settings for HDInsight Clusters'
  example <<-EXAMPLE
    describe azurerm_hdinsight_cluster(resource_group: 'example', name: 'name') do
      its(name) { should eq 'name'}
    end
  EXAMPLE

  ATTRS = %i(
    name
    id
    etag
    type
    location
    tags
    properties
  ).freeze

  attr_reader(*ATTRS)

  def initialize(resource_group: nil, name: nil)
    resp = management.hdinsight_cluster(resource_group, name)
    return if has_error?(resp)

    assign_fields(ATTRS, resp)

    @exists = true
  end

  def to_s
    "'#{name}' HDInsight Cluster"
  end
end
