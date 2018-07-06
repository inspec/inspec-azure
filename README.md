# InSpec for Azure

## Getting Started

Copy `.envrc-example` to `.envrc` and fill in the fields with the values from your account.

```
export AZURE_SUBSCRIPTION_ID=<subscription id>
export AZURE_CLIENT_ID=<client id>
export AZURE_TENANT_ID=<tenant id>
export AZURE_CLIENT_SECRET=<client secret>
```

For PowerShell, set the following environment variables
```
$env:AZURE_SUBSCRIPTION_ID="<subscription id>"
$env:AZURE_CLIENT_ID="<client id>"
$env:AZURE_CLIENT_SECRET="<tenant id>"
$env:AZURE_TENANT_ID="<client secret>"
```

**Setup Azure CLI**
- Follow the instructions for your platform [here](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
  * macOS: `brew update && brew install azure-cli`
- Login with the azure-cli
  * `rake azure:login`
- Verify azure-cli is logged in:
  * `az account show`

## Starting an Environment

First ensure your system has [Terraform](https://www.terraform.io/intro/getting-started/install.html) (Version 0.11.7) installed.

This environment may be used to run your profile against or to run integration tests on it. We are using [Terraform workspaces](https://www.terraform.io/docs/state/workspaces.html) to allow for teams to have completely unique environments without affecting each other.

### Direnv

[Direnv](https://direnv.net/) is used to initial an environment variable `WORKSPACE` to your username. We recommend using `direnv` and allowing it to run in your environment. However, if you prefer to not use `direnv` you may also `source .envrc`.

### Remote State

Remote state is being used to store the Terraform state file. You'll need the following configuration keys to enable remote state:

```
TF_STORAGE_ACCOUNT_NAME=
TF_ACCESS_KEY=
TF_CONTAINER_NAME=$WORKSPACE
```

By convention `TF_CONTAINER_NAME` will always be your workspace name. To get started:

1. Log into Azure
2. Add a container matching your workspace name (likely whatever `whoami` resolves to on your machine, unless you overrode the default).
3. Ensure you update your `.envrc` with those new keys and your other account settings.
4. Either run `source .envrc` (or `direnv allow` if you use the direnv tool).
5. Now when you run `rake azure:login tf:apply` you should be initialized with remote state. If you have an existing state file Terraform may prompt you to upload the state from your machine to the container in Azure.

### Rake commands

Creating a new environment:
```
rake azure:login
rake tf:apply
```

Creating a new environment with a Network Watcher:
```
rake azure:login
rake network_watcher tf:apply
```
You may only have a single Network Watcher per a subscription. Use this carefully if you are working with other team members.

Updating a running environment (e.g. when you change the .tf file):
```
rake azure:login
rake tf:apply
```

Checking if your state has diverged from your plan:
```
rake azure:login
rake tf:plan
```

Destroying your environment:
```
rake azure:login
rake tf:destroy
```

## Running integration tests

To start up an environment and run all tests:
```
bundle
rake azure:login
rake azure
```

## Development

To run all tests:
```
bundle
rake
```

To run integration tests:
```
bundle
rake test:integration
```

To run integration tests including a Network Watcher:
```
bundle
rake network_watcher test:integration
```

To run a control called `azurerm_virtual_machine`:
```
bundle
rake test:integration[azurerm_virtual_machine]
```

You may run multiple controls:
```
bundle
rake test:integration[azure_resource_group,azurerm_virtual_machine]
```
