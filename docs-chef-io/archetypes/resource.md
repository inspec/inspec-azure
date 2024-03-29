+++
title = "{{ .Name }} resource"
draft = false
gh_repo = "inspec"
platform = "azure"

[menu]
  [menu.inspec]
    title = "{{ .Name }}"
    identifier = "inspec/resources/azure/{{ .Name }}"
    parent = "inspec/resources/azure"
+++
{{/* Run `hugo new -k resource inspec/resources/RESOURCE_NAME.md` to generate a new resource page. */}}

Use the `{{ .Name }}` Chef InSpec audit resource to test properties of...

## Azure REST API Version, Endpoint, and HTTP Client Parameters

{{< readfile file="content/inspec/resources/reusable/md/inspec_azure_common_parameters.md" >}}

## Install

{{< readfile file="content/inspec/resources/reusable/md/inspec_azure_install.md" >}}

## Syntax

```ruby
describe {{ .Name }} do

end
```

## Parameters

`PARAMETER` _(required)_
: PARAMETER DESCRIPTION

`PARAMETER` _(optional)_
: PARAMETER DESCRIPTION

## Properties

`PROPERTY`
: PROPERTY DESCRIPTION

`PROPERTY`
: PROPERTY DESCRIPTION

## Examples

EXAMPLE DESCRIPTION

```ruby
describe {{ .Name }} do

end
```

EXAMPLE DESCRIPTION

```ruby
describe {{ .Name }} do

end
```

## Matchers

{{< readfile file="content/inspec/reusable/md/inspec_matchers_link.md" >}}

## Azure Permissions

{{% azure_permissions_service_principal role="ROLE" %}}
