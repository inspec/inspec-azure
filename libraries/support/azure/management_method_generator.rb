# frozen_string_literal: true

require 'yaml'
require 'plural'

module Azure
  module ManagementMethodGenerator
    class Resource
      # We expect these keys to always be defined and have values in the YAML
      ATTRS = %i(
        api_version
        location
        name
        plural
        provider
        resource_group
        singular
      ).freeze

      # Use attr_reader unless we're defining a getter ourselves
      attr_reader(*ATTRS.reject { |a| a == :location })

      def initialize(pairs)
        ATTRS.map { |a| instance_variable_set(:"@#{a}", pairs.fetch(a.to_s)) }
      end

      def quantities
        %i(plural singular).select { |qty| send(qty) }
      end

      # Snake case form of resource name, appropriate for use as a method name
      # Ex: 'Virtual Cloud Thing' -> 'virtual_cloud_thing'
      def singular_name
        name.downcase.tr(' ', '_').to_s
      end

      # Snake case form of resource name, appropriate for use as a method name
      # Ex: 'Virtual Cloud Things' -> 'virtual_cloud_things'
      def plural_name
        parts = name.downcase.split
        final = parts.pop

        :"#{parts.join('_')}_#{final.plural}"
      end

      # Portion of resource URL specific to the resource type
      def location
        "#{'/providers/' if @provider}#{@location}"
      end
    end

    # Accept the path to a YAML file defining Manage API resources
    # Return array of hashes defining names and lambdas to use in constructing
    # methods to access the API resources
    def self.generate(mgmt_def_file)
      YAML.load_file(mgmt_def_file).collect(&new_resource).map do |resource|
        qty_with_res = ->(qty) { { resource: resource, quantity: qty } }

        resource.quantities.collect(&qty_with_res).collect(&method_data)
      end.flatten
    end

    def self.new_resource
      ->(hash) { Resource.new(hash) }
    end

    # Return a lambda that accepts resource and quantity information and
    # returns the appropriate method name and body
    def self.method_data
      lambda do |data|
        resource, quantity = data.values_at(:resource, :quantity)

        {
          name: method_name(resource, quantity),
          body: send(body_name(resource, quantity), resource),
        }
      end
    end

    # Determine which method should be used to generate the method body
    def self.body_name(res, qty)
      :"def_#{qty}_method#{'_with_resource_group' if res.resource_group}"
    end

    # Return the method name by calling the method appropriate for a given
    # resource quantity form (singular/plural)
    def self.method_name(res, qty)
      res.send(:"#{qty}_name")
    end

    # Access method for a plural resource
    def self.def_plural_method(resource)
      lambda do
        get(
          url: link(location: resource.location),
          api_version: resource.api_version,
        )
      end
    end

    # Access method for a plural resource that requires a resource group
    def self.def_plural_method_with_resource_group(resource)
      lambda do |resource_group|
        get(
          url: link(location: resource.location, resource_group: resource_group),
          api_version: resource.api_version,
        )
      end
    end

    # Access method for a singular resource
    def self.def_singular_method(resource)
      lambda do |id|
        get(
          url: link(location: resource.location) + id,
          api_version: resource.api_version,
        )
      end
    end

    # Access method for a singular resource that requires a resource group
    def self.def_singular_method_with_resource_group(resource)
      lambda do |resource_group, id|
        get(
          url: link(location: resource.location, resource_group: resource_group) + id,
          api_version: resource.api_version,
        )
      end
    end
  end
end
