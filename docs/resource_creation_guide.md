# Resource Creation Guide

This guide is intended to give a generic overview of where to look when starting to add a new resource.

Typically there are two resources created for each resource type, singular, and plural.

The singular resource is used to test a specific resource of that type and should include all of the properties available. A plural resource is used to test the collection of resources of that type. This allows for tests to be written based on the group of resources.

In this tutorial `azure_key_vault` and `azure_key_vaults` resources will be created.

InSpec Azure backend classes constitute a simple interface between the InSpec and the desired Azure REST API endpoint. 

For the Azure Key Vault resource, the inheritance order is:
- `AzureKeyVault`: Resource specific input validation.
- `AzureGenericResource`: Construct the resource URI/ID, talk to the API, validate the returned data, create dynamic methods(properties), define the `exists?` method.
- `AzureResourceBase`: Initiate an HTTP client, provide tools for validation and decision making. 
- `Inspec.resource(1)`: InSpec base class for resources.

## Singular Resource

### Resource Initiation Logic:

Find the Azure REST API documentation for the resource being developed, [Azure key vault](https://docs.microsoft.com/en-us/rest/api/keyvault/vaults/get), and follow the instructions here.

- Azure REST API endpoint URL format for this resource:
`https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.KeyVault/vaults/{vaultName}?api-version=2019-09-01`
- The dynamic part that has to be created in the static resource:
`/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.KeyVault/vaults/{vaultName}?api-version=2019-09-01`
- Parameters acquired from environment variables:
  - `{subscriptionId}` => Required parameter. It will be acquired by the backend from environment variables.
- User supplied parameters:
  - `resource_group` => Required parameter unless `resource_id` is provided. `{resourceGroupName}`
  - `name` => Required parameter unless `resource_id` is provided. Name of the resource to be tested. `{vaultName}`
  - `api_version` => Optional parameter. The latest version will be used unless provided.
  - `resource_id` => Optional parameter in the following format:
    `/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.KeyVault/vaults/{vaultName}`.
    This entails `resource_group` and the resource `name`. If exists, other resource-related parameters must not be provided.
- `resource_group`, (resource) `name`, and `resource_id`  will be validated in the backend.
- `resource_provider` has to be defined/created with the help of the `specific_resource_constraint` method for input validation.
- For parameters applicable to all resources, see the project's [README](../README.md).

### Resource Creation

- Create the library file: All of the InSpec resource extensions are located in the `libraries` directory. Copy a similar resource as a starting point. 
- Change the name to match the resource you are creating.
  - i.e. `libraries/azure_key_vault.rb`
- Rename the class match the resource. The `name` will be used as the resource name in InSpec profiles. It has to be unique.
```ruby
class AzureKeyVault < AzureGenericResource
  name 'azure_key_vault'
```
- Update the `desc` and `example`
- Remove any definitions that don't apply to this resource.
- Update the `initialize` method with the following order:
```ruby
def initialize(opts = {})    # Accept parameters as key: value pairs.

  # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
  raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)
  
  # Ensure that the resource will talk to the intended Azure Rest API endpoint and validate user input.
  opts[:resource_provider] = specific_resource_constraint('Microsoft.KeyVault/vaults', opts)

  # static_resource parameter must be true for setting the resource_provider in the backend.
  super(opts, true)
end
```
- Update the `to_s` method.
This can be any string relevant to the resource. However, the following is advised for a standard naming convention across the resources.
```ruby
def to_s
  super(AzureKeyVault)
end
```
At this point, the `libraries/azure_key_vault` should look like:
```ruby
require 'azure_generic_resource'

class AzureKeyVault < AzureGenericResource
  name 'azure_key_vault'
  desc 'Verifies settings and configuration for an Azure Key Vault'
  example <<-EXAMPLE
    describe azure_key_vault(resource_group: 'rg-1', name: 'vault-1') do
      it            { should exist }
      its('name')   { should eq('vault-1') }
    end
  EXAMPLE

  def initialize(opts = {})
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    opts[:resource_provider] = specific_resource_constraint('Microsoft.KeyVault/vaults', opts)

    # static_resource parameter must be true for setting the resource_provider in the backend.
    super(opts, true)
  end

  def to_s
    super(AzureKeyVault)
  end
end
```

### Resource Identifier
Even though using the `name` keyword as a resource identifier is advised, a more specific keyword can be defined with the `resource_identifiers` parameter.
```ruby
opts[:resource_identifiers] = %i(vault_name)
```
Adding this line to the `initialize` method will enable `vault_name` to be used as a keyword along with `name`.

Both are valid in an InSpec profile. 
```ruby
describe azure_key_vault(resource_group: 'rg-1', vault_name: 'vault-1') do
  its('name') { should eq('vault-1') }
end
```
```ruby
describe azure_key_vault(resource_group: 'rg-1', name: 'vault-1') do
  its('name') { should eq('vault-1') }
end
```
### Additional Resource Properties
A single API call will be made in the backend for creating the InSpec resource with the data provided in the `initialize` method. 
It is preferred not to make additional calls in the static methods for easy maintenance and more readable controls in InSpec profiles.
However, in some cases, it might be necessary to aggregate the relevant data and make them available through a single resource.
`additional_resource_properties` method should be used to accomplish this.

The below method can be used to list the `diagnostic settings` of an Azure key vault.
```ruby
def diagnostic_settings
  return unless exists?
  # `additional_resource_properties` method will create a singleton method with the `property_name`
  # and make the api response available through this property.
  additional_resource_properties(
    {
      property_name: 'diagnostic_settings',
      property_endpoint: id + '/providers/microsoft.insights/diagnosticSettings',
      api_version: @opts[:diagnostic_settings_api_version],
    },
  )
end
```
- `return unless exists?` should be the first check in every static method. If the resource is failed, then we can not add a property to it. 
- `property_name`: A singleton method will be created with the provided `property_name`. The diagnostic settings and its content will be accessible via dot notation, e.g., `azure_key_vault.diagnostic_settings`, `azure_key_vault.diagnostic_settings.first.name`.

   Note that the method name (`def diagnostic_settings`) and the `property_name` (`property_name: 'diagnostic_settings'`) in `additional_resource_properties` are identical.
   They must be the same unless the returned data needs to be processed before presenting to the user. For this, see [here](#processing-additional-resource-properties).
- `property_endpoint`: The Azure endpoint for the diagnostic settings is `https://management.azure.com/{resourceUri}/providers/microsoft.insights/diagnosticSettings?api-version=2017-05-01-preview`
  - Only the `{resourceUri}/providers/microsoft.insights/diagnosticSettings` part needs to be defined as the `property_endpoint`
  - The `{resourceUri}` is the `id` property of the Azure key vault resource. So, the `property_endpoint` can be defined as `id + '/providers/microsoft.insights/diagnosticSettings'`
- `api_version`: This is optional. If not provided, the latest version will be used.
  - It can be left to the user preference via `@opts[:diagnostic_settings_api_version]`. To be able to do that `diagnostic_settings_api_version` has to be identified as an allowed parameter in the `initialize` method, and it must have a default value. See [here](###-allowed-parameters).

#### Processing Additional Resource Properties

If we want to create a property returning only the names of the diagnostic settings, we need to create 2 methods for that.
1) For fetching the diagnostic settings,
2) For extracting the names from the diagnostic settings.

Fetching the diagnostic settings.
```ruby
def diagnostic_settings
  return unless exists?
  # `additional_resource_properties` method will create a singleton method with the `property_name`
  # and make the api response available through this property.
  additional_resource_properties(
    {
      property_name: 'diagnostic_settings',
      property_endpoint: id + '/providers/microsoft.insights/diagnosticSettings',
      api_version: @opts[:diagnostic_settings_api_version],
    },
  )
end
```
Extracting the names of diagnostic settings. Please pay attention to the comments.
```ruby
def diagnostic_settings_names
  # Ensure that the resource is created.
  return unless exists?
  # Fetch diagnostic settings unless they have been fetched already.
  diagnostic_settings unless respond_to?(:diagnostic_settings)
  # Properties of each settings can be accessed via dot notation: setting.name
  diagnostic_settings.map { |setting| setting.name }    # [`my_setting_1`, `my_setting_2`, ..]
end
```
- The `diagnostic_settings` in the line `diagnostic_settings unless respond_to?(:diagnostic_settings)` is the actual method created on the resource for fetching the diagnostic settings, `def diagnostic_settings`.
  - It might be more convenient to name this method to prevent confusion, such as `fetch_diagnostic_settings`. 
    In that case `azure_key_vault.diagnostic_settings` won't be available unless the `fetch_diagnostic_settings` method is called up front, such as in the `initialize` method.
- The `diagnostic_settings` in the line `diagnostic_settings.map { |setting| setting.name}` is the singleton method created by the `additional_resource_properties` method via `property_name: 'diagnostic_settings'` at the diagnostic settings fetching stage.

There might be a tendency to chain the after processing to the `additional_resource_properties`, such as:
```ruby
def diagnostic_settings_names
  return unless exists?
  # `additional_resource_properties` method will create a singleton method with the `property_name`
  # and make the api response available through this property.
  additional_resource_properties(
    {
      property_name: 'diagnostic_settings',
      property_endpoint: id + '/providers/microsoft.insights/diagnosticSettings',
      api_version: @opts[:diagnostic_settings_api_version],
    },
  ).map { |setting| setting.name }
end
```
However, this is not an advised pattern, because:
- Every test using the `azure_key_vault.diagnostic_settings_names` will make a new API call to fetch the diagnostic settings. This might not be the intended action and it will increase the test completion time.
- It will make it difficult to reuse the diagnostic settings in another method, such as `diagnostic_settings_types`, `diagnostic_settings_enabled`.

### Allowed Parameters
`allowed_parameters` can be used to enable the resource to accept specific parameters beyond the common ones, such as `resource_group`, `name`, and `api_version`. 

API version of the diagnostic settings for the Azure key vault can be defined by the user after adding the following code to the `initialize` method.
```ruby
opts[:allowed_parameters] = %i(diagnostic_settings_api_version)
```
A default value has to be assigned to prevent using `nil` value.
```ruby
opts[:allowed_parameters] = %i(diagnostic_settings_api_version)
# Assign a default value.
opts[:diagnostic_settings_api_version] ||= 'latest'
```
At this point the resource should look like:
```ruby
require 'azure_generic_resource'

class AzureKeyVault < AzureGenericResource
  name 'azure_key_vault'
  desc 'Verifies settings and configuration for an Azure Key Vault'
  example <<-EXAMPLE
    describe azure_key_vault(resource_group: 'rg-1', vault_name: 'vault-1') do
      it            { should exist }
      its('name')   { should eq('vault-1') }
    end
  EXAMPLE

  def initialize(opts = {})
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    opts[:resource_provider] = specific_resource_constraint('Microsoft.KeyVault/vaults', opts)
    # Key vault name can be accepted with a different keyword, `vault_name`. `name` is default accepted.
    opts[:resource_identifiers] = %i(vault_name)
    opts[:allowed_parameters] = %i(diagnostic_settings_api_version)
    # Assign a default value.
    opts[:diagnostic_settings_api_version] ||= 'latest'

    # static_resource parameter must be true for setting the resource_provider in the backend.
    super(opts, true)    
  end

  def to_s
    super(AzureKeyVault)
  end

  def diagnostic_settings
    return unless exists?
    # `additional_resource_properties` method will create a singleton method with the `property_name`
    # and make the api response available through this property.
    additional_resource_properties(
      {
        property_name: 'diagnostic_settings',
        property_endpoint: id + '/providers/microsoft.insights/diagnosticSettings',
        api_version: @opts[:diagnostic_settings_api_version],
      },
    )
  end
end
```

## Plural Resource

### Resource Initiation Logic:

Find the Azure REST API documentation for the resource being developed, [Azure key vaults](https://docs.microsoft.com/en-us/rest/api/keyvault/vaults/list), and follow the instructions here.

- Azure REST API endpoint URL format listing the all resources:
  - for a given subscription: `https://management.azure.com/subscriptions/{subscriptionId}/providers/Microsoft.KeyVault/vaults?api-version=2019-09-01`
    - The dynamic part that has to be created for this resource: `/subscriptions/providers/Microsoft.KeyVault/vaults?api-version=2019-09-01`
  - or in a resource group only: `https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.KeyVault/vaults?api-version=2019-09-01`
    - The dynamic part that has to be created for this resource: `/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.KeyVault/vaults?api-version=2019-09-01`
- Parameters acquired from environment variables:
    - `{subscriptionId}` => Required parameter. It will be acquired by the backend from environment variables.
- User supplied parameters:
  - `resource_group` => Optional parameter. If not provided all key vaults within the subscription will be listed.
  - `api_version` => Optional parameter. The latest version will be used unless provided.
- `resource_provider` has to be defined/created with the help of `specific_resource_constraint` method for input validation.
- For parameters applicable to all resources, see project's [README](../README.md).

### Resource Creation

- Create the library file: All of the InSpec resource extensions are located in the `libraries` directory. Copy a similar resource as a starting point. 
- Change the name to match the resource you are creating.
  - i.e. `libraries/azure_key_vaults.rb`
- Rename the class match the resource. The `name` will be used as the resource name in InSpec profiles. It has to be unique.
```ruby
class AzureKeyVaults < AzureGenericResource
  name 'azure_key_vaults'
```
- Update the `desc` and `example`
- Remove any definitions that don't apply to this resource.
- Update the `initialize` method with the following order:
```ruby
def initialize(opts = {})    # Accept parameters as key: value pairs.

  # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
  raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)
  
  # Ensure that the resource will talk to the intended Azure Rest API endpoint and validate user input.
  opts[:resource_provider] = specific_resource_constraint('Microsoft.KeyVault/vaults', opts)

  # static_resource parameter must be true for setting the resource_provider in the backend.
  super(opts, true)

  # Check if the resource is failed.
  # It is recommended to check that after every usage of inherited methods or making an API call.
  return if failed_resource?
    
  # Define the column and field names for FilterTable.
  table_schema = [
    { column: :ids, field: :id },
    { column: :names, field: :name },
    { column: :locations, field: :location },
    { column: :types, field: :type },
    { column: :tags, field: :tags },
    { column: :properties, field: :properties },
  ]
    
  # FilterTable is populated at the very end due to being an expensive operation.
  AzureGenericResources.populate_filter_table(:table, table_schema)
end
```
- `table_schema`: A list of hashes with standard keys, `column`, and `field`. 
  The plural resources utilize the [FilterTable](https://github.com/inspec/inspec/blob/master/dev-docs/filtertable-usage.md) and the `table_schema` list is a template for it. 
  The columns will become properties of the plural resources which can be filtered by the fields. They are defined by the resource author and usually the plural form of the corresponding field.
  The fields must be valid properties of the interrogated cloud resource. For the Azure key vault, they must be chosen from the listed properties in [here](https://docs.microsoft.com/en-us/rest/api/keyvault/vaults/get#vault).
  - `azure_key_vaults.names` => A list of all Azure vault names.
  - `azure_key_vaults.where { name.include?('production') }` => A subset of Azure key vault resources with the `production` string in their names.
- Populate the FilterTable with `AzureGenericResources.populate_filter_table(:table, table_schema)`. See [here](https://github.com/inspec/inspec/blob/master/dev-docs/filtertable-usage.md) for more on FilterTable.
- Update the `to_s` method.
This can be any string relevant to the resource. However, the following is advised for a standard naming convention across the resources.
```ruby
def to_s
  super(AzureKeyVaults)
end
```
At this point, the resource should look like:
```ruby
require 'azure_generic_resources'

class AzureKeyVaults < AzureGenericResources
  name 'azure_key_vaults'
  desc 'Verifies settings for a collection of Azure Key Vaults'
  example <<-EXAMPLE
    describe azurerm_key_vaults(resource_group: 'rg-1') do
        it              { should exist }
        its('names')    { should include 'vault-1'}
    end
  EXAMPLE

  attr_reader :table

  def initialize(opts = {})
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    opts[:resource_provider] = specific_resource_constraint('Microsoft.KeyVault/vaults', opts)

    # static_resource parameter must be true for setting the resource_provider in the backend.
    super(opts, true)

    # Check if the resource is failed.
    # It is recommended to check that after every usage of inherited methods or making API calls.
    return if failed_resource?

    # Define the column and field names for FilterTable.
    # In most cases, the `column` should be the pluralized form of the `field`.
    table_schema = [
      { column: :ids, field: :id },
      { column: :names, field: :name },
      { column: :locations, field: :location },
      { column: :types, field: :type },
      { column: :tags, field: :tags },
      { column: :properties, field: :properties },
    ]

    # FilterTable is populated at the very end due to being an expensive operation.
    AzureGenericResources.populate_filter_table(:table, table_schema)
  end

  def to_s
    super(AzureKeyVaults)
  end
end
```
### Manipulating Data in FilterTable
The `populate_table` must be defined in the resource to override the generic behavior.

Let's assume:
 - We want to create 2 columns, `ids` and `enabled_for_deployment`.
   - List the resource ids in the `ids` column.
   - Return the value of the `enabledForDeployment` status (presented in the `properties` hash) of each Azure key vault. See [here](https://docs.microsoft.com/en-us/rest/api/keyvault/vaults/get#vaultproperties).

Required steps:
 - Create the `table_schema` in the `initialize` method.
```ruby
   table_schema = [
     { column: :ids, field: :id },
     { column: :enabled_for_deployment, field: :enabled_for_deployment },
   ]
```
 - Create a new method `populate_table`.
```ruby
  def populate_table
    # If @resources empty than @table should stay as an empty array as declared in superclass.
    # This will ensure constructing resource and passing the `should_not exist` test.
    return [] if @resources.empty?
    @resources.each do |resource|
      @table << {
        id: resource[:id],
        enabled_for_deployment: resource[:properties][:enabledForDeployment],
      }
    end
  end
``` 
This will allow:
```ruby
describe azure_key_vaults.where(enabled_for_deployment: false) do
  it { should exist }
end
```
Background:
- `@resources`: Instance variable. A list containing the all resources.
- `return [] if @resources.empty?`: Ensure constructing the resource and passing `should_not exist` test.
- `@table`: Instance variable. A list of hashes containing the field keys defined in the `table_schema` and their values. 
  The keys used in `@table` must be the same in `field` values defined in `table_schema`.
  
With the custom `populate_table` method added, the resource should look like:
```ruby
require 'azure_generic_resources'

class AzureKeyVaults < AzureGenericResources
  name 'azure_key_vaults'
  desc 'Verifies settings for a collection of Azure Key Vaults'
  example <<-EXAMPLE
    describe azurerm_key_vaults(resource_group: 'rg-1') do
        it              { should exist }
        its('names')    { should include 'vault-1'}
    end
  EXAMPLE

  attr_reader :table

  def initialize(opts = {})
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    opts[:resource_provider] = specific_resource_constraint('Microsoft.KeyVault/vaults', opts)

    # static_resource parameter must be true for setting the resource_provider in the backend.
    super(opts, true)

    # Check if the resource is failed.
    # It is recommended to check that after every usage of inherited methods or making API calls.
    return if failed_resource?

    # Define the column and field names for FilterTable.
    # In most cases, the `column` should be the pluralized form of the `field`.
    table_schema = [
      { column: :ids, field: :id },
      { column: :enabled_for_deployment, field: :enabled_for_deployment },
    ]

    # FilterTable is populated at the very end due to being an expensive operation.
    AzureGenericResources.populate_filter_table(:table, table_schema)
  end

  def to_s
    super(AzureKeyVaults)
  end

  def populate_table
    # If @resources empty than @table should stay as an empty array as declared in superclass.
    # This will ensure constructing resource and passing `should_not exist` test.
    return [] if @resources.empty?
    @resources.each do |resource|
      @table << {
        id: resource[:id],
        enabled_for_deployment: resource[:properties][:enabledForDeployment],
      }
    end
  end
end
```

## Resources Living in/on Another Resources

### Required Parameters
`required_parameters` should be used to make some parameters mandatory at resource creation.

### Resource Path
`resource_path` should be used to construct the URL path between the resource provider and the actual resource name. 

Let's use these new parameters in an example resource, [`azure_sql_database`](resources/azure_sql_database.md).

An Azure SQL database is only accessible through the SQL server on which it has been created.

Here is the the API endpoint for the Azure SQL database:
`https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/databases/{databaseName}?api-version=2019-06-01-preview`

In that scenario, the resource identifiers for the SQL server must be provided by the user.

If we want the test look like this:
```ruby
describe azure_sql_database(resource_group: 'rg-1', server_name: 'sql-server-1', database_name: 'customer-db') do
  it { should exist }
end
```
The `initialize` method should be:
```ruby
def initialize(opts = {})
  # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
  raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

  opts[:resource_provider] = specific_resource_constraint('Microsoft.Sql/servers', opts)
  opts[:required_parameters] = %i(server_name)
  opts[:resource_path] = "#{opts[:server_name]}/databases"
  opts[:resource_identifiers] = %i(database_name)

  # static_resource parameter must be true for setting the resource_provider in the backend.
  super(opts, true)
end
```
- `opts[:required_parameters]`: Makes `server_name` parameter mandatory.`{serverName}`
- `opts[:resource_path]`: The URL path, `{serverName}/databases` to the SQL database name from the resource provider, `Microsoft.Sql/servers`. 
- `opts[:resource_identifiers]`: Makes `database_name` a resource identifier along with the `name` keyword.

## Resources without a Resource Group

### Resource URI
Azure REST API URI of a resource. It requires `add_subscription_id` to be set to either `true` or `false`.

Some Azure resources are not tied to a resource group and do not follow the common pattern explained above.

Let's take a look at the [`azure_policy_definiton`](../libraries/azure_policy_definition.rb).

- The URL endpoint: 
  - for a policy in a subscription: `https://management.azure.com/subscriptions/{subscriptionId}/providers/Microsoft.Authorization/policyDefinitions/{policyDefinitionName}?api-version=2019-09-01`
  - for a built-in policy: `https://management.azure.com/providers/Microsoft.Authorization/policyDefinitions/{policyDefinitionName}?api-version=2019-09-01`
- The dynamic part that has to be created: 
   - for a policy in a subscription: `/subscriptions/{subscriptionId}/providers/Microsoft.Authorization/policyDefinitions/{policyDefinitionName}?api-version=2019-09-01`
     - `{subscriptionId}`: It will be acquired by the backend from environment variables.
   - for a built-in policy: `/providers/Microsoft.Authorization/policyDefinitions/{policyDefinitionName}?api-version=2019-09-01`
- The resource URI:
  - for a policy in a subscription: `/subscriptions/{subscriptionId}/providers/Microsoft.Authorization/policyDefinitions/`
  - for a built-in policy: `/providers/Microsoft.Authorization/policyDefinitions/`
  
  The only difference between these resource URIs is the subscription ID. Since it is available in the backend, we only need to inform backend when to add the subscription ID to the resource URI.
 
- The policy name should be provided via `name` parameter and it will be validated in the backend.

The `initialize` method should look like:
```ruby
  def initialize(opts = {})
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    opts[:resource_provider] = specific_resource_constraint('Microsoft.Authorization/policyDefinitions', opts)

    # `built_in` is a resource specific parameter as oppose to `name` and `api_version`.
    # That's why it should be put in allowed_parameters to be able to pass the parameter validation in the backend.
    opts[:allowed_parameters] = %i(built_in)

    opts[:resource_uri] = '/providers/Microsoft.Authorization/policyDefinitions'
    # The subscription ID will be added to the resource URI in the backend if built_in is false.
    opts[:add_subscription_id] = opts.dig(:built_in) != true

    # static_resource parameter must be true for setting the resource_provider in the backend.
    super(opts, true)
  end
```
- The resource URI is defined with `opts[:resource_uri]`.
- Subscription ID will be added to the resource URI in the backend if the `opts[:add_subscription_id]` is `true`.
  - A new parameter, `built_in`, is declared to hide the technical complexity of making a decision whether or not to add the subscription ID in the resource URI.
  
## Common Parameters

The following optional parameters can be used both in singular and plural resources:
- [`allowed_parameters`](###allowed-parameters)
- [`required_parameters`](###required-parameters)
- [`display_name`](###display-name) 

### Display Name
In InSpec tests, the display name is used while presenting the test results.
Unless it is defined in the static resource, a generic one will be created. E.g., `Azure Sql Databases - api_version: 2020-08-01-preview latest {resourceGroup} {serverName}/databases Microsoft.Sql/servers`

It can be partially customised via `display_name` parameter in the `initialize` method as:
```ruby
opts[:display_name] = "Databases on #{opts[:server_name]} SQL Server"
```
The display name will be: `Azure Sql Databases - api_version: 2020-08-01-preview latest Databases on {serverName} SQL Server`

## Update Terraform outputs

- Background:
  - The `rake tf:apply` command creates Azure infrastructure based on `terraform/azure.tf`. It then takes the Terraform outputs and creates `.$(whoami)-attributes.yml` with them.
  - The `rake test:integration` command injects the attributes defined in the `.$(whoami)-attributes.yml`. These are then compared to the results collected by InSpec.
  - Essentially inspect the controls defined in `/tests/integration/verify/controls`, compare what terraform reports as being built with what InSpec is reporting. If they match, we mark the test as complete.
- Resources may need to be built by adding them to `azure.tf` and/or outputs may need to be added to `outputs.tf`.
- Ensure Rake command `tf:apply` is run after updating `outputs.tf` so that it updates the attributes file.

### Run `rake tf:apply`

- Make sure Terraform runs successfully and creates all of the infrastructures.
- Verify that `/terraform/.$(whoami)-attributes.yml` contains output with property values for the resource being developed.

## Create controls

Azure controls are located in `test/integration/verify/controls/`. Copy two of the files (singular and plural) for a similar resource as a starting point. This is where InSpec tests are defined to ensure the resources that are being developed are working correctly.
Consider the following:
- The names should match the corresponding library files (i.e. `azure_key_vault.rb` and `azure_key_vaults.rb`)
- These files are basically broken into two sections, the attributes, and the control.
  - At the top attributes are defined for each property that will be tested.
  - The control is the InSpec control that will be tested when the integration test is run.
- The attributes at the top associate an InSpec variable with an attribute as defined in Terraform.
  - The attribute statements take the form of `var = input('tf_output', value: 'default_value')`.
- Update the `control` and `describe` names
- Remove any attributes and properties that will not be referencing for this control.
- Update variables and Terraform outputs as needed.
- Within the control, there should be three describe statements:
  - A `describe` statement that includes all of the available properties to be tested.
  - A `describe` statement with a bad name that verifies that it should not exist.
  - A `describe` statement with a bad resource group that verifies that it should not exist.
  - Other `describe` statements as needed.
- Run `rake test:integration` to verify that the check is included and the definition tests appropriately.
- Pry can be used to debug code. Add `require 'pry'; binding.pry` to create a breakpoint. When `rake test` is run, InSpec will stop at the breakpoint so that Pry can be used to debug the code.
```ruby
resource_group = input('resource_group', value: nil)
vault_name     = input('key_vault_name', value: nil)

control 'azure_key_vault' do

  describe azure_key_vault(resource_group: resource_group, vault_name: vault_name) do
    it { should exist }
    its('name') { should eq vault_name }
    its('type') { should eq 'Microsoft.KeyVault/vaults' }
  end

  describe azure_key_vault(resource_group: resource_group, vault_name: 'fake') do
    it { should_not exist }
  end

  describe azure_key_vault(resource_group: 'fake', vault_name: vault_name) do
    it { should_not exist }
  end

end
```
## Create Documentation in `docs/resources`

Once everything is working, documentation must be added for the resources that have been added. Copy similar resource documents in `docs/resources/` and edit them as appropriate. Include enough examples to give a good idea of how the resource works. Make sure to include any special case examples that might exist.
After writing the documentation:
- Run `bundle exec rake docs:resource_links`
- Copy/Paste all display links in the Readme.md

## Create a Pull Request

- Prior to creating a pull request, make sure to do the following:
  - run `bundle exec rake lint` and then fix all of the issues. Some can likely be corrected automatically by running `bundle exec rake rubocop:auto_correct`
  - run `bundle exec rake test` and verify that everything is working.
  - run `git commit -s --amend` to sign the commit.
