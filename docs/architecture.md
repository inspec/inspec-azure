# Architecture of the InSpec-Azure Resource Pack

This resource pack presents a unified set of InSpec resources backed by
Microsoft Azure's various HTTP service APIs.

## Services

Each service is implemented as a singleton (pattern) and includes common code
from the `Azure::Service` module such as methods for modifying the singleton's
internal state, a wrapper method for `Azure::Rest#get()`, and response caching.

The service classes define their specifics when initialized and otherwise
simply provide the methods used by resources in this pack to query Azure.

### Example

```ruby
require 'singleton'

module Azure
  class Circus
    include Singleton
    include Service

    # Because of scope, @required_attrs and @page_link_name are defined in the
    # initializer, though they should be constants
    def initialize
      # Requests to Azure services are intercepted to ensure the expected state
      # has been defined, by looking for the things specified here.
      @required_attrs = %i(rest_client subscription_id)

      # The various APIs may each have different names for the key returned
      # when there are additional results available.
      @page_link_name = 'nextLink'
    end

    # Return a single clown car for the given ID in the given resource group
    def clown_car(resource_group, id)
      get(
        url: link(location: 'Microsoft.Circus/clownCars',
                  resource_group: resource_group) + id,
        api_version: '2018-04-01',
      )
    end

    # Return all of the clown cars in the given resource group
    def clown_cars(resource_group)
      get(
        url: link(location: 'Microsoft.Circus/clownCars',
                  resource_group: resource_group),
        api_version: '2018-04-01',
      )
    end

    # Return all of the clown shoes in the given resource_group
    def clown_shoes(resource_group)
      get(
        url: link(location: 'Microsoft.Circus/clownShoes',
                  resource_group: resource_group),
        api_version: '2018-04-01',
      )
    end

    private

    # Resources provided by the Circus API are exposed using a common URL
    # formula, so we can extract some of that here
    def link(location:, provider: true, resource_group: nil)
      "/subscriptions/#{subscription_id}" \
      "#{"/resourceGroups/#{resource_group}" if resource_group}" \
      "#{'/providers' if provider}" \
      "/#{location}/"
    end
  end
end
```

## Resources

The InSpec resources provided in this resource pack do not inherit directly
from `Inspec.resource(1)` as most do. We've found it useful to subclass it with
`AzurermResource`, which collects what would otherwise be rote implementation
spread across all of the InSpec-Azure resources.

However, our resources to not inherit directly from `AzurermResource` either.
Instead there are two subclasses of `AzurermResource` that are subclassed by
our resources: `AzurermPluralResource` and `AzurermSingularResource`.

We define separate classes for plural and singular partly for the semantic
communication—it explicitly conveys to the reader that this is a single item or
a collection of them—but also to provide a compatible interface between the
singular and plural resources so that they both respond to `exists?` without
having to copy the definition for `exists?` into every singular resource.
(Plural resources get `exists?` via FilterTable.)

### Singular Resources

Singular resources are created by subclassing `AzurermSingularResource`. Just
like any InSpec resource, they will be expected to have `to_s` defined, in
addition to the superclass-provided `exists?` method.

Otherwise, each resource has its own set of data to expose, which is done by
assigning values to instance variables, and making those instance variables
public with `attr_reader`.

```ruby
require 'azurerm_resource'

class AzurermClownCar < AzurermSingularResource
  name 'azurerm_clown_car'
  desc 'Verifies settings for an Azure Clown Car'
  example <<-EXAMPLE
    describe azurerm_clown_car(resource_group: 'someCircus', name: 'BeetleBug') do
      it { should exist }
      its('occupants') { should include 'Bozo' }
    end
  EXAMPLE

  ATTRS = {
    name:       :name,
    id:         :id,
    occupants:  :occupants,
  }.freeze

  attr_reader(*ATTRS.keys)

  def initialize(resource_group: nil, name: nil)
    # Query the Circus API for a clown car by the given resource group and name
    car = circus_client.clown_car(resource_group, name)

    # If we somehow don't have the thing we requested, or we have an explicit
    # error from the Azure API, bail
    return if car.nil? || car.key?('error')

    # We just want the occupant names
    @occupants  = Array(car['occupants']).collect { |o| o['name'] }

    # The rest of the values don't require processing, just pull them out of
    # the response and assign them as-is
    assign_fields_with_map(ATTRS, car)

    # If we got this far, our clown car exists
    @exists = true
  end

  def to_s
    "#{name} Clown Car"
  end
end
```

### Plural Resources

Plural resources are created by subclassing `AzurermPluralResource`. As we did
with the singular resource, the plural resource will need a `to_s` methods. However, we do not need to define our own `exists?` method, as that will be provided by `FilterTable`.

```ruby
require 'azurerm_resource'

class AzurermClownCars < AzurermPluralResource
  name 'azurerm_clown_cars'
  desc 'Verifies settings for Azure Clown Cars'
  example <<-EXAMPLE
    describe azurerm_clown_cars(resource_group: 'someCircus') do
      its('names') { should include 'BeetleBug' }
    end
  EXAMPLE

  # FilterTable will need this or a method of the same name
  attr_reader :table

  FilterTable.create
             .register_column(:names, field: 'name')
             .install_filter_methods_on_resource(self, :table)

  def initialize
    cars = circus_client.clown_cars(resource_group)
    return if has_error?(cars)

    # assign our results to the name we gave FilterTable above
    @table = cars
  end

  def to_s
    'Clown Cars'
  end
end
```
