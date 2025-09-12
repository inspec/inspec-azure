+++
title = "About Chef InSpec Azure resources"
platform = "azure"
draft = false
gh_repo = "inspec-alicloud"
linkTitle = "Azure resources"
summary = "Chef InSpec resources for auditing Azure"

[menu.azure]
title = "About"
identifier = "inspec/resources/azure/about"
parent = "inspec/resources/azure"
+++


Chef InSpec provides resources for auditing Azure infrastructure, including virtual machines, storage accounts, databases, and networking components. These resources help you verify that your Azure environment meets security and compliance requirements.

## Initialize an InSpec profile for auditing Azure

You can create a profile for testing Azure resources with `inspec init profile`:

```bash
inspec init profile --platform azure <PROFILE_NAME>
```

If your `inputs.yml` file contains your Azure project ID, you can execute this sample profile using the following command:

```bash
inspec exec <PROFILE_NAME> --input-file=<PROFILE_NAME>/inputs.yml -t azure://
```

## Set Azure credentials

To use Chef InSpec Azure resources, you need to create a service principal Name (SPN) to audit an Azure subscription.

You can create an SPN using the command line or from the Azure Portal:

- [Azure CLI](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-authenticate-service-principal-cli)
- [PowerShell](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-authenticate-service-principal)
- [Azure Portal](https://learn.microsoft.com/en-us/entra/identity-platform/howto-create-service-principal-portal)

You can specify the SPN information in one of three ways:

- In the `~/.azure/credentials` file
- As environment variables
- Using Chef InSpec target URIs

Set the Azure credentials file:

By default, Chef InSpec looks at `~/.azure/credentials`, and it should contain:

```powershell
[<SUBSCRIPTION_ID>]
client_id = "<CLIENT_ID>"
client_secret = "<CLIENT_SECRET>"
tenant_id = "<TENANT_ID>"
```

{{< note >}}

In the Azure web portal, these values have different labels:

- The Azure web portal calls the `client_id` the **Application ID**
- The Azure web portal calls the `client_secret` the **Key (Password Type)**
- The Azure web portal calls the `tenant_id` the **Directory ID**

{{< /note >}}

After you set up the credentials, you can execute Chef InSpec:

```bash
inspec exec <PROFILE_NAME> -t azure://
```

Provide credentials using environment variables:

As an alternative to the credentials file, you can set the Azure credentials using environment variables:

- `AZURE_SUBSCRIPTION_ID`
- `AZURE_CLIENT_ID`
- `AZURE_CLIENT_SECRET`
- `AZURE_TENANT_ID`

For example:

```bash
AZURE_SUBSCRIPTION_ID="2fbdbb02-df2e-11e6-bf01-fe55135034f3" \
AZURE_CLIENT_ID="58dc4f6c-df2e-11e6-bf01-fe55135034f3" \
AZURE_CLIENT_SECRET="Jibr4iwwaaZwBb6W" \
AZURE_TENANT_ID="6ad89b58-df2e-11e6-bf01-fe55135034f3" inspec exec my-profile -t azure://
```

Provide credentials using Chef InSpec target option:

If you have several Azure subscriptions configured in your `~/.azure/credentials` file, you can use the Chef InSpec command line `--target` / `-t` option to select a specific subscription ID. For example:

```bash
inspec exec my-profile -t azure://2fbdbb02-df2e-11e6-bf01-fe55135034f3
```

## Azure resources

{{< inspec_resources_filter >}}

The following Chef InSpec Azure resources are available in this resource pack.

{{< inspec_resources section="azure" platform="azure" >}}
