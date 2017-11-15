- `azure_generic_resource` - This resource using the options to determine what resource(s) are to be retrieved

The following table describes the options that can be passed to the resource

| Name | Description |
|------|-------------|
| group_name | Name of the resource group in which to find resources | 
| name | Name of the specific resource to look for |
| type | Type of resources to look for |
| apiversion | When using the `name` option to look for a specific resource an API Version can be set. If not set the latest version available for that type of resource will be used |

As an alternative the following environment variables can be set instead of passing the options to the control:

 - `AZURE_RESOURCE_GROUP_NAME`
 - `AZURE_RESOURCE_NAME`
 - `AZURE_RESOURCE_TYPE`
 - `AZURE_RESOURCE_API_VERSION`

Note that if options are set on the control and in enviroment variables, the environment variables take perference.

There are _normally_ three standard tests that can be performed on a resource.

| Name | Description |
|------|-------------|
| name | Name of the resource |
| type | Type of resource |
| location | Location of the resource within Azure |