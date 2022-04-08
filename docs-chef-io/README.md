# Chef InSpec Azure Resource Documentation

Home page of the InSpec Azure resource documentation is at <https://docs.chef.io/inspec/resources/#azure>.

We use [Hugo](https://gohugo.io/) to incorporate documentation from this repository into `chef/chef-web-docs` and deploy it on <https://docs.chef.io>.

## Documentation Content

### Resource Pages

All resource pages are located in `docs-chef-io/content/inspec/resources/`.

Create a new page by duplicating an old page and then update the new page with content relevant to the new resource.

You can also run `hugo new -k resource inspec/resources/RESOURCE_NAME.md` to generate a new resource page from scratch.

See our [style guide](https://docs.chef.io/style_index/) for suggestions on writing documentation.

#### Front Matter

At the top of each resource is a block of front matter, which Hugo uses to add a title to each page and locate each page in the left navigation menu in <docs.chef.io>. Below is an example of a page's front matter:

```toml
+++
title = "RESOURCE NAME resource"
platform = "azure"
gh_repo = "inspec-azure"

[menu.inspec]
title = "RESOURCE NAME"
identifier = "inspec/resources/azure/RESOURCE NAME"
parent = "inspec/resources/azure"
+++
```

`title` is the page title.

`platform = azure` sorts each page into the correct category in the [Chef InSpec resources list page](https://docs.chef.io/inspec/resources/).

`gh_repo = "inspec-azure"` adds an "[edit on GitHub]" link to the top of each page that links to the Markdown page in the inspec/inspec-azure repository.

`[menu.inspec]` places the page in the Chef InSpec section of the left navigation menu in <docs.chef.io>. All the parameters following this configure the link in the left navigation menu to the page.

`title` is the title of page in the Chef InSpec menu.

`identifier` is the identifier for a page in the menu. It should formatted like this: `inspec/resources/azure/resource name`.

`parent = "inspec/resources/azure"` is the identifier for the section of the menu that the page will be found in. This value is set in the [chef-web-docs menu config](https://github.com/chef/chef-web-docs/blob/main/config/_default/menu.toml).

### Shortcodes

A shortcode is a file with a block of text that can be added in multiple places in our documentation by referencing the shortcode file name.

This documentation set has three shortcodes located in the `docs-chef-io/layouts/shortcodes` directory:

- azure_permissions_service_principal.md
- inspec_azure_common_parameters.md
- inspec_azure_install.md

Add a shortcode to a resource page by wrapping the filename, without the `.md` file suffix, in double curly braces and percent symbols. For example: `{{% inspec_azure_install %}}`.

The `azure_permissions_service_principal.md` shortcode requires a `role` parameter, which is the role that the service principal must have for the subscription that will be tested. For example, the azure_redis_cache Resource page has:

```md
{{% azure_permissions_service_principal role="contributor" %}}
```

which will render the following text:

> Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be set up with at least a `contributor` role on the subscription you wish to test.

{{< note >}}

You can add shortcodes from other repositories. For example, the `inspec_filter_table.md` and the `inspec_matchers_link.md` shortcodes are both located in the chef/chef-web-docs repository, but they can be added to this documentation set using the same method described above.

{{< /note >}}

### Release Dates

The chef/chef-web-docs repository uses the `release-dates.json` file in `docs-chef-io/assets/release-notes/inspec-azure` to generate release notes on <https://docs.chef.io/release_notes_inspec_azure/>. See below for more information on release notes for inspec-azure.

## Update the InSpec Repository Module In `chef/chef-web-docs`

We use [Hugo modules](https://gohugo.io/hugo-modules/) to build Chef's documentation from multiple repositories.

When release notes are announced for inspec-azure, the documentation for inspec-azure is updated at the same time. See the section below on release notes.

A member from the Documentation Team can also update the inspec-azure resource documentation at any time when new resources are ready to be added to <docs.chef.io>.

## Local Development Environment

We use [Hugo](https://gohugo.io/), [Go](https://golang.org/), and[NPM](https://www.npmjs.com/) to build the Chef Documentation website. You will need Hugo 0.93.1 or higher installed and running to build and view our documentation.

To install Hugo, NPM, and Go on Windows and macOS:

- On macOS run: `brew install hugo node go`
- On Windows run: `choco install hugo nodejs golang -y`

To install Hugo on Linux, run:

- `apt install -y build-essential`
- `snap install node --classic --channel=12`
- `snap install hugo --channel=extended`

## Preview InSpec Azure Resource Documentation

### make serve

Run `make serve` to build a local preview of the InSpec Azure resource documentation. This clones a copy of `chef/chef-web-docs` into the `docs-chef-io` directory and configures to build the InSpec Azure resource documentation. Then the live reload happens if any changes made while the Hugo server is running.

- Run `make serve`
- go to <http://localhost:1313/inspec/resources/#azure>

### Clean Your Local Environment

Run `make clean_all` to delete the cloned copy of chef/chef-web-docs.

## Publish Release Notes

The process for publishing and announcing release notes for inspec-azure is mostly manual.

### Edit Pending Release Notes

Edit the Pending Release Notes file in the [inspec-azure wiki](https://github.com/inspec/inspec-azure/wiki/Pending-Release-Notes).

We recommend editing this page as new resources are added or changes are made to the inspec-azure resources.

Have a member of the documentation team review the Pending Release Notes file before they're released.

### Release the Release Notes

1. Log in to the chef-cd S3 account using saml2aws.

2. Run the `publish-release-notes.sh` script in `tools/release-notes`. You can run this from the Makefile with `make publish_release_notes`

   This command pushes the pending release notes to the S3 chef-cd bucket, reset the Pending Release Notes file, and update the `release-dates.json` file in `assets/release-notes/inspec-azure`.

3. Push up and merge a branch to `inspec/inspec-azure` with the changes made to the `release-dates.json` file.

### chef-web-docs

chef-web-docs is configured to open a PR that updates the inspec-azure content on <doc.chef.io> when a change is committed to the `release-dates.json` file in the inspec-azure repository. This updates the InSpec Azure resource documentation and update release notes for InSpec Azure resources.

A member fo the documentation team can merge that PR for you as soon as it's made.

### Chef Discourse

Copy the release notes to a new announcement in [Chef Release Announcements](https://discourse.chef.io/c/chef-release/9) on Discourse.

You can find the proper release notes in the Pending Release Notes file history or on <https://packages.chef.io/release-notes/inspec-azure/RELEASE_DATE.md>

## Documentation Feedback

If you need support, contact [Chef Support](https://www.chef.io/support/).

### GitHub issues

Submit an issue to the [inspec-azure repo](https://github.com/inspec/inspec-azure/issues) for **important** documentation bugs that may need visibility among a larger group, especially in situations where a documentation bug may also surface a product bug.

Submit an issue to [chef-web-docs](https://github.com/chef/chef-web-docs/issues) for documentation feature requests and minor documentation issues.
