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

## Syntax

## Parameters

## Properties

## Examples

## Matchers

For a full list of available matchers, please visit our [Universal Matchers page](https://docs.chef.io/inspec/matchers/).
