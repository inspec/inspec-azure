# frozen_string_literal: true

require 'azurerm_resource'

class AzurermLoadBalancer < AzurermSingularResource
  name 'azurerm_load_balancer'
  desc 'Verifies settings for an Azure Load Balancer'
  example <<-EXAMPLE
    describe azurerm_load_balancer(resource_group: 'rg-1', loadbalancer_name: 'lb-1') do
      it { should exist }
    end
  EXAMPLE

  ATTRS = %i(
    id
    name
    location
    type
    sku
    properties
  ).freeze

  attr_reader(*ATTRS)

  def initialize(resource_group: nil, loadbalancer_name: nil)
    loadbalancer = management.load_balancer(resource_group, loadbalancer_name)
    return if has_error?(loadbalancer)

    assign_fields(ATTRS, loadbalancer)

    @resource_group = resource_group
    @loadbalancer_name = loadbalancer_name
    @exists = true
  end

  def to_s
    "Azure Load Balancer: '#{name}'"
  end
end
