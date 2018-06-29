# Management API Methods

## Summary

The Azure Management API (distinct from several other Azure APIs) provides
dozens of resources and providing methods to access them in our proxy object
(`Azure::Management`) necessitating rote implementations in our code to access
those resources and work with the returned values.

Due to the high uniformity of the resource access and handling implementations,
we are able to extract the data describing those resources and our expectations
of them and use a single implementation to produce the needed code.

## Implementation

There are three main parts to the implementation:

 * the resource data, `management.yaml`
 * The resource method generator, 'Azure::ManagementMethodGenerator`
 * the proxy object, 'Azure::Management`

### `management.yaml`

#### Example
```yaml
name: 'Virtual Machine'
location: 'Microsoft.Compute/virtualMachines'
api_version: '2017-12-01'
singular: true
plural: true
resource_group: true
provider: true
```

#### Key
 * **name:** used to name the generated method(s)
 * **location:** used to generate the resource URL
 * **api_version:** version to use for this resource
 * **singular:** whether there is a singular form of this resource
 * **plural:** whether there is a plural form of this resource
 * **resource_group:** whether a resource group is required to access this resource
 * **provider:** whether this resource is a "provider" (part of URL)

#### Usage

When adding support for Azure resources provided by the Management API you will
add at least one entry to `management.yaml`. The purpose and usage of some
attributes is not immediately obvious, so I'll discuss them further here.

Each resource may support either *singular* or *plural* forms, or both. A
plural resource will return a list of values, and a singular resource will
expect a unique key (usually *name*) identifier. Depending on the boolean value
given to *singular* and *plural* attributes, methods for one or both of those
queries will be generated.

Also affecting what form the query methods take is the value given for
*resource_group*. When a resource group is required to access a resource, this
attribute should be *true*. Usually if a resource group is required for the
plural form it will be required for the singular form, or vice versa, but
sometimes it will only be required for one form when both are present. (Ex:
*singular* and *plural* are true, but *resource_group* is only required for
*singular*.) When this is the case, you'll have to create separate entries in
`management.yaml` to describe the distinct resource group requirement.

### `Azure::ManagementMethodGenerator`

This module exposes a `generate` method that requires a path to the YAML file
describing the Manage API resources to use, and returns a collection of values,
names and lambdas, to be assembled by the caller as methods on itself.

All of the logic for constructing the method names and bodies is encapsulated
in this module; clients are expected to use the data however it makes sense in
their context, decorating themselves or other objects.

### `Azure::Management`

This singleton object is a proxy for the Azure Management API, and it decorates
itself with the methods enumerated by `Azure::ManagementMethodGenerator`,
making those API resources available to its clients. For example:

```ruby
Azure::Management.instance.security_center_policies
```
or
```ruby
Azure::Management.instance.virtual_machine('rg-name', 'vm-name')
```
