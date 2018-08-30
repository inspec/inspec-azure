# Connectors

This resource pack supports the following connection configurations:

* Environment Variables
* Credentials File
* Managed Service Identity (MSI) Connector

For any of these connection strategies you'll need a Subscription ID and Tenant
ID. These values may be found in the Azure Portal. This guide assumes you are
using a service account. See the
[README.md](https://github.com/inspec/inspec-azure#service-principal) for more
information on setting up a service account, which will also be referred to as
a service principal.

When you run InSpec, Subscription ID will be included in
the target. `-t azure://$SUBSCRIPTION_ID`.

To find your Subscription ID:

1. Sign in to the Azure Portal.
2. Click "All Services".
3. Copy the Subscription ID.

To find your Tenant ID:

1. Sign in to the Azure Portal.
2. Click "Azure Active Directory".
3. Click "Properties".
4. "Directory ID" is your Tenant ID.
5. Copy the "Directory ID" value.

## Precedence

1. If Client ID and Client Secret are set as environment variables then only
   environment variables will be used.
2. If Client ID and Client Secret are not set then we will attempt to parse the
   credentials file. The credentials file will override `AZURE_TENANT_ID` if it
   is both an environment variable and in the credentials file.
3. If Client ID and Client Secret are not set and the MSI port is open then the
   MSI connector will be used.

## Environment Variables

Your account information will be read off of environment variables.

On Linux:
```
export AZURE_CLIENT_ID=<Client ID>
export AZURE_TENANT_ID=<Tenant ID>
export AZURE_CLIENT_SECRET=<Client Secret>
```

On Windows:
```
$env:AZURE_CLIENT_ID="<Client ID>"
$env:AZURE_CLIENT_SECRET="<Tenant ID>"
$env:AZURE_TENANT_ID="<Client Secret>"
```

## Credentials File

A credentials file may also be used. The default location is
`~/.azure/credentials`. You may override the default location by setting the
environment variable `AZURE_CRED_FILE` with your credential file's path. The
credentials file is an ini file with the following structure:

```
[SUBSCRIPTION_ID]
TENANT_ID = <Tenant ID>
CLIENT_ID = <Client ID>
CLIENT_SECRET = <Client Secret>
```

Multiple Subscription IDs may be added by adding additional `[SUBSCRIPTION_ID]` sections:

```
[SUBSCRIPTION_ID_1]
TENANT_ID = <Tenant ID 1>
CLIENT_ID = <Client ID 1>
CLIENT_SECRET = <Client Secret 1>

[SUBSCRIPTION_ID_2]
TENANT_ID = <Tenant ID 2>
CLIENT_ID = <Client ID 2>
CLIENT_SECRET = <Client Secret 2>
```

The Azure train connector will select the correct information based on the
Subscription ID you pass in the target parameter: `-t
azure://SUBSCRIPTION_ID_2` would choose the second entry in the credentials
file.

If you have a single entry in your credentials file, then you may omit the
Subscription ID from the target flag.

`-t azure://`

You may also set an environment variable `AZURE_SUBSCRIPTION_NUMBER` to choose a
subscription based on its index in the file. The index is 1 based with this
environment variable. So if you wish to select the second entry in a file with
two entries:

```
$ export AZURE_SUBSCRIPTION_NUMBER=2
$ bundle exec insepc exec . -t azure://
```

## Managed Service Identity Connector

A Managed Service Identity (MSI) connector may be used as well. For more
information about MSI see
[What is Managed Service Identity for Azure resources?](https://docs.microsoft.com/en-us/azure/active-directory/managed-service-identity/overview).
You will need shell or desktop access to an Azure virutal machine with MSI
enabled. When running a Chef Compliance profile while on that machine's shell
or desktop Train will attempt to use the MSI connector.

This method requires only a Subscription ID, which should be included with the
target flag `-t azure://SUBSCRIPTION_ID`. We will use the MSI connector when no
Client ID and Client Secret are present and the MSI port is open (50342 by
default). You may change the default port by setting `AZURE_MSI_PORT` with the
port you have configured as an environment variable.

The VM account must have contributor role for your subscription for this
resource pack to function.

*note:* MSI support was added in Train 1.4.35 for this resource pack.
Unfortunately, the Graph API is not support at this time. We will update this
guide when Graph API is supported.
