
This resource interacts with API versions supported by the resource provider.
You can specify the `api_version` as a resource parameter to use a specific version of the Azure REST API.
If you don't specify an API version, this resource uses the latest version available.
For more information about API versioning, see the [`azure_generic_resource`](../azure_generic_resource).

By default, this resource uses the `azure_cloud` global endpoint and default HTTP client settings.
You can override these settings if you need to connect to a different Azure environment (such as Azure Government or Azure China).
For more information about configuration options, see the [resource pack README](https://github.com/inspec/inspec-azure).
