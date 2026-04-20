# ossec_install

Installs or removes the OSSEC server or agent package, and manages the package
repository by default.

## Actions

- `:create`: Installs the requested package and stops or disables the packaged
  service
- `:delete`: Stops or disables the service, removes the package, and optionally
  removes the repository

## Properties

- `package_type` (`String`, default: name): Package role. Must be `server` or
  `agent`
- `manage_repository` (`Boolean`, default: `true`): Whether the
  `ossec_repository` resource should be managed

## Examples

### Install the server package

```ruby
ossec_install 'server'
```

### Install the agent package without touching the repository

```ruby
ossec_install 'agent' do
  manage_repository false
end
```
