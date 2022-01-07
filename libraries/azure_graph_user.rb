require 'azure_graph_generic_resource'

class AzureGraphUser < AzureGraphGenericResource
  name 'azure_graph_user'
  desc 'Verifies settings for an Azure Active Directory User'
  example <<-EXAMPLE
    describe azure_graph_user(user_id: 'userId') do
      it { should exist }
    end
  EXAMPLE

  def initialize(opts = {})
    # Options should be Hash type. Otherwise Ruby error will be raised.
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    # @see
    #   https://docs.microsoft.com/en-us/graph/api/user-get?view=graph-rest-1.0&tabs=http#examples
    # Azure Graph API HTTP request is in the form of:
    #   GET https://graph.microsoft.com/v1.0/users/{id | userPrincipalName}
    #
    # The dynamic part that has to be created in this resource:
    #   v1.0/users/{id | userPrincipalName}?$select='propertiesToFilterInCamelCase'
    #   (v1.0 is the API version)
    #
    # User supplied parameters:
    #   - api_version => Optional {version}. Default is defined in libraries/backend/helpers.rb as Graph API version.
    #   - id => Mandatory. The unique identifier( {id | userPrincipalName} ) of an individual resource.
    #
    # Hard coded parameter(s):
    #   - resource => users
    #   - select => Query parameters defining which attributes that the resource will expose.
    #
    # If the queried entity does not exist, this resource will pass `it { should_not exist }` test.

    # The unique resource identifiers must be defined here.
    # If more than one are provided at the same time, argument error will be raised.
    opts[:resource_identifiers] = %i(user_principal_name user_id id)

    # Define the resource.
    opts[:resource] = 'users'

    # Properties to expose.
    opts[:select] = 'objectId,accountEnabled,city,country,department,displayName,givenName,jobTitle,mail,'\
      'mailNickname,mobilePhone,passwordPolicies,passwordProfile,postalCode,state,streetAddress,surname,'\
      'businessPhones,usageLocation,userPrincipalName,userType,faxNumber,id'.split(',')

    # At this point there is enough data to make the query.
    # super must be called with `static_resource => true` switch.
    super(opts, true)
  end

  def exists?
    !failed_resource?
  end

  def to_s
    super(AzureGraphUser)
  end

  # Methods for backward compatibility starts here >>>>
  legacy_methods = %w{account_enabled given_name mail_nickname
                      password_policies password_profile postal_code street_address
                      usage_location user_principal_name user_type}
  legacy_methods.each do |method_name|
    define_method method_name.to_sym do
      method(method_name.camelcase(:lower).to_sym).call
    end
  end

  def display_name
    displayName
  end

  define_method :facsimileTelephoneNumber do
    faxNumber
  end

  define_method :mobile do
    mobilePhone
  end

  define_method :telephoneNumber do
    businessPhones.first
  end

  def guest?
    userType == 'Guest'
  end
  # Methods for backward compatibility ends here <<<<
end
