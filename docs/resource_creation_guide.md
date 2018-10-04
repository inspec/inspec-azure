This guide is intended to give a generic overview of where to look when starting to add a new resource.

Typically there are two resources created for each resource type, singular and plural. See [architecture documentation for more details](./architecture.md)

The singular resource (`azurerm_subnet`) is used to test a specific resource of that type and should include all of the properties available. A plural resource (`azurerm_subnets`) is used to test the collection of resources of that type. This allows for tests to be written based on the group of resources.

## Update libraries/support/azure/management.rb
The files in `libraries/support/azure` define how things are downloaded by the API. A definition needs to be added for the types of resources you're going to be testing for (i.e. virtual machine, virtual networks, subnets, etc). This definition will need to include the location of the resource in the API. This is essentially the type of object. The [Azure Resource Explorer](https://resources.azure.com) can be used to determine the location by browsing for an object and referencing the object type.
```
# Example: defines both subnet and subnets

def subnet(resource_group, id)
  get(
    url: link(location: 'Microsoft.Network/virtualNetworks/subnets',
              resource_group: resource_group) + id,
    api_version: '2018-02-01',
  )
end

def subnets(resource_group)
  get(
    url: link(location: 'Microsoft.Network/virtualNetworks/subnets',
              resource_group: resource_group),
    api_version: '2018-02-01',
  )
end
```

## Create library files
All of the InSpec resource extensions are located in the `libraries` directory. Copy two of the files (singular and plural) for a similar resource as a starting point. Start by removing most of the definitions and adding what is needed for the resource once all of the infrastructure is in place.
Consider the following:
- Change the name to match the resource your creating.
  - (i.e. `libraries/azurerm_subnet.rb` and `libraries/azurerm_subnets.rb`)
- Rename the class match the resource.
```
class AzurermSubnet < AzurermSingularResource
  name 'azurerm_subnet'
```
- Update the `desc` and `example`
- Remove any definitions that don't apply to this resource.
- Within the `initialize` definition, update the method that is called to match the appropriate definition that was added in `libraries/support/azure/management.rb`
```
def initialize(resource_group: nil, name: nil)
  resp = client.subnet(resource_group, name)
  return if has_error?(resp)
```

## Update Terraform outputs
- Background:
  - The `rake tf:apply` command creates Azure infrastructure based on `terraform/azure.tf`. It then takes the Terraform outputs and creates `.$(whoami)-attributes.yml` with them.
  - The `rake test:integration` command injects the attributes defined in the `.$(whoami)-attributes.yml`. These are then compared to the results collected by InSpec.
  - Essentially inspec the controls defined in /tests/integration/verify/contols compare what terraform reports as being built with what Inspec is reporting. If they match, we mark the test as complete.
- Resources may need to be built by adding them to `azure.tf` and/or outputs may need to be added to `outputs.tf`.
- Ensure Rake command `tf:apply` is run after updating `outputs.tf` so that it updates the attributes file.

### Run `rake tf:apply`
- Make sure Terraform runs successfully and creates all of the infrastructure.
- Verify that `/terraform/.$(whoami)-attributes.yml` contains ouput with property values for the resource being developed.

## Create controls
Azure controls are located in `test/integration/verify/controls/`. Copy two of the files (singular and plural) for a similar resource as a starting point. This is where InSpec tests are defined to insure the resources that are being developed are working correctly.
Consider the following:
- The names should match the corresponding library files (i.e. `azurerm_subnet.rb` and `azurerm_subnets.rb`)
- These files are basically broken into two sections, the attributes and the control.
  - At the top attributes are defined for each property that will be tested.
  - The control is the InSpec control that will be tested when the integration test is run.
- The attributes at the top associate an InSpec variable with an attribute as defined in Terraform.
  - The attribute statements take the form of `var = attribute('tf_output', default: nil)`.
  - Attributes' default statements should, for the most part, be nil.
- Within the control, there should be three describe statements:
  - A `describe` statement that includes all of the available properties to be tested
  - A `describe` statement with a bad name that verifies that it should not exist
  - A `describe` statement with a bad resource group that verifies that it should not exist
  - Other `describe` statements as needed.
- Update the `control` and `describe` names
- Remove any attributes and properties that will not be referencing for this control.
- Update variables and Terraform outputs as needed.

```
resource_group = attribute('resource_group',  default: nil)
subnet         = attribute('subnet_name',     default: nil)
tags           = attribute('subnet_tags',     default: nil)
id             = attribute('subnet_id',       default: nil)
location       = attribute('subnet_location', default: nil)

control 'azurerm_subnet' do
  describe azurerm_subnet(resource_group: resource_group, name: subnet) do
    it              { should exist }
    its('id')       { should eq id }
    its('name')     { should eq subnet }
    its('location') { should eq location }
    its('type')     { should eq 'Microsoft.Network/virtualNetworks/Subnets' }
    its('tags')     { should eq tags }
  end

  describe azurerm_subnet(resource_group: resource_group, name: 'fake') do
    it { should_not exist }
  end

  describe azurerm_subnet(resource_group: 'does-not-exist', name: subnet) do
    it { should_not exist }
  end
end
```

## Properties
To determine which properties are available for a given resource, start by looking in the following locations:
1. The [Azure Resource Explorer](https://resources.azure.com) can be referenced by looking at the resources created by Terraform.
2. Terraform documents and details all of the attributes that are available. Note that the data source for a resource may surface different properties than the resource. A data source object may need to be added to `azure.tf` in order for some properties to be made available.
3. Inserting `require 'pry'; binding.pry` after `resp = line` will allow for inspecting the response to see what properties are available using Pry.

### Generic development process:
- Update the controls to include checks for each of the properties available.
- Write library definitions for each property.
- Run `rake test:integration` to verify that the check is included and the definition tests appropriately.
- Pry can be used to debug code. Add `require 'pry'; binding.pry` to create a break point. When `rake test` is run, InSpec will stop at the break point so that Pry can be used to debug the code.

## Create documentation in `docs/resources`
Once everything is working, documentation must be added for the resources that have been added. Copy similar resource documents in `docs/resources/` and edit them as appropriate. Include enough examples to give a good idea how the resource works. Make sure to include any special case examples that might exist.

## Create a pull request.
- Prior to creating a pull request, make user to do the following:
  - run `bundle exec rake lint` and then fix all of the issues. Some can likely be corrected automatically by running `bundle exec rake rubocop:auto_correct`
  - run `bundle exec rake test` and verify that everything is working.
  - run `git commit -s --amend` to sign the commit.
