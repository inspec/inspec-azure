+++
title = "{{ .Name | humanize | title }} resource"
draft = false
gh_repo = "inspec"
platform = "azure"

[menu]
  [menu.inspec]
    title = "{{ .Name | humanize | title }}"
    identifier = "inspec/resources/azure/{{ .Name | humanize | title }}"
    parent = "inspec/resources/azure"
+++


{{% Run `hugo new -k resource resources/RESOURCE_NAME.md` to generate a new resource page. %}}

## Azure REST API Version, Endpoint, and HTTP Client Parameters

{{% inspec_azure_common_parameters %}}

## Installation

{{% inspec_azure_install %}}

## Syntax

```ruby

```

## Parameters

`PARAMETER`
: PARAMETER DESCRIPTION

`PARAMETER`
: PARAMETER DESCRIPTION

## Properties

`PROPERTY`
: PROPERTY DESCRIPTION

`PROPERTY`
: PROPERTY DESCRIPTION

## Examples

**EXAMPLE DESCRIPTION**

```ruby

```

**EXAMPLE DESCRIPTION**

```ruby

```

## Matchers

For a full list of available matchers, please visit our [Universal Matchers page](https://docs.chef.io/inspec/matchers/).

## Azure Permissions

{{% azure_permissions_service_principal role="ROLE" %}}
