require 'azure_generic_resource'

class AzureMicrosoftDefenderSetting < AzureGenericResource
  name 'azure_microsoft_defender_setting'
  desc 'Retrieves and verifies the settings of an Azure Microsoft Defender Setting.'
  example <<-EXAMPLE
    describe azure_microsoft_defender_setting(name: 'SECURITY_CONTACT_NAME') do
      it { should exist }
    end
  EXAMPLE
  
  def initialize(opts = {})
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)
    raise ArgumentError, '`resource_group` is not allowed.' if opts.key(:resource_group)
    
    opts[:resource_provider] = specific_resource_constraint('Microsoft.Security/settings', opts)
    opts[:allowed_parameters] = %i(built_in)
    
    opts[:resource_uri] = '/providers/Microsoft.Security/settings'
    opts[:add_subscription_id] = opts[:built_in] != true
    
    super(opts, true)
  end
  
  def to_s
    super(AzureMicrosoftDefenderSetting)
  end
end
