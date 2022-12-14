require "azure_graph_generic_resources"

class AzureGraphUsers < AzureGraphGenericResources
  name "azure_graph_users"
  desc "Verifies settings for an Azure Active Directory User"
  example <<-EXAMPLE
    describe azure_graph_users do
      it { should exist }
    end
  EXAMPLE

  def initialize(opts = {})
    # Options should be Hash type. Otherwise Ruby error will be raised.
    raise ArgumentError, "Parameters must be provided in an Hash object." unless opts.is_a?(Hash)

    # @see
    #   https://docs.microsoft.com/en-us/graph/api/user-get?view=graph-rest-1.0&tabs=http#examples
    # Azure Graph API HTTP request is in the form of:
    #   GET https://graph.microsoft.com/v1.0/users
    #
    # The dynamic part that has to be created in this resource:
    #   v1.0/users?$select='propertiesToFilterInCamelCase'&$filter='givenName eq "John"'
    #   (v1.0 is the API version)
    #
    # User supplied parameters:
    #   - api_version => Optional {version}. Default is defined in libraries/backend/helpers.rb as Graph API version.
    #   - filter => Optional. Query parameters to filter the interrogated resource.
    #       E.g.: filter: {given_name: 'John', substring_of_user_principal_name: 'chef'}.
    #   - filter_free_text => Optional. Parameters to filter resource in OData format.
    #       E.g.: filter_free_text: 'givenName eq "John" and substringof("chef", userPrincipalName)'
    #       @see: https://www.odata.org/getting-started/basic-tutorial/
    #       @note: Either `filter` or `filter_free_text` can be provided at the same time.
    #
    # Hard coded parameter(s):
    #   - resource => users
    #   - select => Query parameters defining which attributes that the resource will expose.
    #       E.g.: select: ['id', 'displayName', 'givenName']
    #

    # Define the resource.
    opts[:resource] = "users"

    # Properties to expose.
    opts[:select] = "id,displayName,givenName,jobTitle,mail,userType,userPrincipalName".split(",")

    # At this point there is enough data to make the query.
    # super must be called with `static_resource => true` switch.
    super(opts, true)

    # FilterTable is populated at the very end due to being an expensive operation.
    AzureGraphUsers.populate_filter_table(:table, @table_schema)
  end

  def guest_accounts
    @guest_accounts ||= where(userType: "Guest").mails
  rescue NoMethodError
    []
  end

  # For backward compatibility.
  #   In the legacy resource `objectId` was the GUID.
  #   New Graph API provides the GUID with the `id` attribute.
  def object_ids
    ids
  end

  def to_s
    super(AzureGraphUsers)
  end
end

# Provide the same functionality under the old resource name.
# This is for backward compatibility.
class AzurermAdUsers < AzureGraphUsers
  name "azurerm_ad_users"
  desc "Verifies settings for an Azure Active Directory User"
  example <<-EXAMPLE
    describe azurerm_ad_users do
      it { should exist }
    end
  EXAMPLE

  def initialize(opts = {})
    if opts[:filter].is_a?(String)
      # This is for backward compatibility.
      # Same feature is supported via `filter_free_text` parameter with the new backend.
      opts[:filter_free_text] = opts[:filter]
      opts.delete(:filter)
    end

    Inspec::Log.warn Helpers.resource_deprecation_message(@__resource_name__, AzureGraphUsers.name)
    super
  end
end
