# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).

## [1.3.0] - 2018.10.25
[Full Changelog](https://github.com/inspec/inspec-azure/compare/1.2.0...1.3.0)

**Enhancements:**

- Requests to Azure REST API now include an InSpec User Agent.

- Adds Resource creation guide. Thank you for your contribution @[Matt Mclane](https://github.com/mmclane)!

**New Resources:**

  * azurerm_storage_account_blob_container  [Ruairi Fennell](https://github.com/r-fennell)
  * azurerm_storage_account_blob_containers [Ruairi Fennell](https://github.com/r-fennell)
  * azurerm_key_vault_key                   [Ruairi Fennell](https://github.com/r-fennell)
  * azurerm_key_vault_keys                  [Ruairi Fennell](https://github.com/r-fennell)
  * azurerm_key_vault_secret                [Ruairi Fennell](https://github.com/r-fennell)
  * azurerm_key_vault_secrets               [Ruairi Fennell](https://github.com/r-fennell)

**Bug Fixes:**

- Tags are no longer converted to a struct. It should be easier to validate the tags as a hash in your control. Fixes [\#138](https://github.com/chef/inspec-azure/issues/138)

- `azurerm_storage_accounts` may now be scoped by resource group.

- Cleans up formatting on documentation.

## [1.2.0] - 2018.09.14
[Full Changelog](https://github.com/inspec/inspec-azure/compare/1.1.0...1.2.0)

**Enhancements:**

- Resources are now backed by structs instead of hashes. You may now access all of the properties of a resources without needing custom methods. Fixes [\#106](https://github.com/chef/inspec-azure/issues/106).

- Replaces connection authentication with Train. The available connection strategies are documented [here](docs/reference/connectors.md).

- Adds `pricing_tier` field to Security Center resource. Thank you for your contribution [Yarick Tsagoyko](https://github.com/yarick)!

- Adds links to Azure documentation and includes REST API version in resource documentation.

**New Resources:**

  * azurerm_key_vault        [Ruairi Fennell](https://github.com/r-fennell)
  * azurerm_key_vaults       [Ruairi Fennell](https://github.com/r-fennell)
  * azurerm_sql_database     [Ruairi Fennell](https://github.com/r-fennell)
  * azurerm_sql_databases    [Ruairi Fennell](https://github.com/r-fennell)
  * azurerm_sql_server       [Ruairi Fennell](https://github.com/r-fennell)
  * azurerm_sql_servers      [Ruairi Fennell](https://github.com/r-fennell)
  * azurerm_storage_account  [Paul Welch](https://github.com/pwelch)
  * azurerm_storage_accounts [Paul Welch](https://github.com/pwelch)
  * azurerm_subnet           [Matt Mclane](https://github.com/mmclane)
  * azurerm_subnets          [Matt Mclane](https://github.com/mmclane)

Thank you for your contribution @[Matt Mclane](https://github.com/mmclane)!

**Bug Fixes:**

- Removes `source` command from Rakefile, which was causing an error after each rake command.

## [1.1.0] - 2018.08.09
[Full Changelog](https://github.com/inspec/inspec-azure/compare/1.0.0...1.1.0)

**Enhancements:**

- Adds resources to see AD users in your Azure Subscription. These resources require elevated permissions see the [README.md](README.md) for more information. Thank you for your contribution [Ruairi Fennell](https://github.com/r-fennell)!
  * azurerm_ad_user
  * azurerm_ad_users

- Adds resources to see your Virtual Network in your Azure Subscription. Thank you for your contribution [Matt Mclane](https://github.com/mmclane)!
  * azurerm_virtual_network
  * azurerm_virtual_networks

- Adds development enhancement for choosing optional components. See the [README.md](README.md) for more information.

- Renames resources to `azurerm` from `azure`. Resources namespaced with `azure` are deprecated and will give a warning when used.

- Updates filter table syntax usages.

## [1.0.0] - 2018.06.28
- Replaced with REST API-backed implementation

## [0.5.0](https://github.com/chef/inspec-azure/tree/0.5.0) (2017-03-01)
[Full Changelog](https://github.com/chef/inspec-azure/compare/0.4.0...0.5.0)

**Implemented enhancements:**

- Add integration tests [\#19](https://github.com/chef/inspec-azure/issues/19)
- Specify the subscription to be used by index [\#15](https://github.com/chef/inspec-azure/issues/15)

**Fixed bugs:**

- Alternative subscriptions cannot be loaded from the credentials file [\#14](https://github.com/chef/inspec-azure/issues/14)

**Closed issues:**

- Fix how internal libraries are loaded [\#11](https://github.com/chef/inspec-azure/issues/11)

**Merged pull requests:**

- Added integration tests for current resources [\#20](https://github.com/chef/inspec-azure/pull/20) ([russellseymour](https://github.com/russellseymour))
- add contribution guidelines and license [\#18](https://github.com/chef/inspec-azure/pull/18) ([chris-rock](https://github.com/chris-rock))
- remove .kitchen logs [\#17](https://github.com/chef/inspec-azure/pull/17) ([chris-rock](https://github.com/chris-rock))
- Using Credentials [\#16](https://github.com/chef/inspec-azure/pull/16) ([russellseymour](https://github.com/russellseymour))

## [0.4.0](https://github.com/chef/inspec-azure/tree/0.4.0) (2017-02-23)
[Full Changelog](https://github.com/chef/inspec-azure/compare/0.3.1...0.4.0)

**Merged pull requests:**

- Fixed loading of internal classes [\#13](https://github.com/chef/inspec-azure/pull/13) ([russellseymour](https://github.com/russellseymour))
- Updated how internal libraries are located [\#12](https://github.com/chef/inspec-azure/pull/12) ([russellseymour](https://github.com/russellseymour))

## [0.3.1](https://github.com/chef/inspec-azure/tree/0.3.1) (2017-02-21)
[Full Changelog](https://github.com/chef/inspec-azure/compare/0.3.0...0.3.1)

**Closed issues:**

- Remove Azure resource class helpers [\#9](https://github.com/chef/inspec-azure/issues/9)

**Merged pull requests:**

- Reconfigured the way in which Helpers work [\#10](https://github.com/chef/inspec-azure/pull/10) ([russellseymour](https://github.com/russellseymour))

## [0.3.0](https://github.com/chef/inspec-azure/tree/0.3.0) (2017-02-20)
**Closed issues:**

- Add resource to check the status of a Resource Group [\#6](https://github.com/chef/inspec-azure/issues/6)
- Add resources for checking the VM [\#5](https://github.com/chef/inspec-azure/issues/5)
- Cannot determine the return for a filter [\#3](https://github.com/chef/inspec-azure/issues/3)
- Add resource to check for presence and size of data disk [\#1](https://github.com/chef/inspec-azure/issues/1)

**Merged pull requests:**

- Added support for checking Resource Group resources [\#8](https://github.com/chef/inspec-azure/pull/8) ([russellseymour](https://github.com/russellseymour))
- Added more VM resource controls [\#7](https://github.com/chef/inspec-azure/pull/7) ([russellseymour](https://github.com/russellseymour))
- Testing Machine data disks [\#4](https://github.com/chef/inspec-azure/pull/4) ([russellseymour](https://github.com/russellseymour))



\* *This Change Log was automatically generated by [github_changelog_generator](https://github.com/skywinder/Github-Changelog-Generator)*
