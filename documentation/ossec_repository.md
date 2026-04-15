# ossec_repository

Manages the Atomicorp package repository used by this cookbook.

## Actions

- `:create`: Creates the platform-appropriate package repository
- `:delete`: Removes the package repository

## Properties

This resource has no user-facing properties.

## Examples

### Add the repository

```ruby
ossec_repository 'default'
```

### Remove the repository

```ruby
ossec_repository 'default' do
  action :delete
end
```
